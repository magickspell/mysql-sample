-- 74 сложные условия join
select
	dg.group_id,
	registration_type,
	approve_required,
	count(u.login),
	min(joined_time)
from user u
join users_to_discussion_groups utdg on utdg.user_id = u.user_id 
join discussion_group dg on dg.group_id = utdg.group_id
group by dg.group_id, registration_type
;


-- выбрать кол-во пользователей в группе и кол-во пользователей без группы
select
	g.group_id,
	count(u.user_id) as users_count,
	(
		select
		count(*) as users_wo_count
		FROM user uwo
		left join users_to_discussion_groups ugwo on ugwo.user_id = uwo.user_id
		left join discussion_group gwo on gwo.group_id = ugwo.group_id
		where 1=1
		and ugwo.group_id is null
	) as users_count_wo_groups
FROM users_to_discussion_groups ug
join user u on ug.user_id = u.user_id
join discussion_group g on g.group_id = ug.group_id
group by g.group_id
having count(u.user_id) > 1
order by count(u.user_id) desc
;