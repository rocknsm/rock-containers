#!/bin/bash

# Systemd does not inherit environment variables so
# so this grabs them from proc
for e in $(tr "\000" "\n" < /proc/1/environ); do
        eval "export $e"
done


# Create zookeeper list
ZOOKEEPER_LIST=""
if [ -v INSTANCE_ID ]; then
ID="$INSTANCE_ID"
ZOOKEEPER_LIST=`echo $HOSTNAME`":${ZOOKEEPER_PORT}"
else
# Use hostname if broker id var doesnt exist
ID=`echo $HOSTNAME | cut -d'-' -f2`
count=$(expr ${ZOOKEEPER_REPLICAS} - 1)
for i in `seq 0 $count`;
do
t="zookeeper-$i.zookeeper.default.svc.cluster.local:${ZOOKEEPER_PORT}"
ZOOKEEPER_LIST=$ZOOKEEPER_LIST,$t
done
# Remove first comma
ZOOKEEPER_LIST=`echo $ZOOKEEPER_LIST | sed 's/^,\(.*\)/\1/'`
fi

# Start Kafka service
${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/server.properties --override broker.id=$ID \
          --override zookeeper.connect=$ZOOKEEPER_LIST