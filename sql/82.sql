-- 82 OVER и PARTITION

-- ОКНО - это по сути всеголишь два указателя на начало и конец ОКНА (таблицы)
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