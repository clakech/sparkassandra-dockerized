#!/usr/bin/env bash

if [ -z "$NAME" ]; then
    echo "NAME is not set. Setting default value."
    NAME="$(hostname --ip-address)"
    echo $NAME
fi

#export SPARK_MASTER_IP=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
#export SPARK_LOCAL_IP=$SPARK_MASTER_IP
export SPARK_MASTER_IP=$NAME
export SPARK_LOCAL_IP=$NAME
/usr/local/spark/sbin/start-master.sh --properties-file /spark-defaults.conf -i $SPARK_LOCAL_IP "$@"
/bin/bash
