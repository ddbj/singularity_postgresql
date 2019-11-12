#!/bin/bash

CONTAINER_HOME="/home/user/singularity_postgresql"
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
    singularity instance start \
    -B ${CONTAINER_HOME}/data:/usr/local/pgsql/data \
    -B ${CONTAINER_HOME}/logs:/usr/local/pgsql/logs \
    ${CONTAINER_HOME}/${IMAGE} \
    ${INSTANCE}
    singularity exec instance://${INSTANCE} initdb -D /usr/local/pgsql/data --encoding=UTF-8 --no-locale
    singularity instance stop ${INSTANCE}

    # 設定ファイルのコピー
    cp ${CONTAINER_HOME}/pg_hba.conf ${CONTAINER_HOME}/data/
    cp ${CONTAINER_HOME}/pg_ident.conf ${CONTAINER_HOME}/data/
    cp ${CONTAINER_HOME}/postgresql.conf ${CONTAINER_HOME}/data/
fi


# instance起動
singularity instance start \
-B ${CONTAINER_HOME}/data:/usr/local/pgsql/data \
-B ${CONTAINER_HOME}/logs:/usr/local/pgsql/logs \
${CONTAINER_HOME}/${IMAGE} \
${INSTANCE}

# postgresqlサーバ起動
singularity exec instance://${INSTANCE} pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/logs/logfile -o "-p ${PORT}" start
