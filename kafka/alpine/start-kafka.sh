#!/bin/bash -e

# Store original IFS config, so we can restore it at various stages
ORIG_IFS=$IFS

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
    
    KAFKA_ZOOKEEPER_CONNECT=""
    
    if [[ -z "$ZOOKEEPER_PORT" ]]; then
      ZOOKEEPER_PORT=2181
    fi
    
    if [[ -z "$INSTANCE_ID" ]]; then
        
        if [[ -z "$ZOOKEEPER_REPLICAS" ]]; then
          ZOOKEEPER_REPLICAS=1
        fi

        # Use hostname if broker id var doesnt exist
        KAFKA_BROKER_ID=`echo $HOSTNAME | cut -d'-' -f2`
        count=$((${ZOOKEEPER_REPLICAS} - 1))
        for i in `seq 0 $count`; do
            t="zookeeper-$i.zookeeper.default.svc.cluster.local:${ZOOKEEPER_PORT}"
            KAFKA_ZOOKEEPER_CONNECT=$KAFKA_ZOOKEEPER_CONNECT,$t
        done
        # Remove first comma
        export KAFKA_ZOOKEEPER_CONNECT=`echo $KAFKA_ZOOKEEPER_CONNECT | sed 's/^,\(.*\)/\1/'`
    else
        KAFKA_BROKER_ID=$INSTANCE_ID
        if [[ -z "$ZOOKEEPER_HOSTNAME" ]]; then
          export KAFKA_ZOOKEEPER_CONNECT=`echo $HOSTNAME`":${ZOOKEEPER_PORT}"
        else
          export KAFKA_ZOOKEEPER_CONNECT="$ZOOKEEPER_HOSTNAME:${ZOOKEEPER_PORT}"
        fi        
    fi
fi

if [[ -z "$KAFKA_PORT" ]]; then
    export KAFKA_PORT=9092
fi

create-topics.sh &
unset KAFKA_CREATE_TOPICS

# DEPRECATED: but maintained for compatibility with older brokers pre 0.9.0 (https://issues.apache.org/jira/browse/KAFKA-1809)
if [[ -z "$KAFKA_ADVERTISED_PORT" && \
  -z "$KAFKA_LISTENERS" && \
  -z "$KAFKA_ADVERTISED_LISTENERS" && \
  -S /var/run/docker.sock ]]; then
    KAFKA_ADVERTISED_PORT=$(docker port "$(hostname)" $KAFKA_PORT | sed -r 's/.*:(.*)/\1/g')
    export KAFKA_ADVERTISED_PORT
fi

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    if [[ -n "$BROKER_ID_COMMAND" ]]; then
        KAFKA_BROKER_ID=$(eval "$BROKER_ID_COMMAND")
        export KAFKA_BROKER_ID
    else
        # By default auto allocate broker ID
        export KAFKA_BROKER_ID=-1
    fi
fi

if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
    sed -r -i 's/(export KAFKA_HEAP_OPTS)="(.*)"/\1="'"$KAFKA_HEAP_OPTS"'"/g' "$KAFKA_HOME/bin/kafka-server-start.sh"
    unset KAFKA_HEAP_OPTS
fi

if [[ -n "$HOSTNAME_COMMAND" ]]; then
    HOSTNAME_VALUE=$(eval "$HOSTNAME_COMMAND")

    # Replace any occurences of _{HOSTNAME_COMMAND} with the value
    IFS=$'\n'
    for VAR in $(env); do
        if [[ $VAR =~ ^KAFKA_ && "$VAR" =~ "_{HOSTNAME_COMMAND}" ]]; then
            eval "export ${VAR//_\{HOSTNAME_COMMAND\}/$HOSTNAME_VALUE}"
        fi
    done
    IFS=$ORIG_IFS
fi

if [[ -n "$PORT_COMMAND" ]]; then
    PORT_VALUE=$(eval "$PORT_COMMAND")

    # Replace any occurences of _{PORT_COMMAND} with the value
    IFS=$'\n'
    for VAR in $(env); do
        if [[ $VAR =~ ^KAFKA_ && "$VAR" =~ "_{PORT_COMMAND}" ]]; then
	    eval "export ${VAR//_\{PORT_COMMAND\}/$PORT_VALUE}"
        fi
    done
    IFS=$ORIG_IFS
fi

if [[ -n "$RACK_COMMAND" && -z "$KAFKA_BROKER_RACK" ]]; then
    KAFKA_BROKER_RACK=$(eval "$RACK_COMMAND")
    export KAFKA_BROKER_RACK
fi

# Try and configure minimal settings or exit with error if there isn't enough information
if [[ -z "$KAFKA_ADVERTISED_HOST_NAME$KAFKA_LISTENERS" ]]; then
    if [[ -n "$KAFKA_ADVERTISED_LISTENERS" ]]; then
        echo "ERROR: Missing environment variable KAFKA_LISTENERS. Must be specified when using KAFKA_ADVERTISED_LISTENERS"
        exit 1
    elif [[ -z "$HOSTNAME_VALUE" ]]; then
        echo "ERROR: No listener or advertised hostname configuration provided in environment."
        echo "       Please define KAFKA_LISTENERS / (deprecated) KAFKA_ADVERTISED_HOST_NAME"
        exit 1
    fi

    # Maintain existing behaviour
    # If HOSTNAME_COMMAND is provided, set that to the advertised.host.name value if listeners are not defined.
    export KAFKA_ADVERTISED_HOST_NAME="$HOSTNAME_VALUE"
fi

if [[ -n "$CUSTOM_INIT_SCRIPT" ]] ; then
  eval "$CUSTOM_INIT_SCRIPT"
fi

$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties --override broker.id=$KAFKA_BROKER_ID \
          --override zookeeper.connect=$KAFKA_ZOOKEEPER_CONNECT
