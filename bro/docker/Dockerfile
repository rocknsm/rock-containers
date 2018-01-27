# Dockerfile for kafka

FROM rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.kafka="0.0.1-1"

ENV BRO_NODE_INTERFACE="eth1"
ENV BRO_NODE_NUMWORKERS="2"
ENV BRO_KAFKA_BROKER="kafka:9092"

# Prepare the environment and get things up to date
RUN yum update -y; \
  yum install -y bro bro-plugin-kafka bro-plugin-af_packet; \
  rm -rf /var/cache/yum/*; \
  systemctl enable bro;

# Add configuration templates
COPY bro_broctl.cfg.toml /etc/confd/conf.d/
COPY bro_broctl.cfg.tmpl /etc/confd/templates/
COPY bro_node.cfg.toml  /etc/confd/conf.d/
COPY bro_node.cfg.tmpl  /etc/confd/templates/

# systemd starts by default (from parent)
