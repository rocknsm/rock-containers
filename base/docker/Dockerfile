FROM centos/systemd
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.platform="3.0.0"
LABEL io.rocknsm.base="0.0.8"

ENV container docker
STOPSIGNAL SIGRTMIN+3

COPY rocknsm-2.1.repo /etc/yum.repos.d/rocknsm-2.1.repo

# Add confd as a standard way to render configs
RUN yum -y update; yum install -y confd epel-release; \
    mkdir -p /etc/confd/{conf.d,templates}; \
    rm -rf /var/cache/yum/*; 

COPY rocknsm-metadata.sh /usr/local/sbin/
COPY rocknsm-metadata.service /usr/lib/systemd/system/

# TODO Add this to the RPM
COPY confd.service /usr/lib/systemd/system/

RUN systemctl enable rocknsm-metadata confd; \
    chmod 0755 /usr/local/sbin/rocknsm-metadata.sh;

# Start systemd
CMD ["/usr/sbin/init"]

