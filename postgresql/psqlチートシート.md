# PostgreSQL チートシート

PostgreSQL でよく使うコマンドをまとめました．↑ の目次から調べられます．これよく使うぞってのあったら教えてくださると幸いです．

## コマンドの説明

各コマンドはシェル環境，DB 対話環境で以下の様に分けられている．

- `$` で始まるコマンド：シェル環境（筆者は bash）でのコマンド
- `#` で始まるコマンド：PostgreSQL 対話環境でのコマンド

なお，`$` で始まるコマンドの出力は `#>>>`，`#` の出力は `--` で表しているため注意．

## 筆者の開発環境

- macOS Mojave 10.14.6
- psql (PostgreSQL) 11.3

※ psql は PostgreSQL 付属の DB 対話環境のこと．

## バージョンの確認

- シェル環境

```bash
$ psql --version
#>>> psql (PostgreSQL) 11.3
```

- 対話環境

```sql
# select version();
```

## ヘルプの表示

- `psql` コマンドに関するヘルプ

```bash
$ psql --help
```

- 対話環境で使える内部コマンド（`\` で始まるコマンド）のヘルプ

```sql
# \?
```

- 対話環境で使える SQL コマンドに関するヘルプ  
  コマンドを付け加えることでそのコマンドのヘルプが見れる．

```sql
# \h
-- SQL コマンド一覧が表示される

# \h [sql-command]
-- コマンドに関するヘルプ

# \h alter
-- alter に関するヘルプ
```

## DB サーバの起動・停止

- シェル環境

```bash
$ pg_ctl -D /usr/local/var/postgres start
$ pg_ctl -D /usr/local/var/postgres stop
```

## DB 一覧を表示

- シェル環境

```bash
$ psql -l
```

- 対話環境

```sql
# \l
```

## 対話環境への入り方

`psql` コマンドに 3 つのオプション `-d`，`-U`，`-h` をつけて実行することで，任意の DB の対話環境に入ることができる．

- `-d`：DB を指定（未指定でログインユーザ名の DB に入る（macOS の場合，ホームディレクトリのユーザ名））
- `-U`：ユーザーを指定（未指定だとログインユーザ（macOS の場合，以下略））
- `-W`：パスワードを指定（要設定）．
- `-h`：ホスト名（未指定だと localhost)

### DB を指定して対話環境へ入る

`psql -l` で名前を確認してから `[db-name]` の部分に DB の名前を入れる．インストール時にデフォルトで `postgres` という名前の DB ができているため，始めはそれで入っても良い．

```bash
$ psql -d [db-name]
$ psql -d postgres  # デフォルト
```

### DB，ロールを指定して対話環境に入る

「ロール」は「ユーザ」という意味で解釈して良い．それぞれのロールに対して権限を与えることができ，特定の DB へのアクセスの制限などが行える．

#### ユーザ一覧を表示

どんなユーザが存在するか分からない場合，デフォルトの DB `postgres` の対話環境に入ってユーザ一覧を見る．

```bash
$ psql -d postgres
```

```sql
# \du
-- ユーザ一覧の表が表示される
```

デフォルトではログインユーザの名前で全ての権限を持つユーザが作られている．筆者の場合は以下のように表示された．`pyteyon` がデフォルトで作られたユーザ，`nukopy` が新しく作ってみた何の権限も持たないユーザである．

```sql
# \du

--                                    List of roles
--  Role name |                         Attributes                         | Member of
-- -----------+------------------------------------------------------------+-----------
--  nukopy    |                                                            | {}
--  pyteyon   | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
```

#### DB，ユーザを指定して対話環境に入る

`-d`，`-U`（U は大文字）オプションを使う．

```bash
$ psql -d [db-name] -U [user-name]
```

各ユーザに設定したパスワードが必要な場合は末尾に `-W` オプションを付けるとパスワード入力を求められ，入力すれば対話環境に入れる．

```bash
$ psql -d [db-name] -U [user-name] -W
```

筆者の環境での例を以下に示した．

```bash
$ psql -d postgres -U nukopy -W
Password:  # 表示されないけど入力
psql (11.3)
Type "help" for help.

postgres=>  # 入れた
```

## 対話環境から出る

```sql
# \q
-- シェル環境へ戻る
```

## ロール一覧を表示

- デフォルトで作られる DB `postgres` の対話環境に入ってからロール（ユーザ）一覧を見る．

```bash
$ psql -d postgres
```

```sql
# \du
-- ロール一覧の表が表示される
```

## DB の作成，消去

- シェル環境：`createdb`，`dropdb`

```bash
$ pg_ctl -D /usr/local/var/postgres start
$ createdb [db-name]
$ psql -l  # 作成できているかの確認
$ dropdb [db-name]
$ psql -l  # 消去できているか確認
```

- 対話環境：`create database`，`drop database`

```sql
# create database [db-name];
-- CREATE DATABASE
# \l  -- データベース一覧．作成できているかの確認．
# drop database [db-name];
-- DROP DATABASE
# \l  -- 消去できているかの確認．
```

## 接続中の DB の情報を確認

対話環境に入った後，今自分がどのロールでどの DB を操作しているかを確認する．

- 現在接続中の DB の情報を確認（簡易）

```sql
# \c
-- You are now connected to database "[db-name]" as user "[user-name]".
```

- 現在接続中の DB の情報を確認（詳細）

```sql
# \conninfo
-- You are now connected to database "[db-name]" as user "[user-name]" via socket in "[socket の場所]" at port "[post-number]".
```

## 他の DB への切り替え

```sql
# \c  -- 現在の DB を表示
# \c [db-name]  -- 切り替え
# \c  -- 切り替えが出来ているか確認
```

## ロールにテーブルやビューなどに対する権限を追加する

- [ロールにテーブルやビューなどに対する権限を追加する(GRANT)](https://www.dbonline.jp/postgresql/role/index3.html)

## テーブル操作に関するコマンド

ここからは特定の DB の対話環境に入っている前提で話を進める．

### テーブル一覧を表示

```sql
# \d
```

### テーブルのスキーマを表示

テーブルのスキーマ（各フィールドのデータ型，制約やテーブル作成時の SQL クエリ）を表示させることができる．

```sql
# \d [table-name]
```

例えば，筆者が Python の Web フレームワーク，Django のチュートリアルで作成したテーブルで実行したところ以下のようになった．

```sql
# \d polls_question  -- "polls-question" というテーブル名

-- Table "public.polls_question"
--     Column     |           Type           | Collation | Nullable |                  Default
-- ---------------+--------------------------+-----------+----------+--------------------------------------------
--  id            | integer                  |           | not null | nextval('polls_question_id_seq'::regclass)
--  question_text | character varying(200)   |           | not null |
--  pub_date      | timestamp with time zone |           | not null |

Indexes:
    "polls_question_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "polls_choice" CONSTRAINT "polls_choice_question_id_c5b4b260_fk_polls_question_id" FOREIGN KEY (question_id) REFERENCES polls_question(id) DEFERRABLE INITIALLY DEFERRED
```

## シェル環境から特定の DB に対して SQL を実行

```bash
$ psql [db-name] -c "[query]"
```

例：`company` という DB の `employee` というテーブルを出力する．

```bash
$ psql company -c "select * from employee;"
```

## その他

- コマンドの履歴の表示

```sql
# \s
-- 今まで実行したコマンドの履歴
```
