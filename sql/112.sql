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