#!/usr/bin/env bash
sudo docker run -t -P -d --name spark-master turbineanalytics/docker-spark-cassandra /start-master.sh