# Dockerfile for kafka

FROM rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.kafka="1.0.0-1"

ENV KAFKA_USER="kafka"
ENV KAFKA_DATADIR="/var/lib/kafka/"
ENV KAFKA_BROKER_CONF='{ \
    "broker.id": 1, \
    "listeners": "PLAINTEXT://:9092", \
    "advertised.listeners": "PLAINTEXT://:9092", \
    "zookeeper.connect": "127.0.0.1:2181" \
    "log.dirs": "${KAFKA_DATADIR}" \
  }'
ENV KAFKA_LOG4J_LOGDIR="/var/log/kafka/"
ENV KAFKA_LOG4J_LEVEL="INFO"

# Prepare the environment and get things up to date
RUN yum update -y; \
  yum install -y kafka java-1.8.0-openjdk-headless kafkacat; \
  rm -rf /var/cache/yum/*; \
  mkdir -p "$KAFKA_DATADIR" \
           "$KAFKA_LOGDIR"; \
  chown -R "$KAFKA_USER:$KAFKA_USER" \
           "$KAFKA_DATADIR" \
           "$KAFKA_LOGDIR"; \
  systemctl enable kafka;

# Add configuration templates
COPY kafka_server.properties.toml /etc/confd/conf.d/
COPY kafka_server.properties.tmpl /etc/confd/templates/
COPY kafka_log4j.properties.toml  /etc/confd/conf.d/
COPY kafka_log4j.properties.tmpl  /etc/confd/templates/

# Expose data dirs
EXPOSE 9092

# systemd starts by default (from parent)
