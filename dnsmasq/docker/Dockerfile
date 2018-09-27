# Dockerfile for dnsmasq

FROM quay.io/rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.dnsmasq="2.79-20180923"

# Prepare the environment and get things up to date
RUN dnf install -y --setopt=tsflags=nodocs dnsmasq; \
  rm -rf /var/cache/dnf/*; \
  mkdir -p /etc/systemd/system/dnsmasq.service.d; \
  echo -e "[Service]\nExecStart=\nExecStart=/usr/sbin/dnsmasq -k -d" | \
    tee /etc/systemd/system/dnsmasq.service.d/override.conf; \
  systemctl enable dnsmasq;

COPY dnsmasq.conf.tmpl /etc/confd/templates/
COPY dnsmasq.toml /etc/confd/conf.d/

# Expose ports
EXPOSE 5353/udp
EXPOSE 5353/tcp

# systemd starts by default (from parent)
