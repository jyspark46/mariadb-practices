--
-- 문자열 함수
--

-- upper, ucase: 대문자화
select upper('seoul'), ucase('SeouL')
from dual;
select upper(first_name) from employees;

-- lower, lcase: 소문자화
select lower('SEOUL'), lcase('SeouL')
from dual;
select lower(first_name) from employees;

-- substring(문자열, index, length)
select substring('Hello World', 5, 4);
# 1부터 시작하는 글자 ~ 개수만큼 출력

-- 예제: 1989년에 입사한 직원들의 이름, 입사일 출력
select first_name, hire_date
from employees
where substring(hire_date, 1, 4) = '1989';

-- lpad(오른쪽 정렬), rpad(왼쪽 정렬)
select lpad('1234', 10, '-'), rpad('1234', 10, '-')
from dual;

-- 예제: 직원들의 월급을 오른쪽 정렬(빈 공간은 *)
select lpad(salary, 10, '*')
from salaries;

-- trim, ltrim, rtrim, trim(leading / trailing / both)
select concat("---", ltrim('   hello   '), "---"),
	   concat("---", rtrim('   hello   '), "---"),
       concat("---", trim(leading 'x' from 'xxxhelloxxx'), "---"),
       concat("---", trim(trailing 'x' from 'xxxhelloxxx'), "---"),
       concat("---", trim(both 'x' from 'xxxhelloxxx'), "---")
from dual;

-- length
select length("Hello World")
from dual;