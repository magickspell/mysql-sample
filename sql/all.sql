-- 2
select
*
from user
where 1=1
-- and first_name = 'Carla'
and first_name != 'Carla'
;

select
*
from user
where 1=1
and user_id = '7500'
or user_id = '7515' -- ИЛИ
;

select
*
from user
where 1=1
-- and last_name like 'C%' -- некая регулярка, любые символы после С
and last_name like '_____' -- некая регулярка, всего 5 символа (5 шт "_")
;

select
*
from user
where 1=1
-- and registration_time > '2020-01-01' -- после даты
and registration_time between '2020-01-01' and '2021-01-01' -- между датами
;




------ 3
------ 31

select if(approve_required, 'required', '-') as approve 
from discussion_group dg 
;

-- if else
select
group_id,
if(creation_time < '2020-01-01', 'true', 'false') isOld,
if(approve_required, 'required', '-') as approve 
from discussion_group dg 
;

-- coalesce - выбрать первое существуещее значение
select
message_id,
COALESCE(read_time, send_time) as actual_time,
if(COALESCE(read_time, send_time) > '2020-11-01', true, false) as "isNew"
from user_private_message upm 
;

-- greatest - выбрать наибольшее значение
select
message_id,
COALESCE(read_time, send_time) as actual_time,
greatest(COALESCE(read_time, send_time), '2020-01-01') as lastGreatest
from user_private_message upm
;

-- concat - соеденить строки
SELECT
user_id,
CONCAT(first_name, '_', last_name) 
from `user` u 
;

-- curdate() - текущая дата
select CURDATE(); 
-- adddate() - добавить дату
-- interval - интервал времени
select 
adddate(CURDATE(), interval 7 day) as "nextWeek",
adddate(CURDATE(), interval -7 day) as "pastWeek"
;

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


-- 3.3 преобразование, json, xml, blob

-- xml
select ExtractValue('<a href="http://example.com">Link<strong>Click</strong></a>', '/a');
select ExtractValue('<a href="http://example.com">Link<strong>Click</strong></a>', '/a/strong');

select '<body><script>alert(100)</script>Text</body>' as xml;
select UpdateXml('<body><script>alert(100)</script>Text</body>', '//script', '') as new_xml;

-- json
select json_object('key1', 'val1', "key2", "val2", 'key3', 3, 4, 4);

select * from `user` u;

select JSON_EXTRACT(metadata, '$.default_theme')  from `user` u;
select JSON_EXTRACT(metadata, '$.posts_per_page')  from `user` u;
select avg(JSON_EXTRACT(metadata, '$.posts_per_page'))  from `user` u;

select json_replace(metadata, '$.default_theme', 'dark', '$.posts_per_page', 25) from `user` u;

select cast(100.97 as signed);
select cast(100.11 as signed);
select cast("21" as year);
select cast("21 year" as year);
select cast("21 day" as year);



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


-- 35 
/*
 order by - сортировка вверх вниз (asc, desc) по значению или функциям
 limit - ограниение выборки с одним чимлом (10, 100, 1000), или двумя и тогда: первое чилсо ОФСЕТ(сдвиг)  второе чиосло КОЛ-ВО
 * */

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

-- 43 представления VIEW
-- в бобре вьюхи можно смотреть в специальной вкладе вьюх таблицы
-- ВЬЮХИ хранятся на диске поэтому могут жрать память

-- создать представление
create or replace view groups_about_ls as (
	select * from discussion_group dg 
	where 1=1
	and JSON_CONTAINS(group_tags, '"ls"', '$') -- $ - искать в корне JSON-а
)
;

-- выбрать из представления
select * from groups_about_ls
where 1=1
;

-- создаем некий тип текущих существующих соц сетей
create or replace view existing_media as (
	select distinct(registration_type) as name from user
)
;
select * from existing_media;

-- drop view
-- replace view

-- 44 ОБНОВЛЕНИЯ ВЬЮХ (по сути надо выплнять обновления таблиц из которых вьюха собирается ?или из самой вьюхи если она merged?)
-- temptable - нельзя обновлять данные (только исходную таблицу)
-- merge - можно обновлять данные из вьюхи непосредственно

