FROM openjdk:8u191-jdk-alpine

ENV KM_VERSION=1.3.3.22 \
    KM_CONFIGFILE="conf/application.conf" \
    KM_HOME=/opt/kafka-manager

ENV PATH=${PATH}:${KM_HOME}/bin

COPY start-kafka-manager.sh /usr/bin/start-kafka-manager
ADD kafka-manager-${KM_VERSION}.tar.gz /opt/

RUN apk add --no-cache bash jq && \
    ln -s ${KM_HOME}-${KM_VERSION} ${KM_HOME} && \
    cd ${KM_HOME} && \    
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /usr/bin/start-kafka-manager
    
WORKDIR ${KM_HOME}

EXPOSE 9000
CMD ["start-kafka-manager"]
