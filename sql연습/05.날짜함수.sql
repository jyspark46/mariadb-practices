--
-- 날짜 함수
--

-- curdate(), current_date
select curdate(), current_date
from dual;

-- curtime(), current_time
select curtime(), current_time
from dual;

-- now() VS sysdate()
select now(), sysdate()
from dual;
select now(), sleep(2), now()
from dual;
select now(), sleep(2), sysdate()
from dual;
# now()는 쿼리(select)가 실행된 시간
# sysdate()는 해당 함수가 호출된 시간 --> 데이터가 방대한데 각 시간을 기록할 필요가 있을 때 사용할 수 있음
	# ex) insert into T1 values (select X, X, X, ... , X from T2, sysdate());
    
-- date_format : 기본 포맷이 마음에 안들 때 사용
-- default format: %Y-%m-%d %h:%i:%s
select date_format(now(), '%Y년 %m월 %m일 %h시 %i분 %s초')
from dual;
select date_format(now(), '%d %b \'%y %h:%i:%s')
from dual;

-- period_diff
-- 예제) 근무개월
#		formatting: YYMM, YYYYMM
select first_name, hire_date,
	   period_diff(date_format(curdate(), '%y%m'), date_format(hire_date, '%y%%m')) as Month
from employees;

-- date_add(= adddate), date_sub(= subdate)
-- 날짜를 date 타입의 컬럼이나 값에 type(year, month, day)의 표현식으로 더하거나 뺄 수 있다.
-- 예제) 각 사원의 근속 연수가 5년이 되는 날에 휴가를 보내준다면 각 사원의 5년 근속 휴가 날짜는?
select first_name, hire_date,
	   date_add(hire_date, interval 5 year)
from employees;