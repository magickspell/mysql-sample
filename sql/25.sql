-- РАВНО и НЕ РАВНО
select
*
from user
where 1=1
-- and first_name = 'Carla'
and first_name != 'Carla'
;

 -- ИЛИ
select
*
from user
where 1=1
and user_id = '7500'
or user_id = '7515' -- ИЛИ
;

-- РЕГУЛЯРКА
select
*
from user
where 1=1
-- and last_name like 'C%' -- некая регулярка, любые символы после С
and last_name like '_____' -- некая регулярка, всего 5 символа (5 шт "_")
;

-- БОЛЬШЕ, МЕЖДУ
select
*
from user
where 1=1
-- and registration_time > '2020-01-01' -- после даты
and registration_time between '2020-01-01' and '2021-01-01' -- между датами
;























