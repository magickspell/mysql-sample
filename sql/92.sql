-- 92 вставка нескольких данных
-- если что то в запросе нарушает целосность данных - такой запрос падает (соблюдается АТОМАРНОСТЬ данных)
-- ignore скипает дубликаты
insert ignore into subscribe (email)
values
	('slonik-3@ya.ru'),
	('slonik-3@ya.ru'),
	('slonik-4@ya.ru')
;
-- on dublicate key update - обновляет конфликты
insert into subscribe (email)
values
	('slonik-3@ya.ru'),
	('slonik-3@ya.ru'),
	('slonik-4@ya.ru')
on duplicate key update is_active = 1
;
insert into subscribe (email, is_active)
values
	('slonik-3@ya.ru', null),
	('slonik-3@ya.ru', 1),
	('slonik-4@ya.ru', null) 
as new
on duplicate key update is_active = new.is_active
;
select * from subscribe s where email in ('slonik-3@ya.ru', 'slonik-4@ya.ru');
select * from subscribe s where email like '%slonik%';

-- replace заменяет данные
replace into subscribe (email, is_active)
(select 'slonik-3@ya.ru', null union select 'slonik-4@ya.ru', 1)
;

-- выбрать текущую последнюю запись
select * from user where user_id = LAST_INSERT_ID(); 
