-- 102 ТРАНЗАКЦИИ
start transaction; -- старт транзакции
commit; -- коммит изменений и завершение транзакции
rollback; -- отменить изменения

-- по дефолту в СУБД стоит автокоммит, все изменения БД сразу коммитится, что бы его отключить надо выполнить это, изменения будут применены только посл коммита (commit) или после отмены (rollback):
set autocommit = 0; -- отминить автокоммит для сессии.