-- 3.3 преобразование, json, xml, blob

-- xml
select ExtractValue('<a href="http://example.com">Link<strong>Click</strong></a>', '/a');
select ExtractValue('<a href="http://example.com">Link<strong>Click</strong></a>', '/a/strong');

select '<body><script>alert(100)</script>Text</body>' as xml;
select UpdateXml('<body><script>alert(100)</script>Text</body>', '//script', '') as new_xml;

-- json
select json_object('key1', 'val1', "key2", "val2", 'key3', 3, 4, 4);

select * from `user` u;

select JSON_EXTRACT(metadata, '$.default_theme')  from `user` u;
select JSON_EXTRACT(metadata, '$.posts_per_page')  from `user` u;
select avg(JSON_EXTRACT(metadata, '$.posts_per_page'))  from `user` u;

select json_replace(metadata, '$.default_theme', 'dark', '$.posts_per_page', 25) from `user` u;

select cast(100.97 as signed);
select cast(100.11 as signed);
select cast("21" as year);
select cast("21 year" as year);
select cast("21 day" as year);
