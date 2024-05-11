-- 42 ПОДЗАПРОСЫ 

-- подзапрос в селекте select - ! должно возвращать только одно значение !
-- сначала выберется все из основого запроса, потом из подзапроса
select
	dg.group_id,
	dg.name,
	(
		select
			concat(first_name, ' ', last_name) as name
		from user where 1=1
		and user_id = dg.admin_user_id 
	) as admin_full_name,
	(
		select login from user where user.user_id = dg.admin_user_id 
	) as admin_login
from discussion_group dg
;

-- подзапрос в вере where
select
	message_id,
	user_to_id 
from user_private_message upm 
where 1=1
and (
	SELECT
		email
	from user 
	where user_id = upm.user_to_id 
) = 'rusty2@outlook.com'
;
-- выбрать юзеров у кторых есть хотя бы одна группа
-- !exists - сканить до первой найденной строчки!
SELECT 
	*
from user u
where 1=1
and exists(select * from discussion_group dg where dg.admin_user_id=u.user_id)
;
-- или не админят не одну !not exists - сканить всю таблицу!
SELECT 
	*
from user u
where 1=1
and not exists(select * from discussion_group dg where dg.admin_user_id=u.user_id)
;

-- выбрать все сообщения между временами
-- тут 2 обхода таблицы
select
*
from user_private_message upm 
where 1=1
and send_time BETWEEN (
	select min(creation_time) from user_group_post ugp where ugp.group_id = 570809
) AND (
	select max(creation_time) from user_group_post ugp where ugp.group_id = 570809
)
;
-- тут 1 обхода таблицы
with post_stat as (
	select 
		min(creation_time) as min_time,
		max(creation_time) as max_time
	from user_group_post ugp
	where ugp.group_id = 570809
)
select
*
from user_private_message upm 
where 1=1
-- and send_time BETWEEN post_stat.min_time AND post_stat.max_time -- не работает
and send_time BETWEEN (select post_stat.min_time from post_stat) AND (select post_stat.max_time from post_stat)
;

-- это пример того же самого что и WITH, такая штука может работать быстрее при тяжелых запросах
select
*
from (
	select
		*
	from user 
	where user.is_active = 1
) active_user 
where 1=1
and active_user.registration_type = 'vk';