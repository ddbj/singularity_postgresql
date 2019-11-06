#!/bin/bash

<<<<<<< HEAD
CONTAINER_HOME="/home/y-okuda/git/singularity_postgresql"
=======
CONTAINER_HOME="/home/user/singularity_postgresql"
>>>>>>> 0809e3ff618f4d74c079f3c1c9a029e3446a8d35
IMAGE="ubuntu-18.04-postgresql-12.0.simg"
INSTANCE="pgsql"
PORT="55432"

# ログディレクトリの生成
if [ ! -e ${CONTAINER_HOME}/logs ]; then
    mkdir ${CONTAINER_HOME}/logs
fi

# データベースディレクトリの生成・initdbの実行
if [ ! -e ${CONTAINER_HOME}/data ]; then
    mkdir ${CONTAINER_HOME}/data
    singularity instance.start \
    -B ${CONTAINER_HOME}/data:/usr/local/pgsql12/data \
    -B ${CONTAINER_HOME}/logs:/usr/local/pgsql12/logs \
    ${CONTAINER_HOME}/${IMAGE} \
    ${INSTANCE}
    singularity exec instance://${INSTANCE} initdb -D /usr/local/pgsql12/data --encoding=UTF-8 --no-locale
    singularity instance.stop ${INSTANCE}
fi

# 設定ファイルのコピー
cp ${CONTAINER_HOME}/pg_hba.conf ${CONTAINER_HOME}/data/
cp ${CONTAINER_HOME}/pg_ident.conf ${CONTAINER_HOME}/data/
cp ${CONTAINER_HOME}/postgresql.conf ${CONTAINER_HOME}/data/

# instance起動
singularity instance.start \
-B ${CONTAINER_HOME}/data:/usr/local/pgsql12/data \
-B ${CONTAINER_HOME}/logs:/usr/local/pgsql12/logs \
${CONTAINER_HOME}/${IMAGE} \
${INSTANCE}

<<<<<<< HEAD
# postgresqlサーバ起動
singularity exec instance://${INSTANCE} pg_ctl -D /usr/local/pgsql12/data -l /usr/local/pgsql12/logs/logfile -o "-p ${PORT}" start
=======
if [ ! -e ${CONTAINER_HOME}/pgsql_data/db_data ]; then
    singularity exec instance://${INSTANCE} initdb -D /usr/local/pgsql12/data/db_data --encoding=UTF-8 --no-locale
fi

singularity exec instance://${INSTANCE} pg_ctl -D /usr/local/pgsql12/data/db_data -l /usr/local/pgsql12/logs/logfile -o "-p ${PORT}" start
>>>>>>> 0809e3ff618f4d74c079f3c1c9a029e3446a8d35
