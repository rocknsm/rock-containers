#!/bin/bash

mirror=$(curl --stderr /dev/null 'https://www.apache.org/dyn/closer.cgi?as_json=1' | grep '.preferred' | awk '{ print $2 }' | sed 's/\"//g')

if [[ -z "$mirror" ]]; then
	echo "Unable to determine mirror for downloading Kafka, the service may be down"
	exit 1
fi

url="${mirror}kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz"
curl -s -o /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz ${url}
