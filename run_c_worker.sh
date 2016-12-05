#!/usr/bin/env bash
sudo docker run -it --name cassandra --link spark-master:spark_master --link cassandra-seed:cassandra -d turbineanalytics/docker-spark-cassandra
