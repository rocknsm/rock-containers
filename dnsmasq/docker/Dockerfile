# Dockerfile for dnsmasq

FROM rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.dnsmasq="2.79-20180923"

# Prepare the environment and get things up to date
RUN dnf install -y --setopt=tsflags=nodocs dnsmasq; \
  rm -rf /var/cache/dnf/*; \
  systemctl enable dnsmasq;

COPY dnsmasq_confd.conf /etc/dnsmasq.d/confd.conf

# Expose ports
EXPOSE 53/udp
EXPOSE 53/tcp

# systemd starts by default (from parent)
