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