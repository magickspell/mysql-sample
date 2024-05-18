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