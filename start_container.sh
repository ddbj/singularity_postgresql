#!/bin/bash

CONTAINER_HOME="/home/user/singularity_postgresql"
IMAGE="ubuntu-18.04-postgresql-12.0.simg"
INSTANCE="pgsql"
PORT="50001"

if [ ! -e ${CONTAINER_HOME}/logs ]; then
    mkdir ${CONTAINER_HOME}/logs
fi

singularity instance.start \
-B ${CONTAINER_HOME}/pgsql_data:/usr/local/pgsql12/data \
-B ${CONTAINER_HOME}/logs:/usr/local/pgsql12/logs \
${CONTAINER_HOME}/${IMAGE} \
${INSTANCE}

if [ ! -e ${CONTAINER_HOME}/pgsql_data/db_data ]; then
    singularity exec instance://${INSTANCE} initdb -D /usr/local/pgsql12/data/db_data --no-locale
fi

singularity exec instance://${INSTANCE} pg_ctl -D /usr/local/pgsql12/data/db_data -l /usr/local/pgsql12/logs/logfile -o "-p ${PORT}" start
