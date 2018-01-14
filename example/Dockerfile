FROM centos/systemd
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.platform 3.0.0
ENV container docker
STOPSIGNAL SIGRTMIN+3

COPY rocknsm-2.1.repo /etc/yum.repos.d/rocknsm-2.1.repo

# Copy in script to configure the app. This could feasibly pull from 
# something like ETCd or take environment vars and generate configs
COPY rocknsm-metadata.sh /usr/local/sbin/rocknsm-metadata.sh

# Copy in oneshot service to config the environment
COPY rocknsm-metadata.service /usr/lib/systemd/system/rocknsm-metadata.service

RUN chmod 755 /usr/local/sbin/rocknsm-metadata.sh; systemctl enable rocknsm-metadata.service


