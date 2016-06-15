#!/usr/bin/env bash

if [ -z "$NAME" ]; then
    echo "NAME is not set. Setting default value."
    NAME="$(hostname --ip-address)"
    echo $NAME
fi

cd /usr/local/spark
#export SPARK_LOCAL_IP=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
export SPARK_LOCAL_IP=$NAME
./bin/spark-class org.apache.spark.deploy.worker.Worker \
	spark://${SPARK_MASTER_ENV_NAME}:${SPARK_MASTER_ENV_SPARK_MASTER_PORT} \
	--properties-file /spark-defaults.conf \
	-i $SPARK_LOCAL_IP \
	"$@"
