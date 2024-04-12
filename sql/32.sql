-- 3.2 агрегирующие функции
select * from user_private_message upm;

select max(read_time) from user_private_message upm;
select min(read_time) from user_private_message upm;

select 
count(read_time) as read_messages_count 
from user_private_message upm
where 1=1
and read_time is not null
;

select 
	count(read_time) as read_messages_count ,
	count(send_time) as total_message_count,
	(count(read_time) / count(send_time)) as read_coef,
	max(read_time) as last_readed,
	max(send_time) as last_sended
from user_private_message upm;
	
with unread as (
	select 
		1 as joiner,
		count(read_time) as read_messages_count 
	from user_private_message upm
	where 1=1
	and read_time is not null
),
readed as (
	select
		1 as joiner,
		count(send_time) as total_message_count
	from user_private_message upm
	where 1=1
)
select
	u.read_messages_count,
	r.total_message_count,
	(u.read_messages_count / r.total_message_count) as read_coef
from unread u
join readed r on u.joiner = r.joiner 
;