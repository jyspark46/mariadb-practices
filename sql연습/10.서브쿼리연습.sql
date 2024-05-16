--
-- subquery --> 대부분 " SELECT "
--

--
-- 1) select 절, insert into t1 values(... --> 요기에 가능) --> 흔치는 않음
--
# select 절
select (select 1+2 from dual) from dual;
# from 절
select a.* from (select 1+2 from dual) a;

--
-- 2) from 절의 서브 쿼리
# 서브쿼리를 임시 테이블로 잘 활용하기만 하면 됨 !!!
--
select now() as n, sysdate() as s, 3 + 1 as r from dual;
select n, s, r
from (select now() as n, sysdate() as s, 3 + 1 as r from dual) a;

--
-- 3) where 절의 서브 쿼리 --> 결과가 아주 중요
# x = (...) 이면 서브쿼리의 결과가 '하나' 여야 함 --> column 여러개, row 여러개 나오면 error
# 이 기준은 " 연산자 " !!! --> 연산자에 맞춰서 결과를 잘 맞춰야 함
--

-- 예제) 현재, Fai Bale이 근무하는 부서에서 근무하는 다른 직원의 사번과 이름을 출력하기

# 서브쿼리 사용 X 풀이 --> 이렇게 사용하면 중간에 변수가 생겼을 때(데이터 변화 등) 문제가 생김
# --> 쿼리는 무조건 한방에 해결하기 !!
-- 쿼리 1.
select b.dept_no
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and concat(a.first_name, ' ', a.last_name) = 'Fai Bale'; # 결과: 'd004'
-- 쿼리 2.
select a.emp_no, a.first_name
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.dept_no = 'd004'; # 쿼리 1. 의 결과 이용

# ***** 서브쿼리 사용 O 풀이 *****
select a.emp_no, a.first_name
from employees a, dept_emp b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.dept_no = (SELECT b.dept_no
				 from employees a, dept_emp b
                 where a.emp_no = b.emp_no
                 and b.to_date = '9999-01-01'
                 and CONCAT(a.first_name, ' ', a.last_name) = 'Fai Bale');
       
-- 3-1) 단일행 연산자: =, >, <, >=, <=, <>, !=
-- 실습문제 1
-- 현재, 전체 사원의 평균 연봉보다 적은 급여를 받는 사원의 이름과 급여를 출력하기
select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.salary < (select avg(salary) 
			    from salaries
                where to_date = '9999-01-01')
order by b.salary desc;

-- 실습문제 2
-- 현재, 직책별 평균 급여 중에 가장 작은 직책의 직책 이름과 그 평균 급여를 출력하기
-- 1) 직책별 평균 급여 구하기
select a.title, avg(b.salary)
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title;
-- 2) 직책별 가장 적은 평균 급여 구하기
select min(avg_sal)
from (select a.title, avg(b.salary) avg_sal
	  from titles a, salaries b
      where a.emp_no = b.emp_no
      group by a.title) a;
-- 3) 최종: where 절에 subquery(=)
select a.title, avg(b.salary) avg_sal
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title
having avg_sal = (select min(avg_sal)
				  from (select a.title, avg(b.salary) avg_sal
						from titles a, salaries b
						where a.emp_no = b.emp_no
						and a.to_date = '9999-01-01'
						and b.to_date = '9999-01-01'
						group by a.title) a);
-- 4) 다른 방법: top-k(limit)
select a.title, avg(b.salary) avg_sal
from titles a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title
order by avg_sal asc
limit 0, 1; # limit: 인덱스는 0부터 시작 !!

-- 3-2) 복수행 연산자: in, not in, (비교연산자)any, (비교연산자)all --> ex. =any, <all

-- any 사용법
-- 1. =any: in
-- 2. >any, >=any: 최솟값
-- 3. <any, <=any: 최댓값
-- 4. <>any, !=any: not in

-- all 사용법
-- 1. =all: 의미없음
-- 2. >all, >=all: 최댓값
-- 3. <all, <=all: 최솟값
-- 4. <>all, !=all

-- 실습문제 3
-- 현재, 급여가 50000 이상인 직원의 이름과 급여를 출력하기
-- sol 1) join 활용
select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and b.salary > 50000
order by b.salary asc;   

-- sol 2) subquery - where 절에 in 활용
select emp_no, salary
from salaries
where to_date = '9999-01-01'
and salary > 50000;

select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and (a.emp_no, b.salary) in (select emp_no, salary
							 from salaries
							 where to_date = '9999-01-01'
							 and salary > 50000)
order by b.salary asc; 

-- sol 3) subquery - where 절에 =any 활용
select emp_no, salary
from salaries
where to_date = '9999-01-01'
and salary > 50000;

select a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no
and b.to_date = '9999-01-01'
and (a.emp_no, b.salary) =any (select emp_no, salary
							   from salaries
							   where to_date = '9999-01-01'
							   and salary > 50000)
order by b.salary asc;

-- 실습문제 4
-- 현재, 각 부서별로 최고 급여를 받고 있는 직원의 부서, 이름, 월급을 출력하기

select a.dept_no, max(b.salary)
from dept_emp a, salaries b
where a.emp_no = b.emp_no
and a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.dept_no;

-- sol 1) subquery - where 절에 in 활용
select a.dept_name, c.first_name, d.salary
from departments a,
	 dept_emp b,
	 employees c,
	 salaries d
where a.dept_no = b.dept_no
and b.emp_no = c.emp_no
and c.emp_no = d.emp_no
and b.to_date = '9999-01-01'
and d.to_date = '9999-01-01'
and (b.dept_no, d.salary) in (select a.dept_no, max(b.salary)
							  from dept_emp a, salaries b
							  where a.emp_no = b.emp_no
							  and a.to_date = '9999-01-01'
							  and b.to_date = '9999-01-01'
							  group by a.dept_no);
   
-- sol 2) subquery - from 절에 + join 활용
select a.dept_name, c.first_name, d.salary
from departments a,
	 dept_emp b,
	 employees c,
	 salaries d,
	(select a.dept_no, max(b.salary) as max_salary
	 from dept_emp a, salaries b
	 where a.emp_no = b.emp_no
	 and a.to_date = '9999-01-01'
	 and b.to_date = '9999-01-01'
	 group by a.dept_no) e
where a.dept_no = b.dept_no
and b.emp_no = c.emp_no
and c.emp_no = d.emp_no
and b.dept_no = e.dept_no
and b.to_date = '9999-01-01'
and d.to_date = '9999-01-01'
and d.salary = e.max_salary;