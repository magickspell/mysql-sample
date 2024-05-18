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