select version(), current_date, now() from dual;

-- 수학함수, 사칙연산도 된다.
select sin(pi()/4), 1 + 2 * 3 - 4 / 5 from dual;

-- 대소문자 구분이 없다.
sELecT VERSION(), current_DATE, NOW() From DUAL;

-- table 생성: DDL
create table pet(
	name varchar(100),
    owner varchar(50),
    species varchar(20),
    gender char(1),
    birth date,
    death date
);

-- schema 확인
describe pet;
desc pet; # 위와 똑같음

-- table 삭제
drop table pet;
show tables;

-- insert: DML(CRUD 중 C - Create)
insert 
	into pet(name, owner, species, gender, birth) 
values('백구', '박주영', 'dog', 'm', '2007-12-25');
# insert into pet values('백구', '박주영', 'dog', 'm', '2007-12-25', null);

-- select: DML(CRUD 중 R - Read)
select * from pet;

-- update: DML(CRUD 중 U - Update)
update pet set name = '백꾸' where name = '백구';

-- delete: DML(CRUD 중 D - Delete)
delete from pet where name = '백꾸';

-- load data: mysql(CLI) 전용
load data local infile '/root/pet.txt' into table pet;

