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