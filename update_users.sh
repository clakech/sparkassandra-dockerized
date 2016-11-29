#!/bin/sh

echo "CREATE ROLE ${CASSANDRA_SUPER_USER} WITH PASSWORD = '${CASSANDRA_SUPER_PASSWORD}'
    	AND SUPERUSER = true
    	AND LOGIN = true; exit;" | cqlsh -u cassandra -p cassandra

echo "CREATE ROLE ${CASSANDRA_USER} WITH PASSWORD = '${CASSANDRA_PASSWORD}'
        AND SUPERUSER = false
        AND LOGIN = true; exit;" | cqlsh -u cassandra -p cassandra

echo "ALTER ROLE cassandra WITH PASSWORD='${OLD_PASSWORD}'
    	AND SUPERUSER = false; exit;" | cqlsh -u ${CASSANDRA_SUPER_USER} -p ${CASSANDRA_SUPER_PASSWORD}
 
