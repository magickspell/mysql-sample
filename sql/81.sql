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