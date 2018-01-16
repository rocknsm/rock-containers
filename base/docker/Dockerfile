FROM centos/systemd
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.platform="3.0.0"
LABEL io.rocknsm.base="0.0.2"

ENV container docker
STOPSIGNAL SIGRTMIN+3

COPY rocknsm-2.1.repo /etc/yum.repos.d/rocknsm-2.1.repo

# Add confd as a standard way to render configs
RUN yum install -y confd; \
    mkdir -p /etc/confd/{conf.d,templates}; \
    rm -rf /var/cache/yum/*; 

# Start systemd
CMD ["/usr/sbin/init"]