create or replace ALGORITHM = merge view existing_media_merged as (
	select distinct(registration_type) as name from user
)
;
select * from existing_media_merged;



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

-- 52
/*
 Порядок выполнения запроса
 
 1 сканирование таблицы (select)
 2 фильтрация строк (where)
 3 формирование групп (group by)
 4 фультрация групп (having)
 5 сортировка результата
 
 * */
SELECT 
	user_id,
	group_id,
	count(1)
FROM user_group_post
WHERE creation_time > date_sub(now(), INTERVAL 50 year)
GROUP BY user_id, group_id
HAVING count(1) > 2
ORDER BY 2,3 DESC
;

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


-- 54
-- первичные ключи - это ключи выбранные основными

describe user;
-- UNI - уникальный ключ
-- есть еще НАТУРАЛЬНЫЕ КЛЮЧИ - время, ИНН, номер машины и т.д.
-- часто используют uuid, нужны для однозначной идентификации сущности в системе


-- 61 отношения
/*

***
Например есть сущности:

Студент
-почта
-пароль
-имя

Урок
-название
-ссылка

Курс
-название
-автор
-описание

***
Типы связей
1) курс-урок - один ко многим
2) урок-курс - многие к одному
3) студенты-уроки - многие ко многим
4) студенты-курсы - многие ко многим, но тут лучше выделить отдельную таблицу связей, например:
Прогресс
-студент
-курс
-статус
СВЯЗИ БУДУТ ТАКИЕ
прогресс-студент = 1 ко многим
прогресс-курс = 1 ко многим
ПЕРВИЧНЫЙ ключ тут будет -> студент + курс
5) ЕЩЕ БЫВАЕТ СВЯЗЬ - ОДИН К ОДНОМУ
 */


-- 62 внешние ключи
/*
 внешний ключ - один или несколько атрибутов которые ссылаются на первичный ключ в другой таблице.
 * */
show create table user;

-- 63 
-- DDL (data defenetion language)
-- DML (data manupalation language) - изменение данных
/*

 DDL
 -create
 -drop
 -alter
 
 * * */
create table  subscribe (
	email varchar(255),
	is_active int(1),
	last_sent_time timestamp DEFAULT CURRENT_TIMESTAMP
);
show create table subscribe;
describe subscribe;
describe user;
select * from subscribe;


alter table subscribe add primary key(email);
alter table subscribe drop primary key;

-- alter table user add constraint fk_email foreign key (email) references subscribe(email); -- ошибка из-за того что таблица пустая либо есть имеил несуществующие
insert into subscribe (email) select distinct email from user;
alter table user add constraint fk_email foreign key (email) references subscribe(email);
alter table user drop constraint fk_email;

drop table subscribe;

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


-- 65
/*
 при джоинах СУБД пытается оптимизировать запросы и соеденения по первичному ключу самые легкие, поэтому соеденяются табличку сначала по первичным ключам
 
 сначала where
 потом join
 или нет - СУБД сама оптимизирует запросы
 * */


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

-- 72
-- inner join - по сути обычный join (по дефолту join работает в этом режиме), откидывает все NULL из присоеденяемых таблиц
-- outer join - берет все записи и СЛЕВА и СПРАВА при этом если нет соответсвий проставляемт NULL
select
	m.message_text, p.post_text
from user_private_message m
-- full join user_group_post p on p.user_id = m.user_from_id -- в mysql нет FULL слова, но ниже написано где взять эмитацию
;

-- 73 многие ко многим - связь через транзитивную табличку
describe users_to_discussion_groups; -- это транзитивная табличка
describe user;
describe discussion_group;
-- выбрать пользователей и группы
select 
	u.user_id,
	u.login,
	g.group_id,
	g.name
