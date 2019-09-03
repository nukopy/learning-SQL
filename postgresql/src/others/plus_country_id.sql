-- 特定の列だけ抜き出して既存のテーブルに挿入
/*
LOAD DATA LOCAL INFILE "インポートするCSVがある場所" 
INTO TABLE テーブル名
FIELDS TERMINATED BY '区切り文字'
LINES TERMINATED BY '行の改行文字' 
(@CSV側のカラム番号)
ignore 1 lines  --1行目が列ラベルになっている場合
SET Mysql側のカラム名=@1;
*/
load data local infile "/Users/okuwaki/Projects/Database/article/script/players_countryID.csv"
into table players
fields terminated by '\t'
optionally enclosed by '"'  -- 文字化け防止用？ 必ずfieldsの後
lines terminated by '\n'
ignore 1 lines
(@1, @2, @3, @4, @5)  -- csv側のカラム番号
set id=@1, name=@2, goals=@3, height=@4, country_id=@5;
