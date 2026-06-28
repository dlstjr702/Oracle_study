-- hr_main.sql 스크립트파일 @ CMD실행 : 샘플테이블 생성확인.
SELECT *
FROM tabs;

--
--REGIONS(국가)
DESC regions;
SELECT *
FROM regions;

--COUNTRIES(나라)
DESC COUNTRIES;
SELECT *
FROM countries;

--DEPARTMENTS (부서)
DESC DEPARTMENTS;
SELECT *
FROM DEPARTMENTS;


--EMPLOYEES(가장중요한 직원정보테이블)
DESC EMPLOYEES;
SELECT *
FROM EMPLOYEES;


--LOCATIONS(주소)
DESC LOCATIONS;
SELECT *
FROM LOCATIONS;

--JOBS(직업)
DESC JOBS;
SELECT *
FROM JOBS;

--JOB_HISTORY
DESC JOB_HISTORY;
SELECT *
FROM JOB_HISTORY;


------------------------------------------------------------------------------------------------------
--1) HR계정이 소유하고 있는 테이블 정보를 조회
SELECT table_name
FROM user_tables;

--2) job의 종류를 확인하고 갯수 조회.
SELECT job_id
FROM jobs;

SELECT COUNT(job_id)
FROM jobs;

--총 사원수 파악(조회, 검색)
SELECT *
FROM EMPLOYEES;

SELECT COUNT(*) -- 오라클 집계함수 중 count
FROM EMPLOYEES;




SELECT *
FROM DEPARTMENTS;

SELECT DEPARTMENT_id
FROM DEPARTMENTS;

SELECT UNIQUE DEPARTMENT_id 
FROM EMPLOYEES;



-- 각사원의 월급, 연봉을 출력하세요
SELECT *
FROM EMPLOYEES;

SELECT salary
FROM EMPLOYEES;

-- 이부분 이해가 안됨 !!!
SELECT first_name || ' ' || last_name  fullname, concat(concat(first_name,' '),last_name) FULL_NAME, salary+NVL(commission_pct,0) PAY , 12*(salary+(salary*NVL(commission_pct,0))) as YEAR
FROM EMPLOYEES;


-- 이름 두문자 출력 (날짜와 문자열일때 앞뒤에 홑따옴표로 사용해야함
SELECT first_name || ' ' || last_name  fullname
FROM EMPLOYEES;

SELECT last_name || '님의 급여는 ' || salary || '입니다.' result
FROM EMPLOYEES;


--HR  직속상사가 있으면
SELECT employee_id, first_name, NVL2(manager_id,'Y','N') AS 직속상사
FROM employees;

--HR  부서가 있으면 
SELECT employee_id, first_name, NVL2(manager_id,'Y','N') AS 직속상사 , nvl2(department_id,'O','X') dept_ox
FROM employees;




