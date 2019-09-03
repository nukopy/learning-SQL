-- make players
drop table if exists players;
create table `players`(
    `id` int(11) not null auto_increment, 
    `name` varchar(50) not null, 
    `goals` int(11) not null, 
    `height` int(11) not null, 
    `country_id` int(11) not null, 
    primary key (`id`)
) engine=InnoDB default charset=utf8mb4;

load data local infile "/Users/okuwaki/Projects/Database/article/script/players_countryID.csv"
into table players
fields terminated by '\t'
optionally enclosed by '"'  -- 文字化け防止用？ 必ずfieldsの後
lines terminated by '\n'
ignore 1 lines
(@1, @2, @3, @4, @5)  -- csv側のカラム番号
set id=@1, name=@2, goals=@3, height=@4, country_id=@5;
