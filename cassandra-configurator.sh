#!/bin/bash
set -e

if [ -z "$NAME" ]; then
    echo "NAME is not set. Setting default value."
    NAME="$(hostname --ip-address)"
    echo "Now NAME=$NAME"
fi

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
	set -- cassandra -f "$@"
fi

function init_cassandra {
	# TODO detect if this is a restart if necessary
	: ${CASSANDRA_LISTEN_ADDRESS='auto'}
	if [ "$CASSANDRA_LISTEN_ADDRESS" = 'auto' ]; then
		CASSANDRA_LISTEN_ADDRESS="$NAME"
	fi

	: ${CASSANDRA_BROADCAST_ADDRESS="$CASSANDRA_LISTEN_ADDRESS"}

	if [ "$CASSANDRA_BROADCAST_ADDRESS" = 'auto' ]; then
		CASSANDRA_BROADCAST_ADDRESS="$NAME"
	fi
	: ${CASSANDRA_BROADCAST_RPC_ADDRESS:=$CASSANDRA_BROADCAST_ADDRESS}

	: ${CASSANDRA_SEEDS:="$CASSANDRA_PORT_9042_TCP_ADDR"}
	: ${CASSANDRA_SEEDS:="$CASSANDRA_BROADCAST_ADDRESS"}

	sed -ri 's/(- seeds:).*/\1 "'"$CASSANDRA_SEEDS"'"/' "$CASSANDRA_CONFIG/cassandra.yaml"

	for yaml in \
		broadcast_address \
		broadcast_rpc_address \
		cluster_name \
		endpoint_snitch \
		listen_address \
		num_tokens \
		rpc_address \
		start_rpc \
	; do
		var="CASSANDRA_${yaml^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' "$CASSANDRA_CONFIG/cassandra.yaml"
		fi
	done

	for rackdc in dc rack; do
		var="CASSANDRA_${rackdc^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^('"$rackdc"'=).*/\1 '"$val"'/' "$CASSANDRA_CONFIG/cassandra-rackdc.properties"
		fi
	done
}

CONFIG_FILE=${SUPERVISOR_CONF_DEFAULT}

case "$1" in
    "master")
        CONFIG_FILE=${SUPERVISOR_CONF_MASTER}
        ;;
    "worker")
        CONFIG_FILE=${SUPERVISOR_CONF_WORKER}
        init_cassandra
        ;;
    "cassandra")
        CONFIG_FILE=${SUPERVISOR_CONF_CASSANDRA}
        init_cassandra
        ;;
esac

exec /usr/bin/supervisord -c ${CONFIG_FILE}
