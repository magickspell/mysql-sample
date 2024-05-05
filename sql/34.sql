-- 34 вертикальные соединения и уникальность
-- в mysql есть только UNION но есть еще INTERSECT (пересечения в обоих), MINUS (вычитания) и другие функции в других SQL движках

select user_from_id from user_private_message upm;
select distinct user_from_id from user_private_message upm;
select count(user_from_id) from user_private_message upm;
select count(distinct user_from_id) from user_private_message upm;
-- меняем через if id юзера на существующий и получаем на 1 уникального юзера меньше
select count(distinct if(user_from_id = 7500, 7490, user_from_id)) from user_private_message upm;
-- уникальные пары
select distinct user_from_id, user_to_id from user_private_message upm;
select count(distinct user_from_id, user_to_id) from user_private_message upm;

select user_to_id from user_private_message upm;
select user_from_id from user_private_message upm;

-- пересеение записей (без объеденения из обоих)
select user_to_id from user_private_message upm
union
select user_from_id from user_private_message upm;
-- объеденение записей
select user_to_id from user_private_message upm
union all
select user_from_id from user_private_message upm;