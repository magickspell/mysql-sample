-- функции

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