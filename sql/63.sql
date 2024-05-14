-- 63 
-- DDL (data defenetion language)
-- DML (data manupalation language) - изменение данных
/*

 DDL
 -create
 -drop
 -alter
 
 * * */
create table  subscribe (
	email varchar(255),
	is_active int(1),
	last_sent_time timestamp DEFAULT CURRENT_TIMESTAMP
);
show create table subscribe;
describe subscribe;
describe user;
select * from subscribe;


alter table subscribe add primary key(email);
alter table subscribe drop primary key;

-- alter table user add constraint fk_email foreign key (email) references subscribe(email); -- ошибка из-за того что таблица пустая либо есть имеил несуществующие
insert into subscribe (email) select distinct email from user;
alter table user add constraint fk_email foreign key (email) references subscribe(email);
alter table user drop constraint fk_email;

drop table subscribe;