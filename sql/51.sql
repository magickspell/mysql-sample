-- 51 группировка данных GROUP BY
/*
 при группировке
 1) СУБД сканит всю таблицу
 2) СУБД агрегирует значения по ключу
 2.1) создаются некие корзинки, в которые по ключу складываются значения (записи)
 2.2) Когда корзинки собраны и встерено новое значение - создается новая корзина
 4) СУБД возвращает эти корзины (группы)
 * */

DESCRIBE user_private_message;


select distinct user_from_id from user_private_message; 

-- так сделать подзапросом
with unique_senders as (
	select distinct user_from_id from user_private_message
)
select 
	user_from_id,
	(
		select count(1) from user_private_message upm 
		where upm.user_from_id = unique_senders.user_from_id
	) as messages_count
from unique_senders
;


-- а вот так группировкой
SELECT
	user_from_id,
	count(1) as messages_count
FROM user_private_message upm
group by user_from_id
;

-- узнать кол-во юзеров у которого имя начинается с определенной буквы ('A', 'B', 'C')
select 
	substring(first_name, 1, 1),
	count(1)
from user
where 1=1
and substring(first_name, 1, 1) in ('A', 'B', 'C')
group by substring(first_name, 1, 1)
order by 1 -- это номер колонки для сортировки
;


-- группировка по двум полям (на самом деле ключи могут быть и больше)
select * from user_private_message where user_from_id = 8425 and user_to_id = 7838;
INSERT INTO user_private_message (user_from_id,user_to_id,send_time,is_read,read_time,message_text) VALUES
	 (8425,7838,'2021-10-29 21:29:34',0,NULL,'NEW MESSAGE lol')
;
select 
	user_from_id,
	user_to_id,
	min(send_time) as min_date,
	max(send_time) as max_date,
	count(1)
from user_private_message upm 
where 1=1
group by user_from_id, user_to_id
;

-- HAVING (тут идут условия как where, только еще можно агрегацию)
select group_id, count(1) as cnt
from users_to_discussion_groups utdg
group by group_id
having count(1) > 5
;
-- группиировка вложенного подзапроса (вместо HAVING тожесамое)
select * from 
	(
		select group_id, count(1) as cnt
		from users_to_discussion_groups utdg
		group by group_id
	) query
where query.cnt > 5
;