FROM users_to_discussion_groups ug
join user u on ug.user_id = u.user_id
join discussion_group g on g.group_id = ug.group_id
where 1=1
order by g.group_id asc, u.login asc
;
-- выбрать кол-во пользователей в группе и кол-во пользователей без группы
select
	g.group_id,
	count(u.user_id) as users_count,
	(
		select
		count(*) as users_wo_count
		FROM user uwo
		left join users_to_discussion_groups ugwo on ugwo.user_id = uwo.user_id
		left join discussion_group gwo on gwo.group_id = ugwo.group_id
		where 1=1
		and ugwo.group_id is null
	) as users_count_wo_groups
FROM users_to_discussion_groups ug
join user u on ug.user_id = u.user_id
join discussion_group g on g.group_id = ug.group_id
group by g.group_id
having count(u.user_id) > 1
order by count(u.user_id) desc
;

-- 74 сложные условия join
select
	dg.group_id,
	registration_type,
	approve_required,
	count(u.login),
	min(joined_time)
from user u
join users_to_discussion_groups utdg on utdg.user_id = u.user_id 
join discussion_group dg on dg.group_id = utdg.group_id
group by dg.group_id, registration_type
;


-- 81
-- оконная функция - это операция которая происходит над некоторым скользящим окном (набором строк) при этом агрегации резуьтатов не происходит
-- ?похоже на агригацию group by но не схлопывается?
-- функция срабатывает после WHERE и HAVING

-- row_number() - порядковый номер строки в окне
-- over(partition by name) - over определяем окно, partition часть по которой выбираются строки
-- показать проядковый номер регистрации для пользователя в разрее типа регистрации
select
	user_id,
	registration_type,
	registration_time,
	row_number() over(partition by registration_type) as rn
from user
;
-- сортировка по времени и выбор топ 3 (первых трех)
with q as (
	select
		user_id,
		registration_type,
		registration_time,
		row_number() over(partition by registration_type order by registration_time) as rn
	from user
) select * from q where rn < 3
;


-- 82 OVER и PARTITION
-- ОКНО - это всеголишь два указателя на начало и конец ОКНА (таблицы)
-- выбрать пользователя, кол-во сообщений и ранг по убыванию
with post_stat as (
	select
		user_id,
		count(1) as cnt
	from user_group_post ugp 
	group by user_id 
)
select
	*,
	"" as delimiter,
	dense_rank() over(order by cnt desc) as user_rank, -- сформуриется окно, вычислится dense_rank() функция (берется каждая строка по user_id)
	cnt,
	user_id
from post_stat
;
-- а чтобы отсортировать по годам надо использовать партцицию по году (partition by year)
with post_stat as (
	select
		user_id,
		count(1) as cnt,
		year(creation_time) as year
	from user_group_post ugp 
	group by user_id, year(creation_time)
)
select
	user_id,
	dense_rank() over(partition by year order by cnt desc) as user_rank, -- сформуриется окно, вычислится dense_rank() функция (берется каждая строка по user_id)
	cnt,
	year,
	100 * cnt / sum(cnt) over (partition by year) as percent, -- партишены могу быть использованы для собственных функций
	sum(cnt) over(partition by year ROWS UNBOUNDED PRECEDING) as subtotal -- ROWS UNBOUNDED PRECEDING подсчет кол-ва сообщений предшествующихз данной строке (тиап накопительный процент)
from post_stat
;
-- выделение окон
with post_stat as (
	select
		user_id,
		count(1) as cnt,
		year(creation_time) as year
	from user_group_post ugp 
	group by user_id, year(creation_time)
)
select
	user_id,
	dense_rank() over(window_year order by cnt desc) as user_rank, -- сформуриется окно, вычислится dense_rank() функция (берется каждая строка по user_id)
	cnt,
	year,
	100 * cnt / sum(cnt) over window_year as percent, -- партишены могу быть использованы для собственных функций
	sum(cnt) over(partition by year ROWS UNBOUNDED PRECEDING) as subtotal -- ROWS UNBOUNDED PRECEDING подсчет кол-ва сообщений предшествующихз данной строке (тиап накопительный процент)
