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
生成またはダウンロードしたイメージだけではPostgreSQLデータベースを実行できません。 singularity instanceを起動し、データベースの初期化を行います。 以下のシェルスクリプトの実行前に、自分の環境に合わせて start_container.sh の CONTAINER_HOME, IMAGE, INSTANCE, PORT変数を修正してください。シェルスクリプトを実行すると、初回実行時にはデータベースの初期化が行われます。

    $ bash start_container.sh
    The files belonging to this database system will be owned by user "y-okuda".
    This user must also own the server process.
    
    The database cluster will be initialized with locale "C".
    The default text search configuration will be set to "english".
    
    Data page checksums are disabled.
    
    creating directory /usr/local/pgsql12/data/db_data ... ok
    creating subdirectories ... ok
    selecting dynamic shared memory implementation ... posix
    selecting default max_connections ... 100
    selecting default shared_buffers ... 128MB
    selecting default time zone ... Japan
    creating configuration files ... ok
    running bootstrap script ... ok
    performing post-bootstrap initialization ... ok
    syncing data to disk ... ok
    
    initdb: warning: enabling "trust" authentication for local connections
    You can change this by editing pg_hba.conf or using the option -A, or
    --auth-local and --auth-host, the next time you run initdb.
    
    Success. You can now start the database server using:
    
        pg_ctl -D /usr/local/pgsql12/data/db_data -l logfile start
    
    waiting for server to start.... done
    server started
