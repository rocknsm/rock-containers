FROM tfplenum/base:latest

ARG kafka_version=1.0.1 
ARG scala_version=2.12

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
 
ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY download-kafka.sh /tmp/
COPY kafka.service /usr/lib/systemd/system/

RUN yum update -y && \
  yum install java-1.8.0-openjdk-headless -y && \
  chmod +x /tmp/download-kafka.sh && \
  /tmp/download-kafka.sh && \
  tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
  rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
  ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka && \
  rm /tmp/download-kafka.sh && \
  systemctl enable kafka.service && \
  yum clean all && \
  mkdir -p /data/kafka


COPY start-kafka.sh /

# Expose data dirs
EXPOSE 9092