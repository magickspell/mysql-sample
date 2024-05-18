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