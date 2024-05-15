-- 64 JOIN
/*
 по сути джои без условий дает декартово произведение (кол-во записей в таблице помноженное друг на друга)
 * */
select
	*
from `user` u 
join subscribe s on s.email = u.email 	
;
-- условия в where и join равнозначны
select 
	*
from user u, subscribe s 
where 1=1
and u.email = s.email
;