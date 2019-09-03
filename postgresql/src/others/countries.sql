-- make players
drop table if exists countries;
create table `countries`(
    `id` int(11) not null auto_increment, 
    `name` varchar(50) not null, 
    `world-rank` int(11) not null, 
    `created_at` timestamp default current_timestamp not null, 
    primary key (`id`)
) engine=InnoDB default charset=utf8mb4;

load data local infile "/Users/okuwaki/Projects/Database/article/script/countries.csv"
into table countries
fields terminated by '\t'
optionally enclosed by '"'
lines terminated by '\n';
--ignore 1 lines;