from post_stat
window window_year as (partition by year) -- ОПРЕДЕЛЕНИЕ ОКНА
;


-- 83 ОПТИМИЗАЦИИ
/*
ПОДЗАПРОСЫ - медленные т.к. расчитываются отдельно для каждой строки (речь про (select something from something_table))
GROUP BY with JOIN - обычно можно заменить подзапросом и будет быстрее, но если соединяемые таблицы большие то подзапрос может быть быстрее
ОКОШКИ - обычно используют меньше памяти когда используются отдельно от всего, но их нельзя использовать агрегирую и нельзя одно окно внутри другого.
 * */

-- 84 НОРМАЛИЗАЦИЯ ( В реальной жизни используют только первые 2-3 формы. )
/*
НОРМАЛИЗАЦИЯ - соблюдение правил нормализации.
ДЕНОРМАЛИЗАЦИЯ - иногда необходимо денормализовать представления, например иногда легче хранить набор данных в таблице чем делать огромную выборку.
опять же зависит что нам дороже время выполнения или размер таблицы.

1 форма - для каждой таблицы на пересечение одной строки и одного столбца находится только одно значение (ключ всегда принимает только одно значение)
каждый столбец содержит атомарное неделимое значение (т.е. аналогичных столбцов нет в бд(схеме))
каждая строкак уникальная

2 форма - уже должна быть 1 нормальная форма. каждый атрибут зависит от его потенциального ключа (набора ключей)
выбриая по неокоторому набоору потенциальных ключей или ключу мы получим только одну соответствующую строчку.
это помогает легче джоинить или выбирать что то конкретное.

3 нормальная форма (3NF): Таблица должна быть во второй нормальной форме и не должна иметь транзитивных зависимостей.

4 нормальная форма (4NF): Таблица должна быть в третьей нормальной форме и не должна иметь многозначных зависимостей.
5 нормальная форма (5NF) или проекционная форма трехтожественного соединения (PJ/3NF): Таблица должна быть в четвертой нормальной форме и каждая неключевая колонка не должна быть зависимой от других неключевых колонок.
6 нормальная форма (6NF): Таблица должна быть в пятой нормальной форме и не должна иметь соединений.
 * */



-- 91 DML - подкласс языка операций с данными, входят команды таких как INSERT, UPDATE, DELETE
/*
При обработки данных СУБД следит за целосностью данных и при обновлении данных происходят блокировка таблицы или записи.
СУБД перехходит в режим ожидания.
При это следующий запrрос не будет выполнен пока не обновятся данные.
Это называется ЦЕЛОСНОСТЬЮ ДАННЫХ.
 * */
describe user;
select * from user;

insert into subscribe (email)
values
	('slonik-1@ya.ru')
;
-- можно вставлять селектами
insert into subscribe (email)
select ('slonik-100@ya.ru')
;

insert into user (login, password_hash, email, is_active, first_name, last_name)
values
	('testInsert', 'pass-hash', 'slonik-1@ya.ru', false, 'first', 'last')
;

select 
*
from
subscribe s 
join user u on u.email = s.email
where u.email like '%slonik%'
;

-- при insert можно опускать список колонок, если мы указываем порядок колонок по порядку
insert into subscribe values ('slonik-2@ya.ru', 1, now());
select * from subscribe s where email like '%slonik%';

-- еще можно добавлять через SET в mysql
insert into user set login='slonik-2', password_hash='45623', is_active = 1, first_name = 'first', last_name = 'last', email = 'slonik-2@ya.ru';

-- чаще всего используется и поддерживает INSERT VALUES

-- 92 вставка нескольких данных
-- если что то в запросе нарушает целосность данных - такой запрос падает (соблюдается АТОМАРНОСТЬ данных)
-- ignore скипает дубликаты
insert ignore into subscribe (email)
values
	('slonik-3@ya.ru'),
	('slonik-3@ya.ru'),
	('slonik-4@ya.ru')
;
-- on dublicate key update - обновляет конфликты
insert into subscribe (email)
values
	('slonik-3@ya.ru'),
	('slonik-3@ya.ru'),
	('slonik-4@ya.ru')
