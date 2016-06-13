#!/usr/bin/env bash
export SPARK_MASTER_IP=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
export SPARK_LOCAL_IP=$SPARK_MASTER_IP
/usr/local/spark/sbin/start-master.sh --properties-file /spark-defaults.conf -i $SPARK_LOCAL_IP "$@"
/bin/bash
