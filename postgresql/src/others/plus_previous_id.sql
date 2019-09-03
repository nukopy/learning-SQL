drop table if exists players;
create table `players` (
    `id` int(11) not null auto_increment, 
    `name` varchar(50) not null, 
    `goals` int(11) not null, 
    `height` int(11) not null, 
    `country_id` int(11) not null, 
    `previous_team_id` int(11) default null, 
    `created_at` timestamp default current_timestamp not null, 
    primary key(id), -- 主キー
    foreign key(country_id) references countries(id), -- 外部キー
    foreign key(previous_team_id) references teams(id) -- 外部キー
) engine=InnoDB default charset=utf8mb4;

load data local infile "/Users/okuwaki/Projects/Database/article/script/players_previous_id.csv"
into table players
fields terminated by '\t'
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(@1, @2, @3, @4, @5, @6)
set id=@1, name=@2, goals=@3, 
height=@4, country_id=@5, previous_team_id=@6;



/*
describe players;
このときNULLが保持されていない
結局前処理で空白を入れてそれをNULL値に置換して入れた
+------------------+-------------+------+-----+-------------------+----------------+
| Field            | Type        | Null | Key | Default           | Extra|
+------------------+-------------+------+-----+-------------------+----------------+
| id               | int(11)     | NO   | PRI | NULL              | auto_increment|
| name             | varchar(50) | NO   |     | NULL              ||
| goals            | int(11)     | NO   |     | NULL              ||
| height           | int(11)     | NO   |     | NULL              ||
| country_id       | int(11)     | NO   | MUL | NULL              ||
| previous_team_id | int(11)     | YES  | MUL | NULL              ||
| created_at       | timestamp   | YES  |     | CURRENT_TIMESTAMP ||
+------------------+-------------+------+-----+-------------------+----------------+
7 rows in set (0.00 sec)

select players.name as "選手名", teams.name as "前年所属していたチーム"
from players
join teams on players.previous_team_id = teams.id;
*/