on duplicate key update is_active = 1
;
insert into subscribe (email, is_active)
values
	('slonik-3@ya.ru', null),
	('slonik-3@ya.ru', 1),
	('slonik-4@ya.ru', null) 
as new
on duplicate key update is_active = new.is_active
;
select * from subscribe s where email in ('slonik-3@ya.ru', 'slonik-4@ya.ru');
select * from subscribe s where email like '%slonik%';

-- replace заменяет данные
replace into subscribe (email, is_active)
(select 'slonik-3@ya.ru', null union select 'slonik-4@ya.ru', 1)
;

-- выбрать текущую последнюю запись
select * from user where user_id = LAST_INSERT_ID(); 


-- 93 UPDATE
-- пока обновляется БД - она блокирует другие запросы, это нужно для сохранения целосности (АТОМАРНОСТЬ)
-- UPDATE работает только с одной, с несколькими надо cascasde
update subscribe 
set is_active = 0
where email = 'slonik-4@ya.ru'
;
select * from subscribe s where email like '%slonik%';

-- order by и limit поддерживаются в UPDATE - так можно обновить ТОП-10 последних записей
update subscribe 
set is_active = null
where email like '%slonik%'
order by email limit 2
;
select * from subscribe s where email like '%slonik%';

-- деграть подзапросы из обновляемой таблицы нелоьзя, нужно использовать WITH
-- You can't specify target table 'subscribe' for update in FROM clause
update subscribe 
set is_active = 0
where email in (select email from subscribe where email like '%slonik%')
;
with sub as (select email from subscribe where email like '%slonik%')
update subscribe 
set is_active = 0
where email in (select email from sub)
;

-- 94 DELETE
-- при удалении записи СУБД перестраивает данные (реорганизуется занимаемое место), важно помнить про индексы и т.д.

delete from subscribe where email = 'slonik-4@ya.ru';

-- МАКИМАЛЬНО БЫСТРО УДАЛИТЬ (не тратить время на реструктуризацию данных и т.д.) - quick
delete quick from subscribe where email = 'slonik-4@ya.ru';
-- оптимизировать после таких запросов
optimize table subscribe;

-- ignore delete удаляет все данные которые может, а если не может пропускает
-- cascade удаляет данные в связанных таблицах

-- TRUNCATE очищает таблицу целиком (все записи) РАБОТАЕТ быстрее чем "delete from table;"
TRUNCATE(table_name);
-- with new_select as () truncate() insert from new_select - в тоерии есть способы чтобы обновить данные вот так


-- 101 ТРАНЗАКЦИИ
/*
ТРАНЗАКЦИЯ - ЛОГИЧЕСКАЯ АТОМАРНАЯ ЕДЕНИЦА работы с данными.
соеденение нескольких операций в одну логическую операцию.

ACID
A - Атомарность - транзакция либо выполняется целиком либо не выполняется вообще
C - Согласованность - бд остается в корректном состоянии
I - Изолированность - транзакции не мешают друг другу
D - Прочность - результаты транзакций фиксируются в бд
*/


-- 102 ТРАНЗАКЦИИ
start transaction; -- старт транзакции
commit; -- коммит изменений и завершение транзакции
rollback; -- отменить изменения

-- по дефолту в СУБД стоит автокоммит, все изменения БД сразу коммитится, что бы его отключить надо выполнить это, изменения будут применены только посл коммита (commit) или после отмены (rollback):
set autocommit = 0; -- отминить автокоммит для сессии.


