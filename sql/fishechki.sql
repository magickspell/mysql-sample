-- описание таблицы
DESCRIBE user_private_message;

-- показать команду создания таблицы
show create table user;

-- ignore скипает дубликаты
insert ignore into subscribe (email)
values
	('slonik-3@ya.ru'),
	('slonik-3@ya.ru'),
	('slonik-4@ya.ru')
;

-- выбрать текущую последнюю запись
select * from user where user_id = LAST_INSERT_ID(); 