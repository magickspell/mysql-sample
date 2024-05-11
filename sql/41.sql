-- 41 WITH запросы
 -- сначала вычисялетс подзапрос WITH а потом выполняются запросы ниже капк бы из ввременной таблицы - что может дать буст производительности

with google_active_users as (
	select * from user where 1=1
	and is_active = 1
	and registration_type = 'google'
)
select 
	*
from google_active_users gau
where 1=1
and gau.registration_time > '2020-01-01'
;


with
active_users as (
	select * from user where 1=1
	and is_active = 1	
),
google_active_users as (
	select * from active_users where 1=1
	and registration_type = 'google'
),
vk_active_users as (
	select * from active_users where 1=1
	and registration_type = 'vk'
),
fb_active_users as (
	select * from active_users where 1=1
	and registration_type = 'facebook'
)
select 
	*
from google_active_users gau
where 1=1
and gau.registration_time > '2020-01-01'
UNION 
select 
	*
from vk_active_users vau
UNION 
select 
	*
from fb_active_users fau
;


-- рекурсияa таблица (функция) фибоначи  
with RECURSIVE fibonacci_tab_func (n, fib_n, next_fib_n) as (
	select 
		1,0,1
	union all
	select
		n+1, next_fib_n, fib_n + next_fib_n
	from fibonacci_tab_func WHERE n < 10
)
select
	-- *
	next_fib_n 
from fibonacci_tab_func
;