-- 103 БЛОКИРОВКИ
/*
ЕСТЬ 4 уровня изолированности
- read commited (включен по умолчанию в большинстве СУБД) - можем читать только обновленные данные, защищает от обновления одной записи, грязного чтения. НО тут есть проблема с тем что ТРАНЗАКЦИИ не изолированы и могут не догонять состояния друг друга и СУБД.
- read uncommited - можем читать НЕобновленные данные, защищает только от обновления одной и той же записи в разных сессиях.
- repeateble read - повторное чтение, позволяет избежать проблему непофвторяющегося чтения слепка, не спасает от фантомного чтения.
- serializible - СУБД следит что бы состояние БД было независимо для каждой транзакции, требует больше всего ресурсов компа и памяти.
*/
-- установить уровень блокировки
set global transaction ISOLATION LEVEL READ UNCOMMITTED;
/*
нужно смотреть насколько тяжелые транзакции в системе.

для легких - read uncommited или read commited

для тяжелых - serializible
*/


-- 104 фишечки транзакций

-- можно заблокировать изменяюмые данные чтобы их не задело в других транзакций
select * from user where email='slonik-3@ya.ru' for update;
-- пропустить заблокированные данные
select * from user for update skip locked;

-- хак для serialazible отдельных таблиц
LOCK tables user WRITE, subscribe READ;
-- разблокировать таблицы
unlock tables;

-- сейв поинты позваляют откатываться на сейвыпоинты назад, удобно для того что бы сохранять часть транзакций
savepoint sp1;
rollback to sp1; -- откатить до сейва
release savepoint sp1; -- удалить сейвпоинт

-- что нельзя в транзакциях
-- изменения ролей СУБД происходят в information_schema и их нельзя менять в транзакции
-- в рамках одной транзакции мы не можем использвать еще одни транзакции



-- 11 DDL data defenition language
/*
в БОБРЕ можно посмотреть на специальной вкладке как объявлена таблица
*/


-- 111 CREATE создать таблицу
create table achievement (
	ach_id int UNSIGNED unique NOT NULL auto_increment,
	tiitle varchar(255) NOT NULL
); 
drop table achievement;
create table achievement (
	ach_id int UNSIGNED primary key AUTO_INCREMENT, -- главный ключ
	title varchar(255) NOT NULL,
	CONSTRAINT c_long_title CHECK (length(title) > 10) -- констраинт на проверку что тайтл длиннее 10 символов
);

-- удобно создавать временные таблицы для перегона данных туда сюда
create temporary table achievement_tmp (
	ach_id int UNSIGNED primary key AUTO_INCREMENT, -- главный ключ
	tiitle varchar(255) NOT NULL,
	CONSTRAINT c_long_title CHECK (length(title) > 10) -- констраинт на проверку что тайтл длиннее 10 символов
);


-- 112 ИЗМЕНЕНИЯ ТАБЛИЦ
ALTER TABLE achievement ADD; -- добавить элемент
ALTER TABLE achievement DROP; -- удалить
ALTER TABLE achievement CHANGE; -- поменять колонку полностью (шире чем 2 колонки ниже)
ALTER TABLE achievement RENAME; -- переименовать
ALTER TABLE achievement MODIFY; -- изменяет определение колонки

ALTER TABLE achievement ADD column description text;

ALTER TABLE achievement DROP column description;

ALTER TABLE achievement DROP CHECK c_long_title;
ALTER TABLE achievement ADD CHECK (length(title) > 10);

-- добавить колонку после определенной колонки after column_id
ALTER TABLE achievement ADD column description text after ach_id;
-- переименовать колонку и поменять тип
ALTER TABLE achievement CHANGE description desrc varchar(255);
-- поменять тип данных
ALTER TABLE achievement MODIFY desrc varchar(200);
-- переименовать
ALTER TABLE achievement RENAME COLUMN desrc TO description;

-- В МИГРАЦИЯХ ЛУШЕ ИСПОЛЬЗОВАТЬ ТОЛЬКО ADD и DROP
-- безопанее всего клонировать поле и потом его удалять, разбиваю  это на две миграции, в случаее чего можно откатит коммит


-- 113 ТРИГГЕРЫ и ПРОЦЕДУРЫ
-- процедуры - груббо говоря сложно составленный запрос (обычно несущий сложную бизнес логику или просто трудоемкий по ресурсам, например скачка данных)

-- процедура
SET @message_count;
select @message_count;
SET @message_count = 50;
select @message_count;

