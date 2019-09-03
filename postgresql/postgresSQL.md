# PostgreSQL の基本

PostgreSQL の簡単な説明，兼チートシート．

- [document](https://www.postgresql.jp/document/11/html/preface.html)

## PostgreSQL とは？

PostgreSQL はリレーショナルデータベース管理システム（RDBMS）である．「リレーション」はテーブルを表す数学用語であり，つまり PostgreSQL はテーブル（リレーション）の中に格納されたデータを管理するシステムである．RDB，各テーブル，各テーブルの各行，各列は以下のように解釈できる．

- RDB: 各テーブルの集合．
- 各テーブル: 行の集合に名前をつけたもの．
- テーブルの各行: 名前をつけた列の集合．
- 各列: 特定のデータ型を持ち，データを特徴付ける．

また，列は行において固定の順番を持つが，**SQL はテーブルに存在する行の順番を保証しない**ことに注意（View として明示的にソートさせることは可能）．

## PostgreSQL DB の初期化

```bash
$ initdb /usr/local/var/postgres
```

## PostgreSQL サーバの起動，停止

```bash
$ pg_ctl -D /usr/local/var/postgres start
$ pg_ctl -D /usr/local/var/postgres stop
```

start 時の出力

```bash
$ pg_ctl -D /usr/local/var/postgres start

waiting for server to start....2019-07-14 01:42:51.420 JST [76402] LOG:  listening on IPv6 address "::1", port 5432
2019-07-14 01:42:51.420 JST [76402] LOG:  listening on IPv4 address "127.0.0.1", port 5432
2019-07-14 01:42:51.420 JST [76402] LOG:  could not bind IPv4 address "192.168.33.10": Can\'t assign requested address
2019-07-14 01:42:51.420 JST [76402] HINT:  Is another postmaster already running on port 5432? If not, wait a few seconds and retry.
2019-07-14 01:42:51.421 JST [76402] LOG:  listening on Unix socket "/tmp/.s.PGSQL.5432"
2019-07-14 01:42:51.436 JST [76403] LOG:  database system was shut down at 2019-07-14 01:42:48 JST
2019-07-14 01:42:51.441 JST [76402] LOG:  database system is ready to accept connections
 done
server started
```

stop 時の出力

```bash
$ pg_ctl -D /usr/local/var/postgres end

waiting for server to shut down....2019-07-14 01:45:00.771 JST [76402] LOG:  received fast shutdown request
2019-07-14 01:45:00.773 JST [76402] LOG:  aborting any active transactions
2019-07-14 01:45:00.774 JST [76402] LOG:  background worker "logical replication launcher" (PID 76409) exited with exit code 1
2019-07-14 01:45:00.774 JST [76404] LOG:  shutting down
2019-07-14 01:45:00.785 JST [76402] LOG:  database system is shut down
 done
server stopped
```

## DB の作成，消去

`sample-db` の部分は自分で自由に変えられる．

```bash
$ pg_ctl -D /usr/local/var/postgres start
$ createdb sample-db
$ psql -l  # 存在する DB のリストを出力

List of databases
   Name    |  Owner  | Encoding |   Collate   |    Ctype    |  Access privileges
-----------+---------+----------+-------------+-------------+---------------------
 postgres  | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |
 sample-db | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |
 template0 | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 | =c/mathnuko         +
           |          |          |             |             | mathnuko=CTc/mathnuko
 template1 | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 | =c/mathnuko         +
           |          |          |             |             | mathnuko=CTc/mathnuko
(4 rows)

$ dropdb sample-db  # sample-db が消去される

Name    |  Owner  | Encoding |   Collate   |    Ctype    |  Access privileges
-----------+---------+----------+-------------+-------------+---------------------
 postgres  | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 |
 template0 | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 | =c/mathnuko     +
           |          |          |             |             | mathnuko=CTc/mathnuko
 template1 | mathnuko | UTF8     | ja_JP.UTF-8 | ja_JP.UTF-8 | =c/mathnuko     +
           |          |          |             |             | mathnuko=CTc/mathnuko
(3 rows)
```

## DB の対話環境へ接続

- `psql [DB-name]`：DB の対話環境へ接続（psql は PostgreSQL 対話環境接続のためのプログラム）

`sample-db-#` は PostgreSQL の対話環境の[プロンプト](http://e-words.jp/w/%E3%83%97%E3%83%AD%E3%83%B3%E3%83%97%E3%83%88.html)を表す．対話環境では必ず**コマンド末に `;` を付ける**必要がある．

```psql
$ psql sample-db

psql (11.3)
Type "help" for help.

sample-db-# \c;  # 現在のデータベースの情報を表示
>>> You are now connected to database "sample-db" as user "mathnuko".

sample-db-# \d;  # テーブル一覧を表示
>>> Did not find any relations.
```

PostgresSQL では，SQL コマンドを使うことができるが，それ以外に多くの**内部コマンド**（組み込みコマンド）を持つ．それらはバックスラッシュ `\` から始まるコマンドである．

## PostgreSQL: 対話環境で使う内部コマンド

PostgreSQL で使える内部コマンド（組み込みコマンド）を列挙する．これらはバックスラッシュから始まるコマンドである（一部関連する SQL コマンドを含む）．

### DB 関連

- `\l`: 存在する DB 一覧を表示（シェルで `psql -l` と実行するのと同じものを表示）．
- `\c`: 現在接続中の DB の情報（名前，ユーザ）を表示．
- `\conninfo`: 現在接続中の DB の詳細な情報を表示．
- `\c [db-name]`: DB の切り替え．

### テーブル関連

- `\d`, `\dt`: 現在の DB のテーブル一覧を表示．
- `\z`: テーブル一覧を表示．各テーブルのアクセス権も表示される（`\d` より詳細）．
- `\d [table-name]`: テーブルの各フィールドの定義（フィールド名，型，default 値など）を表示．

### View 関連

- `create view [view-name] as [command]`: View の作成（これは SQL コマンド）．
- `\dv;`: View 一覧の確認

### utility

- **`\i [filename.sql]`: SQL を記述した外部ファイルを実行．**
- `\copy [table-name] from [filename.csv] delimiter as ','`: CSV 形式のファイルをテーブルに挿入．
- `\! [shell-command]`: PostgreSQL 対話環境内でシェルコマンドを実行できる．例えば，`\! pwd;` など．

### その他

- `\du`: ユーザ一覧を表示．
- `\h`: 対話環境で使える SQL コマンド一覧を表示．
- `\h [command-name]`: SQL コマンドのヘルプを表示．
- `\?`: 内部コマンド（`\` で始まるコマンド）のヘルプを表示．
- `\s`: コマンドラインの履歴の表示．
- `\q`: 対話環境を抜ける．

## PostgreSQL: 対話環境で使う SQL コマンド

PostgreSQL で使える SQL コマンドを列挙する（一部関連する内部コマンドを含む）．対話環境で実行するときにコマンド末に `;` を付けないと複数のコマンドが勝手に連なってしまうので必ず付けること．

### テーブル関連

#### テーブル一覧

- `\d`: 現在の DB のテーブル一覧を出力．

#### テーブル作成，消去

- `create table [table-name] (列名 型名, ...);`: テーブルの作成（同じテーブル名が存在する場合はエラーになる）．
- `drop table [table-name];`: テーブルの消去．

#### 特定のテーブル内のデータを表示: select, from

- `select * from [table-name];`: 特定のテーブル内のデータを全て表示．
- `select [column-name] from [table-name];`: テーブル内の特定の列を表示．
- `select [column1, column2, ...] from [table-name];`: テーブル内の特定の複数列を指定して表示．
- `select * from [table-name] where [condition];`: テーブル内の特定の条件（`where` 以下の条件）を満たす行を表示．

#### 組み込み関数，予約語を使ったさまざまなデータ表示

- `sum`, `max`, `min`, `avg`
- `distinct`
- `order by [desc]`
- `limit`
- `length`
- `concat`
- `offset`

##### 数値の集計: sum, max, min, avg

- `select sum([column-name]) from [table-name];`: 列の合計値．
- `select max([column-name]) from [table-name];`: 列の最大値．
- `select min([column-name]) from [table-name];`: 列の最小値．
- `select avg([column-name]) from [table-name];`: 列の平均値．

##### 特定の列の unique な値: distinct

- `select distinct [column-name] from [table-name];`

##### ソート: order by [desc]

- `select * from [table-name] order by [column-name];`: 指定した列名で昇順ソートして表示．
- `select * from [table-name] order by [column-name] desc;`: 指定した列名で降順ソートして表示．

##### 表示行数の制限: limit

- `select * from [table-name] limit [num];`: `limit [num]` で表示行数の制限．

##### 文字列の長さ: length

- `select length([column-name]) from [table-name];`: 文字列型の長さを表示．

##### 列の連結: concat

- `select concat(column1, column2, ...) from [table-name]`: 列を連結して表示（例えば，First Name と Last Name を連結させる，など）．

##### 何行目以降を表示: offset

- `select * from [table-name] offset [index];`: 何行目以降を表示するかを指定（**index は 0-origin**）．`0` なら全ての行．`1` なら 2 行目以降の行を表示．

#### テーブルに行を挿入する: insert into

- 行の挿入：基本，数値以外の定数は単一引用符 `'` で括る必要がある．

```sql
insert into [table-name] (column1, column2, ...) values (value1, value2, ...);
```

例 1

```sql
insert into players (name, height, number, birthday)
    values ('Steve Nash', 191, 13, '1974-02-07');
-- date 型は実はかなり柔軟でいろんな書式に対応できる．
```

例 2

players.sql

```sql
create table players (
    name varchar(255),
    height int,
    number int,
    birthday date
);

insert into players (name, height, number, birthday)
    values ('Steve Nash', 191, 13, '1974-02-07');
insert into players (name, height, number, birthday)
    values ('Stephen Curry', 191, 30, '1988-03-14');
insert into players (name, height, number, birthday)
    values ('Seth Curry', 188, 30, '1990-03-14');

```

PostgreSQL 対話環境

```hoge
mydb=# \i players.sql

CREATE TABLE
INSERT INTO 0 1
INSERT INTO 0 1
INSERT INTO 0 1

mydb=# select * from players;

     name      | height | number |  birthday
---------------+--------+--------+------------
 Steve Nash    |    191 |     13 | 1974-02-07
 Stephen Curry |    191 |     30 | 1988-03-14
 Seth Curry    |    188 |     30 | 1990-03-14
(3 rows)
```

#### テーブルの行の更新: update, set

- `update [table-name] set [column-name]=[value] where [condition];`: テーブルのデータの更新．where 以下の条件に合致した列を更新する．

PostgreSQL 対話環境

```hoge
mydb=# select * from players;

     name      | height | number |  birthday
---------------+--------+--------+------------
 Steve Nash    |    191 |     13 | 1974-02-07
 Stephen Curry |    191 |     30 | 1988-03-14
 Seth Curry    |    188 |     30 | 1990-03-14
(3 rows)

mydb=# update players set height=200 where name='Steve Nash';

UPDATE 1

mydb=# select * from players;

     name      | height | number |  birthday
---------------+--------+--------+------------
 Stephen Curry |    191 |     30 | 1988-03-14
 Seth Curry    |    188 |     30 | 1990-03-14
 Steve Nash    |    200 |     13 | 1974-02-07  # height updated
(3 rows)
```

#### 行の削除: delete from

- `delete from [table-name] where [condition];`: where 以下の条件に合致した列を消去する．

#### テーブルの構造を更新

- テーブルのオーナーの変更: `alter table [table-name] owner to オーナー名;`．

### 設定関連

ほげ．

### その他の設定関連

ほげ．

### ユーザの作成

- [Django user](https://qiita.com/shigechioyo/items/9b5a03ceead6e5ec87ec)

```sql
create user [user-name] with password [password];
-- CREATE ROLE（成功時の出力）

\du  -- ユーザが作れているか確認
```

Django への推奨設定への対応，タイムゾーンの設定

```sql
alter role [user-name] set client_encoding to 'utf8';
alter role [user-name] set default_transaction_isolation to 'read committed';
alter role [user-name] set timezone to 'Asia/Tokyo';
-- ALTER ROLE（成功時の出力）
```

作成したユーザに対して

## テーブルで使えるデータ型

PostgreSQL は，以下の標準 SQL のデータ型をサポートする．

- `int`: 整数型
- `smallint`:
- `bigint`:
- `real`: 単精度浮動小数点数型
- `double precision`:
- `char(N)`:
- `varchar(N)`: N 文字までの任意の文字列を格納できる．
- `date`: 日付．
- `time`: 時間．
- `timestamp`:
- `interval`:

また，一般的なユーティリティ用の型，高度な幾何データ型（`point`）もサポートする．任意の数のユーザ定義のデータ型を使用し，PostgreSQL をカスタマイズすることもできる．したがって，標準 SQL における特殊な場合をサポートするために必要な場所を除き，**型名は構文内でキーワードではない**ことに注意．

- `point`: PostgreSQL 独自のデータ型．位置情報などの幾何データを表す．

## 補足：PostgreSQL 対話環境で使える SQL コマンド一覧

長いので記事の最後に置いておく．PostgreSQL 対話環境で `\h;` を実行すると出力される．`\h [command];` で各コマンドのヘルプが見れる．

<div onclick="obj=document.getElementById('oritatami_part').style; obj.display=(obj.display=='none')?'block':'none';">
<a style="cursor:pointer;">▶︎SQL コマンド一覧を展開</a>
</div>
<div id="oritatami_part" style="display:none;clear:both;">
```psql
db=# \h;
Available help:
  ABORT
  ALTER AGGREGATE
  ALTER COLLATION
  ALTER CONVERSION
  ALTER DATABASE
  ALTER DEFAULT PRIVILEGES
  ALTER DOMAIN
  ALTER EVENT TRIGGER
  ALTER EXTENSION
  ALTER FOREIGN DATA WRAPPER
  ALTER FOREIGN TABLE
  ALTER FUNCTION
  ALTER GROUP
  ALTER INDEX
  ALTER LANGUAGE
  ALTER LARGE OBJECT
  ALTER MATERIALIZED VIEW
  ALTER OPERATOR
  ALTER OPERATOR CLASS
  ALTER OPERATOR FAMILY
  ALTER POLICY
  ALTER PROCEDURE
  ALTER PUBLICATION
  ALTER ROLE
  ALTER ROUTINE
  ALTER RULE
  ALTER SCHEMA
  ALTER SEQUENCE
  ALTER SERVER
  ALTER STATISTICS
  ALTER SUBSCRIPTION
  ALTER SYSTEM
  ALTER TABLE
  ALTER TABLESPACE
  ALTER TEXT SEARCH CONFIGURATION
  ALTER TEXT SEARCH DICTIONARY
  ALTER TEXT SEARCH PARSER
  ALTER TEXT SEARCH TEMPLATE
  ALTER TRIGGER
  ALTER TYPE
  ALTER USER
  ALTER USER MAPPING
  ALTER VIEW
  ANALYZE
  BEGIN
  CALL
  CHECKPOINT
  CLOSE
  CLUSTER
  COMMENT
  COMMIT
  COMMIT PREPARED
  COPY
  CREATE ACCESS METHOD
  CREATE AGGREGATE
  CREATE CAST
  CREATE COLLATION
  CREATE CONVERSION
  CREATE DATABASE
  CREATE DOMAIN
  CREATE EVENT TRIGGER
  CREATE EXTENSION
  CREATE FOREIGN DATA WRAPPER
  CREATE FOREIGN TABLE
  CREATE FUNCTION
  CREATE GROUP
  CREATE INDEX
  CREATE LANGUAGE
  CREATE MATERIALIZED VIEW
  CREATE OPERATOR
  CREATE OPERATOR CLASS
  CREATE OPERATOR FAMILY
  CREATE POLICY
  CREATE PROCEDURE
  CREATE PUBLICATION
  CREATE ROLE
  CREATE RULE
  CREATE SCHEMA
  CREATE SEQUENCE
  CREATE SERVER
  CREATE STATISTICS
  CREATE SUBSCRIPTION
  CREATE TABLE
  CREATE TABLE AS
  CREATE TABLESPACE
  CREATE TEXT SEARCH CONFIGURATION
  CREATE TEXT SEARCH DICTIONARY
  CREATE TEXT SEARCH PARSER
  CREATE TEXT SEARCH TEMPLATE
  CREATE TRANSFORM
  CREATE TRIGGER
  CREATE TYPE
  CREATE USER
  CREATE USER MAPPING
  CREATE VIEW
  DEALLOCATE
  DECLARE
  DELETE
  DISCARD
  DO
  DROP ACCESS METHOD
  DROP AGGREGATE
  DROP CAST
  DROP COLLATION
  DROP CONVERSION
  DROP DATABASE
  DROP DOMAIN
  DROP EVENT TRIGGER
  DROP EXTENSION
  DROP FOREIGN DATA WRAPPER
  DROP FOREIGN TABLE
  DROP FUNCTION
  DROP GROUP
  DROP INDEX
  DROP LANGUAGE
  DROP MATERIALIZED VIEW
  DROP OPERATOR
  DROP OPERATOR CLASS
  DROP OPERATOR FAMILY
  DROP OWNED
  DROP POLICY
  DROP PROCEDURE
  DROP PUBLICATION
  DROP ROLE
  DROP ROUTINE
  DROP RULE
  DROP SCHEMA
  DROP SEQUENCE
  DROP SERVER
  DROP STATISTICS
  DROP SUBSCRIPTION
  DROP TABLE
  DROP TABLESPACE
  DROP TEXT SEARCH CONFIGURATION
  DROP TEXT SEARCH DICTIONARY
  DROP TEXT SEARCH PARSER
  DROP TEXT SEARCH TEMPLATE
  DROP TRANSFORM
  DROP TRIGGER
  DROP TYPE
  DROP USER
  DROP USER MAPPING
  DROP VIEW
  END
  EXECUTE
  EXPLAIN
  FETCH
  GRANT
  IMPORT FOREIGN SCHEMA
  INSERT
  LISTEN
  LOAD
  LOCK
  MOVE
  NOTIFY
  PREPARE
  PREPARE TRANSACTION
  REASSIGN OWNED
  REFRESH MATERIALIZED VIEW
  REINDEX
  RELEASE SAVEPOINT
  RESET
  REVOKE
  ROLLBACK
  ROLLBACK PREPARED
  ROLLBACK TO SAVEPOINT
  SAVEPOINT
  SECURITY LABEL
  SELECT
  SELECT INTO
  SET
  SET CONSTRAINTS
  SET ROLE
  SET SESSION AUTHORIZATION
  SET TRANSACTION
  SHOW
  START TRANSACTION
  TABLE
  TRUNCATE
  UNLISTEN
  UPDATE
  VACUUM
  VALUES
  WITH
```
</div>

## 参考

- [cf](https://www.robinwieruch.de/postgres-sql-macos-setup/)
- [参考](https://qiita.com/Shitimi_613/items/bcd6a7f4134e6a8f0621)
