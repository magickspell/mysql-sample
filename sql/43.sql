-- 43 представления VIEW
-- в бобре вьюхи можно смотреть в специальной вкладе вьюх таблицы
-- МАТЕРИАЛИЗОВАННЫЕ ВЬЮХИ хранятся на диске поэтому могут жрать память


-- создать представление
create or replace view groups_about_ls as (
	select * from discussion_group dg 
	where 1=1
	and JSON_CONTAINS(group_tags, '"ls"', '$') -- $ - искать в корне JSON-а
)
;

-- drop view
-- replace view


-- выбрать из представления
select * from groups_about_ls
where 1=1
;

-- создаем некий тип текущих существующих соц сетей
create or replace view existing_media as (
	select distinct(registration_type) as name from user
)
;
select * from existing_media;
