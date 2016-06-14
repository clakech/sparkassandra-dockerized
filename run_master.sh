#!/usr/bin/env bash
sudo docker run -t -P -d --name spark-master turbineanalytics/sdocker-spark-cassandra /start-master.sh