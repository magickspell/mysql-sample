-- 93 UPDATE
-- пока обновляется БД - она блокирует другие запросы, это нужно для сохранения целосности (АТОМАРНОСТЬ)
-- UPDATE работает только с одной, с несколькими надо cascasde
update subscribe 
set is_active = 0
where email = 'slonik-4@ya.ru'
;
select * from subscribe s where email like '%slonik%';

-- order by и limit поддерживаются в UPDATE - так можно обновить ТОП-10 последних записей
update subscribe 
set is_active = null
where email like '%slonik%'
order by email limit 2
;
select * from subscribe s where email like '%slonik%';

-- деграть подзапросы из обновляемой таблицы нелоьзя, нужно использовать WITH
-- You can't specify target table 'subscribe' for update in FROM clause
update subscribe 
set is_active = 0
where email in (select email from subscribe where email like '%slonik%')
;
with sub as (select email from subscribe where email like '%slonik%')
update subscribe 
set is_active = 0
where email in (select email from sub)
;