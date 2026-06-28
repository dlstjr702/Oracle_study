--HR
SELECT *
FROM USER_TABLES
--WHERE TABLE_NAME = 'EMPLOYEES';
WHERE TABLE_NAME LIKE 'EMP%';
--
DESC employees;


------------------------------
SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY salary;


------------------------------
SELECT last_name, salary 
FROM employees
WHERE last_name = 'R___'
ORDER BY salary;

------------------------------
SELECT last_name, salary 
FROM employees
WHERE last_name LIKE '%A\_B%' ESCAPE '\' -- ☜ last_name문자중에 ...A_B...와 같은 경우
ORDER BY salary;

------------------------------
-- 4
SELECT first_name, last_name 
FROM employees
WHERE REGEXP_LIKE (first_name, '^Ste(v|ph)en$')--^(시작)$(끝)
ORDER BY first_name, last_name; -- 1차 정렬, 2차 정렬
 
------------------------------
-- 5
SELECT last_name 
FROM employees
WHERE REGEXP_LIKE (last_name, '([aeiou])\1','i')
ORDER BY last_name ;


------------------------------
--사원번호 154번 정보 조회
SELECT *
FROM EMPLOYEES
WHERE employee_id = 154;
-- 154	Nanette	Cambrault	NCAMBRAU	011.44.1344.987668	06/12/09	SA_REP	7500	0.2	145	80
-- LAST_NAME 컬럼값을 수정(DML-UPDATE):C_ambrault
--UPADATE 테이블명

UPDATE EMPLOYEES
SET LAST_NAME = 'C_ambrault'
WHERE employee_id=154;



-- [문제] 100,101,102 사원의 last_name 이름을 변경
--100   Steven   K%ing
--101   Neena   Koch%har
--102   Lex   De Ha%an
SELECT *
FROM employees
WHERE employee_id = 100 OR employee_id = 101 OR employee_id =102;

UPDATE employees
SET last_name = 'K%ing'
WHERE employee_id=100;

UPDATE employees
SET last_name = 'Koch%har'
WHERE employee_id=101;

UPDATE employees
SET last_name = 'De Ha%an'
WHERE employee_id=102;


UPDATE employees
SET last_name = SUBSTR( last_name, 1, LENGTH(last_name)-2) || '%' || SUBSTR( last_name,-2 )  
WHERE employee_id IN (  100, 101, 102 );

-- 1) LAST_NAME 문자열 속에 '%'를 포함하고 있는 사원 조회

SELECT LAST_NAME
FROM employees
WHERE LAST_NAME LIKE '%\%%' ESCAPE '\';

--(-)
SELECT LAST_NAME
FROM employees
WHERE LAST_NAME LIKE 'C\_%' ESCAPE '\';

ROLLBACK;

------------------------------
--사원이 속해 있는 부서의 종류를 조회하는 쿼리 작성..
-- 사원이 속해 있지 않는 부서의 갯수를 조회하는 쿼리작성
SELECT  *
FROM employees ;

--1) 정답
SELECT DISTINCT department_id
FROM employees 
WHERE department_id IS NOT NULL;

-- 2) 정답
-- 풀이 1 ) SET(집합)함수  : UNION/MINUS/INTERSEPT

SELECT COUNT(*)
FROM(  --인라인뷰
    SELECT department_id
    FROM departments
    MINUS
    SELECT DISTINCT department_id
    FROM employees
    WHERE department_id IS NOT NULL
)d;


--풀이2) LEFT OUTER JOIN 사용 >> 설명 안하심

--풀이3) GROUP BY + HAVING 절 사용  >> 설명 안하심 
--풀이4) NOT EXISTS 사용( 성능이 가장 좋기 때문에 실무에서 권장!!!)

SELECT department_id
FROM departments d
WHERE NOT EXISTS ( -- 상관쿼리
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);


--풀이5) NOT IN 연산자 사용

SELECT COUNT(department_id)
FROM departments
WHERE department_id NOT IN (
    -- 사원이 속해 있는 부서
    SELECT DISTINCT department_id
    FROM employees
    WHERE department_id IS NOT NULL
);

------------------------------





------------------------------
------------------------------
------------------------------