-- объявить процедуру (не возвращает значение)
DELIMITER $$

CREATE PROCEDURE calculate_message_count(IN user_id INT, OUT message_count INT)
BEGIN
    SELECT COUNT(1) INTO message_count FROM user_private_message
    WHERE user_from_id = user_id;
END$$

DELIMITER ;


-- удалить процедуру
drop procedure calculate_message_count;
-- вызвать процедуру
call calculate_message_count(8425, @message_count);

-- функция (возвращает значение)
DELIMITER $$
CREATE FUNCTION user_full_name(uid INT) RETURNS CHAR(250) DETERMINISTIC
BEGIN
    DECLARE full_name CHAR(250);
	SELECT CONCAT(first_name, ' ', last_name) into full_name from user where user_id=uid;
	RETURN full_name;
END$$
DELIMITER ;
-- вызвать
select user_full_name(8417);


-- ТРИГЕРЫ - хранимая процедура которая выолняется при появлении новых данных
-- тригеры связаны с INSERT UPDATE DELETE, могут быть ДО и ПОСЛЕ команды (те всего 6 вариантов)
-- // например, если мы не указали десрипшн то м берем его из тайтала:
CREATE TRIGGER upd_descr AFTER INSERT ON achievement
FOR EACH ROW SET @description = coalecse(@description, NEW.title)
;

-- в текущем мире намного проще держжать бизнес логику не в процедурах SQL а в коде приложения, т.к. в SQL нет гита и других фишек


-- 114
-- Не блокируем таблицу целиком И как можно проще
ALTER TABLE achievement ADD PRIMARY KEY (ach_id), ALGORITM = INPLACE, LOCK=NONE;
/*
    ALTER TABLE achievement - это команда, которая изменяет структуру таблицы.
    ADD PRIMARY KEY (ach_id) - это команда, которая добавляет первичный ключ к таблице. ach_id - это имя столбца, который будет использоваться в качестве первичного ключа.
    ALGORITM = INPLACE - это параметр, который указывает, что операция должна быть выполнена без создания новой таблицы. Это может быть полезно, если таблица содержит много данных и вы хотите минимизировать влияние на производительность.
    LOCK=NONE - это параметр, который указывает, что операция не должна блокировать таблицу. Это может быть полезно, если вы хотите выполнить операцию в режиме реального времени.
 */

-- СЕКЦИОНИРОВАНИЕ (PARTITIONING) (ШАРДИРОВАНИЕ) - разбика одной таблицы на нексолько дисков
create table ti (
	id INT,
	amount DECIMAL(7,2),
	tr_date DATE
)
-- PARTITION BY HASH(
-- 	MONTH(tr_date)
-- )
PARTITION BY HASH(
	PARTITION p0 VALUES LESS THAN (1991), 
	PARTITION p1 VALUES LESS THAN (1992), 
	PARTITION p2 VALUES LESS THAN (1993), 
	PARTITION p3 VALUES LESS THAN (1994), 
	PARTITION p4 VALUES LESS THAN (1995)
);
-- удалить определенную партицию
ALTER TABLE ti TRUNCATE PARTITION p1, p3;



-- 12 ИНДЕКСЫ

-- 121
/*
Страницы памяти
универсальная организация менеджмента памяти
уменьшают кол-во I/O операций (input output)
размер страницы один на всю БД 4-64 КБ

структарс страницы памяти такая:
-ХЕДЕР
-ДАННЫЕ
-СМЕЩЕНИЕ

бывают разные страницы
-записи
-индексы
-бинарные данные
-экстенты (расширения)
-метаданные (адреса свободных страниц, экстентов)
*/

-- 122
/*
индекс и структуры данных

1)
деревья
b-tree
b+tree

2)
хешиндексы

3)
GIST (индекс)

4)
bitmap
*/


-- 123
/*
explain
*/
-- обяснение команды "explain"
explain select * from user where email = 'slonik-1@ya.ru';
-- создать индекс
-- такой индекс будет увеличивать быстродействие выбора пользователей по типу регистрации
create index reg_type_idx on user (
	registration_type
) using hash;
select * from user;
-- удалить индекс
drop index reg_type_idx on user;

