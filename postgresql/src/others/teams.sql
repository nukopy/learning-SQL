drop table if exists teams;
create table `teams` (
    `id` int(11) not null, 
    `name` varchar(50) not null, 
    primary key(id)
) engine=InnoDB default charset=utf8mb4;

load data local infile "/Users/okuwaki/Projects/Database/article/script/teams.csv"
into table teams
fields terminated by '\t'
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(@1, @2)
set id=@1, name=@2;
