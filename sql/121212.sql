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