-- 124
/*
лучшие практики индексов

индексы добавляют операции при изменении данных тк индексы тожде меняются, т.е. время вставки удаления и тд вырастает.
индексы требуют дополнительное место на диске.
при выполнении запроса считываются дополнительные страницы индексов - это не всегда бывает быстрее чем без индексов.

хинты - это комментарии которые позволяют указывать что СУБД нужно использовать для запроса а что нет, тт можно убрать проверки на внешние ключи, индексы и т.д.

порядок оптимизации запроса:
1 проверить explain запроса
2 создать необходимые индексы
3 добавить хинты если используются ненужные ключи
*/



/*
16 ОСОБЕННОСТИ РАЗНЫХ СУБД

Есть много движком SQL:
- InnoDB (используется в mysql)
высокопроизводительный, поддержка транзакций с сейвпоинтами. медленный но универсальный.
- MyISAM (Aria+)
оптимизирован под интенсивное чтение данных, но не запись. нет транзакций и внешних ключей.
- MyRocks
оптимизирует место на диске, быстро работает под нагрузкой (разработан в FACEBOOK)


MYSQL
-СУБД для веба по умолчанию
-LAMP = linux + apache + mysql + php
-хорош для старта
-можно дописывать когда сервис станет высоконагружен
-yназвания таблиц и атрибутов в кавычках `table_name`
-ключевое слово auto_increment (упрощает стандартный синтаксис из стандарта)
-нет INTERSECT, MINUS
-работа с датами и временем - CURDATE(), CURTIME()

MARIADB
- форк mysql, свободен, не oracle, чуть опаздывает по функциолналу от mysql 



ORACLE
- топ 1 СУБД для корпоратов
- экосистема для разработок прилодений и сервисов
- хорошая масштабируемость, гибкая настройка оптимизаций, ориентация на большие данные
- платная, дорогая, закрытая (может себе это позволить)
- PL/SQL (ЯП как питон, жс, плюсы и т.д.):
---- высокоуровневый ЯП с оптимизацией SQL
---- мнодество типов, структуризация кода
---- поддержка ООП
---- можно пилить веб-приложения
- IDENTYTI для auto_increment
- WHERE ROWNUM < x | FETCH FIRST x ROWS ONLY вместо LIMIT x
- SELECT * FROM a, b WHERE a.id(+)=b._id
- БОЛЬШЕ АНАЛИТИЧЕСКИХ ФУНКЦИЙ
---- CUBE
---- оптимизирована работа с оконными функциями
---- аналитический функции например NTH_VALUE, PERCENTILE_CONT, REGR_
- автоматическое создание индексов аналоизируя запросы



POSTGRESQL
- масштабируемость, гибкая но сложная настройка
- удобно работать с JSON и XML
- Вложенные транзакции с точками сохранения
- Гибкая система блокировок
- Расширения PostGIS (модуль для работы с геоданными)
- Свободный код, популярный, много расширений
- AWS RedShift (платные, обрезанный postgresql)
- explain plan - аналитика выполнения запроса
- SERIAL вместо auto_increment
- LIMIT, OFFSET (лимит отдельно, офсет отдельно)
- альтернативный синтаксиси show tables, describe table, use - нет (/c /dt)
- PL/SQL (свой ЯП)
----- можно делать пользовательские данные
----- можно писать код на python (процедур и тригеров тоже?)


MSSQL
- хорошо интегрируется с продукмтами Microsoft
- основная ниша - ифраструктура банков
- отличная производительность и аналитические функции
- разработка приложений, отчетов и т.д.
- названия таблиц в скобках [table_name]
- limit заменен на fetchfirst x ROWS only, select top (1)
- update... output... - можно вернуть данные (в постре же тоже можо лол)
- try catch
 
**/



-- удалить потом
select * from user where user_id = '7583';
select * from user_group_post;
















































