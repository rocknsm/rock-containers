# Dockerfile for dnsmasq

FROM quay.io/rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.dnsmasq="2.79-20180927.2"

# Prepare the environment and get things up to date
RUN yum install -y --setopt=tsflags=nodocs dnsmasq; \
  rm -rf /var/cache/yum/*; \
  mkdir -p /etc/systemd/system/dnsmasq.service.d; \
  echo -e "[Service]\nExecStart=\nExecStart=/usr/sbin/dnsmasq -k -d" | \
    tee /etc/systemd/system/dnsmasq.service.d/override.conf; \
  systemctl enable dnsmasq;

COPY dnsmasq.conf.tmpl /etc/confd/templates/
COPY dnsmasq.toml /etc/confd/conf.d/

# Expose ports
EXPOSE 53/udp
EXPOSE 53/tcp

# systemd starts by default (from parent)
