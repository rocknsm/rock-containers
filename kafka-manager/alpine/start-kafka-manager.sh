#!/bin/bash

if [[ -z "$ZOOKEEPER_PORT" ]]; then
   export ZOOKEEPER_PORT=2181
fi

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    KAFKA_ZOOKEEPER_CONNECT="zookeeper.default.svc.cluster.local"
fi

export ZK_HOSTS=${KAFKA_ZOOKEEPER_CONNECT}:${ZOOKEEPER_PORT}

if [[ $KM_USERNAME != ''  && $KM_PASSWORD != '' ]]; then
    sed -i.bak '/^basicAuthentication/d' /kafka-manager-${KM_VERSION}/conf/application.conf
    echo 'basicAuthentication.enabled=true' >> /kafka-manager-${KM_VERSION}/conf/application.conf
    echo "basicAuthentication.username=${KM_USERNAME}" >> /kafka-manager-${KM_VERSION}/conf/application.conf
    echo "basicAuthentication.password=${KM_PASSWORD}" >> /kafka-manager-${KM_VERSION}/conf/application.conf
    echo 'basicAuthentication.realm="Kafka-Manager"' >> /kafka-manager-${KM_VERSION}/conf/application.conf
fi

exec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"
