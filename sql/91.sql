-- 91 DML - подкласс языка операций с данными, входят команды таких как INSERT, UPDATE, DELETE
/*
При обработки данных СУБД следит за целосностью данных и при обновлении данных происходят блокировка таблицы или записи.
СУБД перехходит в режим ожидания.
При это следующий запrрос не будет выполнен пока не обновятся данные.
Это называется ЦЕЛОСНОСТЬЮ ДАННЫХ.
 * */
describe user;
select * from user;

insert into subscribe (email)
values
	('slonik-1@ya.ru')
;

insert into user (login, password_hash, email, is_active, first_name, last_name)
values
	('testInsert', 'pass-hash', 'slonik-1@ya.ru', false, 'first', 'last')
;

select 
*
from
subscribe s 
join user u on u.email = s.email
where u.email like '%slonik%'
;

-- при insert можно опускать список колонок, если мы указываем порядок колонок по порядку
insert into subscribe values ('slonik-2@ya.ru', 1, now());
select * from subscribe s where email like '%slonik%';

-- еще можно добавлять через SET в mysql
insert into user set login='slonik-2', password_hash='45623', is_active = 1, first_name = 'first', last_name = 'last', email = 'slonik-2@ya.ru';

-- чаще всего используется и поддерживает INSERT VALUES