-- 53 DISTINCT vs GROUP BY

-- выборка из таблицы, выбираем только 2 поля, отсеиваем только уникальные значения / (выборка из строчек)
select
distinct is_active, registration_type
from user;
-- обходится вся таблица, формируются группы по ключу (комбинации), применяется выборка двух полей которые мы запрашивали / (выборка из групп)
select
is_active, registration_type 
from user
group by is_active, registration_type 
;

-- distinct and group by
-- дистинкт работает с результатами выборки т.е. вконце
select 
	distinct group_id, count(1) as cnt
from user_group_post ugp
group by group_id, user_id 
having cnt = 2
order by group_id asc
;