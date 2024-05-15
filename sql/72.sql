-- 72
-- inner join - по сути обычный join (по дефолту join работает в этом режиме), откидывает все NULL из присоеденяемых таблиц
-- outer join - берет все записи и СЛЕВА и СПРАВА при этом если нет соответсвий проставляемт NULL
select
	m.message_text, p.post_text
from user_private_message m
-- full join user_group_post p on p.user_id = m.user_from_id -- в mysql нет FULL слова, но ниже написано где взять эмитацию
;