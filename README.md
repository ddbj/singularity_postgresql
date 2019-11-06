# singularity_postgresql

遺伝研スパコンでユーザー権限でPostgreSQLデータベースを実行するためのsingularity imageの使い方

## imageの生成

自分の環境でimageをbuildする場合は、以下のコマンドを実行します。

    $ git clone https://github.com/ddbj/singularity_postgresql.git
    $ cd singularity_postgresql
    $ sudo singularity build ubuntu-18.04-postgresql-12.0.simg Singularity.12.0

## imageのダウンロード

Singularity Hubに登録されたイメージをダウンロードする場合は以下のコマンドを実行します。

    $ git clone https://github.com/ddbj/singularity_postgresql.git
    $ cd singularity_postgresql
    $ singularity pull --name ubuntu-18.04-postgresql-12.0.simg shub://ddbj/singularity_postgresql:12.0

## PostgreSQLデータベースの初期化
