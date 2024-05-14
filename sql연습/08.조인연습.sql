--
-- inner join
--

# equi join
-- 예제1) 현재, 근무하고 있는 직원의 이름과 직책을 모두 출력하기
select a.first_name, b.title
from employees a, titles b
where a.emp_no = b.emp_no	 		# join 조건 (equi join) --> n - 1개
and b.to_date = '9999-01-01';   	# row 선택 조건

# equi join
-- 예제2) 현재, 근무하고 있는 직원의 이름과 직책을 모두 출력하되, 여성 엔지니어(Engineer)만 출력하기
select a.first_name, b.title
from employees a, titles b
where a.emp_no = b.emp_no			# join 조건 (equi join) --> n - 1개
and b.to_date = '9999-01-01'		# row 선택 조건1
and a.gender = 'f'					# row 선택 조건2
and b.title = 'Engineer';			# row 선택 조건3

--
-- ANSI/ISO SQL1999 Join 표준 문법
--

-- 1) natural join
	-- 조인 대상이 되는 두 테이블에 이름이 같은 공통 컬럼이 있으면,
    -- 조인 조건을 명시하지 않아도(원래는 where절이든, join 뒤에 on/using절이든 명시해야 함) 암묵적으로 조인이 된다.
select a.first_name, b.title
from employees a natural join titles b
where b.to_date = '9999-01-01';
# natural join은 현실에서 쓰기 힘듦
	# 의도치 않게 묶일 수 있음
    # 현실에서는 이름이 달라서 직접 지정해주는 경우가 많음

-- 2) join ~ using
# natural join의 문제점을 보완
select count(*)
from salaries a natural join titles b
where a.to_date = '9999-01-01'
and b.to_date = '9999-01-01';
# --> 대안
select count(*)
from salaries a join titles b using(emp_no)
where a.to_date = '9999-01-01'
and b.to_date = '9999-01-01';

-- 3) join ~ on
-- 예제) 현재, 직책별 평균 연봉을 큰 순서대로 출력하기
select a.title, avg(b.salary)
from titles a join salaries b on a.emp_no = b.emp_no
where a.to_date = '9999-01-01'
and b.to_date = '9999-01-01'
group by a.title
order by avg(b.salary) desc;

-- 실습 문제 1
-- 현재, 직원별 근무 부서를 출력하기
-- 사번, 직원 이름(first_name), 부서명 순으로 출력
select a.emp_no, a.first_name, c.dept_name
from employees a, dept_emp b, departments c
where a.emp_no = b.emp_no			# join 조건1 (equi join) --> n - 1개 = 2
and b.dept_no = c.dept_no			# join 조건2 (equi join) --> n - 1개 = 2
and b.to_date = '9999-01-01';		# row 선택 조건

-- 실습 문제 2
-- 현재, 지급되고 있는 급여를 출력하기
-- 사번, 직원 이름(first_name), 급여 순으로 출력
select a.emp_no, a.first_name, b.salary
from employees a, salaries b
where a.emp_no = b.emp_no			# join 조건 (equi join) --> n - 1개 = 1
and b.to_date = '9999-01-01';		# row 선택 조건

-- 실습 문제 3
-- 현재, 직원별 평균 연봉과 직원 수를 구하되, 직원 수가 100명 이상인 직책만 출력하기
-- projection: 직책, 평균, 직원 수
select a.title, avg(b.salary), count(*)
from titles a join salaries b 
			  on a.emp_no = b.emp_no # join 조건 (join on) --> n - 1개 = 1
where a.to_date = '9999-01-01'	
and b.to_date = '9999-01-01'		 # row 선택 조건
group by a.title
having count(*) >= 100;

-- 실습 문제 4
-- 현재, 부서별로 직책이 Engineer인 직원들에 대해서만 평균 연봉 구하기
-- projection: 부서 이름, 평균 연봉
select a.dept_name, avg(d.salary)
from departments a, dept_emp b, titles c, salaries d
where a.dept_no = b.dept_no			# join 조건1 (equi join) --> n - 1개 = 3
and b.emp_no = c.emp_no				# join 조건2 (equi join) --> n - 1개 = 3
and c.emp_no = d.emp_no				# join 조건3 (equi join) --> n - 1개 = 3
and b.to_date = '9999-01-01'		# row 선택 조건1
and c.to_date = '9999-01-01'		# row 선택 조건2
and d.to_date = '9999-01-01'		# row 선택 조건3
and c.title = 'Engineer'			# row 선택 조건4
group by a.dept_name
order by avg(d.salary) desc;