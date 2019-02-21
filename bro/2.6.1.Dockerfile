
# This build uses multi-stage docker builds. This requires Docker 17.05 or higher.
# For more information see https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
# This lets you do is build a docker container with all your dependencies.
# In this case, the builder has all the extra bloat that comes with making bro from
# source, but when the final image is built it only has what is required.
# You can test the container with: docker run --privileged --name bro -v /sys/fs/cgroup:/sys/fs/cgroup:ro tfplenum/bro:2.6.1

# Build Bro

FROM centos/systemd as builder
MAINTAINER Grant Curell <grantcurell@gmail.com>

ENV VER 2.6.1
ENV WD /scratch

WORKDIR /scratch

RUN yum update -y 
RUN yum install -y epel-release 
RUN yum install -y wget librdkafka-devel kernel-devel git cmake make gcc gcc-c++ flex bison libpcap-devel openssl-devel python-devel swig zlib-devel
RUN git clone https://github.com/grantcurell/bro-af_packet-plugin.git
RUN git clone https://github.com/apache/metron-bro-plugin-kafka.git
ADD ./common/buildbro ${WD}/common/buildbro
RUN ${WD}/common/buildbro ${VER} http://www.bro.org/downloads/bro-${VER}.tar.gz
RUN ls -al /usr/src/kernels/ && cd ${WD}/bro-af_packet-plugin && ./configure --bro-dist=/usr/src/bro-${VER} --with-latest-kernel && make && make install
RUN cd ${WD}/metron-bro-plugin-kafka && ./configure --bro-dist=/usr/src/bro-${VER} && make && make install

# Get geoip data

FROM centos/systemd as geogetter
RUN yum update -y && yum install -y install wget ca-certificates
ADD ./common/getmmdb.sh /usr/local/bin/getmmdb.sh
RUN /usr/local/bin/getmmdb.sh

# Build the final image

FROM centos/systemd
ENV VER 2.6.1

#install runtime dependencies
RUN yum update -y \
    && yum -y install libpcap openssl-devel libmaxminddb-devel libmaxminddb python2 librdkafka-devel iproute\
    && yum clean all

COPY --from=builder /usr/local/bro-${VER} /usr/local/bro-${VER}
COPY --from=geogetter /usr/share/GeoIP/* /usr/share/GeoIP/
COPY crontab /etc/crontab
COPY bro.service /etc/systemd/system
RUN chmod 0644 /etc/crontab && \
    ln -s /usr/local/bro-${VER} /bro && \
    systemctl enable bro && \
    mkdir -p /usr/share/bro/site/scripts/plugins

# Start systemd
CMD ["/usr/sbin/init"]