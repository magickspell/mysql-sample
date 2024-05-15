-- 71
-- left join / right join  - нужен для сохранения в выборке отсутствующих записей, без фильтрации, с заменой на NULL если нет значений

select
	u.login,
	upm.message_text
from user_private_message upm 
join user u on u.user_id = upm.user_from_id 
;

-- left join - взять все записи слева, присоеденить все соответствия из таблицы справа, если записей справа нет - проставится NULL
-- вот так мы выбираем польсователей у которых нет сообщений
select
*
from user u
left join user_private_message upm on u.user_id = upm.user_from_id 
where upm.message_id is null
;
-- а так не выберется ничего т.к. left join отработает только на имеющиеся записи в user_private_message
select
*
from user_private_message upm
left join user u on u.user_id = upm.user_from_id 
where upm.message_id is null
;
-- right join берет все значения таблицы СПРАВА (зеркально left join) / взять все записи справа, присоеденить все соответствия из таблицы слева, если записей справа нет - проставится NULL
select
*
from user_private_message upm
right join user u on u.user_id = upm.user_from_id 
where upm.message_id is null
;