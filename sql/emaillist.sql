desc emaillist;

-- (C)reate
insert into emaillist values(null, '둘', '리', 'dooly@gmail.com');

-- (R)ead
select no, first_name, last_name, email from emaillist order by no desc;

-- (D)elete
delete from emaillist where email = 'dooly@gmail.com';