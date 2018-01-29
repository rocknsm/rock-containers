# Dockerfile for kafka

FROM rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.bro="2.5.2-3-20180128"

ENV BRO_NODE_INTERFACE="eth1"
ENV BRO_NODE_NUMWORKERS="2"
ENV BRO_KAFKA_BROKER="kafka:9092"
ENV BRO_SCRIPTS_GIT="https://github.com/rocknsm/rock-scripts.git"
ENV BRO_SCRIPTS_BRANCH="master"

# Add configuration templates
COPY bro_broctl.cfg.toml /etc/confd/conf.d/
COPY bro_broctl.cfg.tmpl /etc/confd/templates/
COPY bro_node.cfg.toml  /etc/confd/conf.d/
COPY bro_node.cfg.tmpl  /etc/confd/templates/

# Add script to sync bro scripts
COPY bro-scripts.env.toml /etc/confd/conf.d/
COPY bro-scripts.env.tmpl /etc/confd/templates/
COPY bro-scripts.service /etc/systemd/system/
COPY bro-scripts-update.sh /usr/local/sbin/

# Prepare the environment and get things up to date
RUN yum update -y; \
  yum install -y git bro bro-plugin-kafka bro-plugin-af_packet; \
  rm -rf /var/cache/yum/*; \
  systemctl enable bro.service bro-scripts.service;

# systemd starts by default (from parent)
