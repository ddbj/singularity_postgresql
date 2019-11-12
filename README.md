# singularity_postgresql

遺伝研スパコンでユーザー権限でPostgreSQLデータベースを実行するためのsingularity imageの使い方

対応するPostgreSQLのバージョン
- 9.6.15
- 10.10
- 11.5
- 12.0

## imageの生成

自分の環境でimageをbuildする場合は、以下のコマンドを実行します。PostgreSQLのバージョンには9.6.15, 10.10, 11.5, 12.0のいずれかを指定してください。

    $ git clone https://github.com/ddbj/singularity_postgresql.git
    $ cd singularity_postgresql
    $ sudo singularity build ubuntu-18.04-postgresql-<PostgreSQLのバージョン>.simg Singularity.<PostgreSQLのバージョン>

## imageのダウンロード

Singularity Hubに登録されたイメージをダウンロードする場合は以下のコマンドを実行します。PostgreSQLのバージョンには9.6.15, 10.10, 11.5, 12.0のいずれかを指定してください。


    $ git clone https://github.com/ddbj/singularity_postgresql.git
    $ cd singularity_postgresql
    $ singularity pull --name ubuntu-18.04-postgresql-<PostgreSQLのバージョン>.simg shub://ddbj/singularity_postgresql:<PostgreSQLのバージョン>

## PostgreSQLデータベースクラスターの初期化

生成またはダウンロードしたイメージだけではPostgreSQLデータベースを実行できません。 start_container.shを実行してsingularity instanceを起動し、データベースクラスターの初期化を行います。
シェルスクリプトの実行前に、自分の環境に合わせて start_container.sh の CONTAINER_HOME, IMAGE, INSTANCE, PORT変数を修正してください。

- CONTAINER_HOMEにはgit cloneでできたディレクトリのフルパスを記載してください。
- IMAGEには、image生成またはダウンロードの際に指定したファイル名を記載してください。
- PORT変数は5000以上で任意の整数を指定してください。

シェルスクリプトを実行すると、初回実行時には以下のようにデータベースの初期化が行われた後でデータベースサーバが起動します。

    $ bash start_container.sh
    The files belonging to this database system will be owned by user "<スクリプトの実行ユーザー>".
    This user must also own the server process.
    
    The database cluster will be initialized with locale "C".
    The default text search configuration will be set to "english".
    
    Data page checksums are disabled.
    
    fixing permissions on existing directory /usr/local/pgsql12/data ... ok
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
    
        pg_ctl -D /usr/local/pgsql12/data -l logfile start
    
    Stopping pgsql instance of /gpfs1/lustre2/home/y-okuda/git/singularity_postgresql/ubuntu-18.04-postgresql-12.0.simg (PID=36513)
    waiting for server to start.... done
    server started

## PostgreSQLデータベースのスーパーユーザーのパスワード設定

singularity instanceを起動したユーザー（initdbを実行したユーザー）がPostgreSQLデータベースのスーパーユーザーに設定されています。スーパーユーザーのパスワードを設定します。

    $ singularity exec instance://pgsql psql -d postgres -p 55432
    psql (12.0)
    Type "help" for help.
    
    postgres=# alter role "<スクリプトの実行ユーザー>" with password '<パスワード>';
    ALTER ROLE
    postgres=# \q

## PostgreSQLデータベースの使用

パスワードの設定によりsingularity instanceの外からデータベースにアクセスできるようになります。アクセスの際は-hオプションでsingularity instanceを実行しているホスト名を指定してください。

    $ psql -d postgres -p 55432 -h at043
    パスワード: 
    psql (9.2.24, サーバー 12.0)
    注意： psql バージョン 9.2, サーバーバージョン 12.0.
             psql の機能の中で、動作しないものがあるかもしれません。
    "help" でヘルプを表示します.
    
    postgres=# 

別ノードからのアクセスも可能です。

    $ ssh at044
    Last login: Fri Nov  1 20:25:26 2019 from at043
    $ psql -d postgres -p 55432 -h at043
    パスワード: 
    psql (9.2.24, サーバー 12.0)
    注意： psql バージョン 9.2, サーバーバージョン 12.0.
             psql の機能の中で、動作しないものがあるかもしれません。
    "help" でヘルプを表示します.
    
    postgres=# 

ここで提供しているpg_hba.confの記述ではアクセス可能なIPアドレスに制限がかかっていません。必要に応じて修正してください。
