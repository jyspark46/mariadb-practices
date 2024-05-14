-- cast
select date_format(cast('2013-01-09' as date), '%Y년 %m월 %d일') from dual;
select '12345' + 10, cast('12345' as int) + 10 from dual;
select cast(cast(1 - 2 as unsigned) as signed) from dual;
select cast(cast(1 - 2 as unsigned) as int) from dual;
select cast(cast(1 - 2 as unsigned) as integer) from dual;

-- type
-- 문자
	-- varchar(max 길이) --> 가변 길이
    -- char(max 길이) --> char은 모든 컬럼의 값의 길이가 동일한 경우 사용 (ex. 전화번호)
    -- text
    -- CLOB(Character Large Object)
-- 정수
	-- medium int, int(= signed = integer), unsigned, big int
-- 실수
	-- float, double
-- 시간
	-- date, datetime
-- LOB
	-- CLOB, BLOB(Binary Large Object)