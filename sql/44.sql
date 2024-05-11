-- 44 ОБНОВЛЕНИЯ ВЬЮХ (по сути надо выплнять обновления таблиц из которых вьюха собирается ?или из самой вьюхи если она merged?)
-- temptable - нельзя обновлять данные (только исходную таблицу)
-- merge - можно обновлять данные из вьюхи непосредственно

create or replace ALGORITHM = merge view existing_media_merged as (
	select distinct(registration_type) as name from user
)
;
select * from existing_media_merged;