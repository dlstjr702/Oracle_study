--SCOTT
------------------------------------------------------------------------------------------
-- [오라클 연산자(Operator)
-- 1. 비교연산자 : WHERE 절 사용, 숫자, 날짜, 문자 비교
-- ( = )

------------------------------------------------------------------------------------------
-- 입사일자를 기준으로 3분기에 입사한 사원들을 조회
SELECT *
FROM emp;

-- 
SELECT empno, ename, hiredate
FROM emp
WHERE TO_CHAR(hiredate, 'Q') = '3';

--
SELECT *
FROM emp
WHERE EXTRACT(MONTH FROM hiredate) BETWEEN 7 AND 9;


--
SELECT e.*
    ,TO_CHAR(hiredate,'MM') H_MONTH
    ,EXTRACT(MONTH FROM hiredate) H_MONTH
    ,TO_CHAR(hiredate,'Q') H_QUATER  -- 분기를 나타내는
FROM emp e
WHERE EXTRACT(MONTH FROM hiredate) IN (7,8,9);

--예) ename C~S 사원 정보출력

SELECT *
FROM emp
--WHERE REGEXP_LIKE(ename,'^[C-S]','i')
WHERE ename BETWEEN 'C' AND 'T'
ORDER BY ename ASC;

--예) 1981년 6월1일 이후 입사한 30번 부서원의 정보를 조회

SELECT *
FROM emp
WHERE hiredate > TO_DATE('1981-06-01','YYYY-MM-DD') AND deptno = 30;

------------------------------------------------------------------------------------------
-- 2. 논리연산자 : AND OR NOT


------------------------------------------------------------------------------------------
-- 3. SQL연산자 : [NOT] IN ( 목록)
-- 예) 수도권 아닌 사원정보를 조회

SELECT *
FROM insa
WHERE city IN ('경기','서울','인천') 
ORDER BY city ASC;

------------------------------------------------------------------------------------------
-- 3. SET 연산자
-- 합집합(UNION, UNION ALL)
-- 교집합(INTERSECT)
-- 차집합(MINUS)


--전체:60명
SELECT COUNT(*)
FROM insa;

--부서가 '개발부'인 사원수 :14명
SELECT COUNT(*)
FROM insa
WHERE BUSEO = '개발부';


--출신지역이 '인천'인 사원수 :9명
SELECT COUNT(*)
FROM insa
WHERE city = '인천';

-- 17명 = 14+9 =23
SELECT name , ibsadate, buseo, city
FROM insa
WHERE buseo = '개발부'
--UNION  --합집합 : 중복제거
UNION ALL -- 합집합: 중복제거하지 않고 전부 합함
SELECT name , ibsadate, buseo, city
FROM insa
WHERE city = '인천';

--
SELECT name , ibsadate, buseo, city
FROM insa
WHERE buseo = '개발부' OR city = '인천';

-- 예) insa 테이블 사원 + emp 테이블 사원 합치고...
--ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다. << 에러메세지
-- 없는거라면 null로 맞추면된다
SELECT name,ibsadate,city,MOD(SUBSTR(ssn, -7,1),2)gender
FROM insa
UNION
SELECT ename,hiredate,null,null
FROM emp;


--교집합
SELECT name , ibsadate, buseo, city
FROM insa
WHERE buseo = '개발부'
INTERSECT
SELECT name , ibsadate, buseo, city
FROM insa
WHERE city = '인천';

--
SELECT name , ibsadate, buseo, city
FROM insa
WHERE buseo = '개발부' AND city = '인천';


-- 차집합 : 개발부 중에서 인천출신은 제외
SELECT name , ibsadate, buseo, city
FROM insa
WHERE buseo = '개발부'
MINUS
SELECT name , ibsadate, buseo, city
FROM insa
WHERE city = '인천';
--
SELECT name , ibsadate, buseo, city
FROM insa
WHERE buseo = '개발부' AND city !='인천';

------------------------------------------------------------------------------------------
-- 계층적 질의 연산자 : PRIOR, CONNECT_BY_ROOT
-- 계층적 질의 (hierarchical)

SELECT *
FROM emp;

SELECT *
FROM dept;

-- 예) 조인 문제 : DEPTNO, ENAME, SAL, DANME, HIREDATE 조회 출력

SELECT d.deptno, ename,sal,dname, hiredate
FROM dept d JOIN emp e ON d.deptno=e.deptno;







--SELECT 	[LEVEL] {*,컬럼명 [alias],...}
--	FROM	테이블명
--	WHERE	조건
--	START WITH 조건
--	CONNECT BY [PRIOR 컬럼1명  비교연산자  컬럼2명]
--		또는 
--		   [컬럼1명 비교연산자 PRIOR 컬럼2명]

-- 가짜칼럼/ 존재하지 않는 : LEVEL
SELECT empno, ename, mgr, LEVEL
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr
ORDER BY LEVEL ASC; -- TO-DOWN 방식


DROP TABLE TBL_TEST;

-- 예) 공과대학 계층구조
CREATE TABLE TBL_TEST(
deptno number(3) not null primary key,
dname varchar2(24) not null,
college number(3),
loc varchar2(10)
);



-- INSERT문

         COLLEGE        DEPTNO   DNAME             LOC      
        10            공과대학                                           1
       101        100 컴퓨터공학과                   1호관               3
       102        100 멀티미디어학과                 2호관               3
       200         10 메카트로닉스학부                                   2
       201        200 전자공학과                     3호관               3
       202        200 기계공학과                     4호관  


INSERT INTO TBL_TEST VALUES (101,'컴퓨터공학과',100,'1호관');
INSERT INTO TBL_TEST VALUES (102,'멀티미디어학과',100,'2호관');
INSERT INTO TBL_TEST VALUES (201,'전자공학과',200,'3호관');
INSERT INTO TBL_TEST VALUES (202,'기계공학과',200,'4호관');
INSERT INTO TBL_TEST VALUES (100,'정보미디어학부',10,null);
INSERT INTO TBL_TEST VALUES (200,'메카트로닉스학부',10,null);
INSERT INTO TBL_TEST VALUES (10,'공과대학',null,null);
COMMIT;
 

SELECT *
FROM tbl_test;

SELECT deptno, dname, college, LEVEL
FROM tbl_test
START WITH deptno =10
CONNECT BY PRIOR deptno=college;




SELECT LPAD(' ', (LEVEL-1)*2) || dname 조직도
FROM tbl_test
--WHERE dname != '정보미디어학부' -- 정보미디어학부 만 제거
START WITH dname='공과대학'
CONNECT BY PRIOR deptno=college AND dname != '정보미디어학부'; --정보미디어학부 가지에 있는 전부 제거




------------------------------------------------------------------------------------------
-- 5)연결 연산자( ¦¦ )
------------------------------------------------------------------------------------------
-- 6)산술연산자
SELECT 3+5,3-5,3*5,3/5
FROM dual

-- dual :  PUBLIC 시노님

SELECT *
FROM user_tables
WHERE table_name LIKE 'EMP';
-- OWNER 소유자 SCOTT -> HR    emp테이블조회할수있도록 권한 부여...

-- DCL  권한부여/회수
GRANT SELECT ON emp TO hr;
REVOKE 

grant select on emp to public;

------------------------------------------------------------------------------------------
--복잡한 쿼리문을 간단하게 해주고 데이터의 값을 조작하는데 사용되는 것 : [함수]
--ROUND : 숫자값을 특정 위치에서 반올림하여 리턴한다.


SELECT 1.67895
    ,ROUND(1.67895) --소수점 1자리
    ,ROUND(1.67895,0) --소수점 b+1자리
    ,ROUND(1.67895,3) --소수점 b+1자리
    ,ROUND(12345,-2) -- 음수의 경우 왼쪽으로
FROM dual;

------------------------------------------------------------------------------------------
--지정한 소수점 자리수 이하를 절삭한 결과 값을 반환하는 함수
--TRUNC () : 절삭 + 지정한 위치  /날짜도 절삭가능
--FLOOR () : 절삭 + 무조건 소수점 첫번째 자리에서 절삭 /절삭위치 불가

SELECT 1.67895
   ,TRUNC (1.67895)
   ,TRUNC (1.67895 ,0)
   ,TRUNC (1.67895,3)
   ,TRUNC (12395,-2)
   ,FLOOR (1.67895)
FROM dual;

------------------------------------------------------------------------------------------
-- 날짜 : Round(), TRUNC() ~ 

SELECT SYSDATE
    ,TO_CHAR(SYSDATE,'DS TS')
    ,ROUND(SYSDATE)
    ,ROUND(SYSDATE, 'year')--26/01/01
    ,ROUND(SYSDATE, 'day')--26/06/21
FROM dual;

--

SELECT SYSDATE
--    ,TO_CHAR(SYSDATE,'DS TS')
--    ,TRUNC(SYSDATE) --시간/분/초 00:00:00
--    ,TO_CHAR(TRUNC(SYSDATE),'DS TS')
--    ,TO_CHAR(TRUNC(SYSDATE,'YEAR'),'DS TS')
      ,TO_CHAR(TRUNC(SYSDATE,'MONTH'),'DS TS')
FROM dual;


--CEIL함수 : 올림(절상) 지정된 위치가 없이 소수점 첫번째 자리

SELECT CEIL(12.345),CEIL(12.745)
FROM dual

-- MOD() 나머지 구하는 함수
-- ABS() : 절대치 구하는 함수

SELECT ABS(3),ABS(-3)
FROM dual;

-- SIGN() 함수 : 숫자가 양수 : 1, 음수: -1 반환..  양수도 음수도 아니면 0 반환
-- 예) 회사의 급여 평균 
SELECT ename,
       pay,
       avg_pay,
       SIGN(pay - avg_pay) AS s
FROM (
        SELECT ename,
               sal + NVL(comm, 0) AS pay,
               ROUND(AVG(sal + NVL(comm, 0)) OVER (), 2) AS avg_pay
        FROM emp
     ) e;


SELECT 
    SUM(sal+NVL(comm,0)) SUM_PAY
    ,AVG(sal+NVL(comm,0)) AVG_PAY
    ,ROUND(AVG(sal+NVL(comm,0)),2) ROUND_PAY
FROM emp;


--POWER(): 누승
SELECT POWER(2,3),POWER(2,-3)
        ,SQRT(4),SQRT(2)
FROM dual;


-- 문자 함수 '' 

SELECT ename
    ,LOWER(ename)
    ,UPPER(ename)
    ,INITCAP(ename)
    ,LENGTH(ename)
    ,CONCAT(ename,'입니다')
    ,SUBSTR(ename,1,2)||'***'
    ,SUBSTR(ename,3)
FROM emp;

--INSTR() : 이름속에 N문자가 있는 위치를 파악

SELECT ename
    , INSTR(ename, 'N')
    , INSTR(ename, 'NE')
FROM emp;

--

SELECT 'ABCDEABCDEABCDE'
    ,INSTR('ABCDEABCDEABCDE','CD')-- 앞에서부터 찾은 첫번째 CD위치값을 반환
    ,INSTR('ABCDEABCDEABCDE','CD',1,2) -- 앞에서부터 찾은 두번째 CD위치값을 반환
    ,INSTR('ABCDEABCDEABCDE','CD',-1,1) -- 뒤에서부터 찾은 첫 번째 CD위치값을 반환
FROM dual;


-- 문제 

SELECT name,ssn
    ,SUBSTR(ssn,1,INSTR(SSN,'-')+1) ||'******'
    ,REGEXP_REPLACE(ssn,'([0-9]{6}-[0-9])[0-9]{6}','\1******')
    ,SUBSTR(ssn,1,8)||'******'
FROM insa;



--LPAD() / RPAD() 함수설명

SELECT ename
    ,RPAD(ename, 10,'*') -- SMITH*****
    ,LPAD(ename, 10,'*') -- SMITH*****
    ,LPAD(sal+NVL(comm,0),10,'*' ) PAY
FROM emp;



-- ASCII(CHAR), CHR()
SELECT ename
    ,ASCII( SUBSTR(ename,-1))
    ,CHR(72)
FROM emp;



-- 나열한 세 숫자 중에 가장 큰 값을 반환하는 함수 GREATEST(1,2,3)

SELECT GREATEST(100,75,120)
    , LEAST(100,75,120)
FROM dual;


-- VSIZE(CHAR) 지정된 문자열의 크기를 반환하는 함수
SELECT VSIZE('A'),VSIZE('한')
FROM dual;


-- RTRIM() / LTRIM() / TRIM() 공백제거

SELECT '[   ADMIN   ]'
    ,'['|| LTRIM( '   ADMIN   ' )||']'
    ,'['|| RTRIM( '   ADMIN   ' )||']'
    ,'['|| TRIM(  ' ' FROM '   ADMIN   ' )||']'
    -- TRIM ( 제거할 문자열 FROM 대상문자열)
FROM dual;




select RTRIM('BROWINGyxXxyxyxyxyxyxyxy','xy') "RTRIM example" 
FROM dual;

------------------------------------------------------------------------------------------
--날짜 함수 : SYSDATE,ROUND(DATE),TRUNC(DATE)<< 절삭은 사용함

SELECT SYSDATE
    ,CURRENT_TIMESTAMP 
FROM dual;


------------------------------------------------------------------------------------------
-- MONTHS_BETWEEN 함수 : 두 날짜간의 달 차이를 리턴하는 함수


SELECT SYSDATE
    , '2026.05.11'
    ,MONTHS_BETWEEN(SYSDATE,'2026.05.11')
    ,ROUND( MONTHS_BETWEEN(SYSDATE,'2026.05.11'))
FROM dual;


--예) emp테이블에서 모든 사원들의 근무 개월수를 조회


SELECT ename,hiredate,SYSDATE,
       ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)) --근무개월수
       ,ROUND(MONTHS_BETWEEN(SYSDATE, hiredate)/12,2) -- 년도
       ,ROUND(SYSDATE - hiredate) --근무일수
FROM emp;


SELECT SYSDATE + 10
     ,SYSDATE -5
     ,TO_CHAR(SYSDATE  +3/24,'DS TS' )
FROM dual;



-- 예) 3달후에 만나자

SELECT SYSDATE 
    ,SYSDATE + 3   --오늘부터 3일후
    ,ADD_MONTHS(SYSDATE , 3) --3달후
    ,ADD_MONTHS(SYSDATE , -2) --2개월전
FROM dual;


-- 예) 이번달 마지막 날짜가 몇일 조회

SELECT SYSDATE,
       TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE,1),'MONTH') - 1, 'DD')
       ,LAST_DAY(SYSDATE)
FROM dual;


--예) 다음주 월요일은 휴강입니다.

SELECT SYSDATE
  ,TO_CHAR(SYSDATE,'DY')
  ,TO_CHAR(SYSDATE,'DAY')
  ,NEXT_DAY(SYSDATE,'월요일')
FROM dual;

--예) 7월첫번째 목요일날 휴강입니다.
SELECT SYSDATE
  ,TRUNC(ADD_MONTHS(SYSDATE,1),'MONTH')
  ,NEXT_DAY(TRUNC(ADD_MONTHS(SYSDATE,1),'MONTH'),'목요일')-1
FROM dual;

------------------------------------------------------------------------------------------
-- 날짜/시간 함수
SELECT 
     SYSDATE  -- 날짜/시간  DB서버의 날짜/시간
    , CURRENT_DATE  -- 날짜/시간    현재 클라이어트/세션 날짜/시간
    , CURRENT_TIMESTAMP  -- 날짜/시간
FROM dual;

------------------------------------------------------------------------------------------
-- 변환함수
-- 1) TO_NUMBER() 문자-> 숫자 변환하는 함수

SELECT '123' -123
        ,TO_NUMBER(123) -123
        ,'100.98' - 50
FROM dual;

--2) TO_CHAR(날짜) : 날짜로부터 내가 원하는 형식의 정보를 문자로 변환할때 ...
--   TO_CHAR(숫자) : 
-- 예)

SELECT num,name
    , TO_CHAR( basicpay , '99,999,999')
    , TO_CHAR( sudang, '999,999')
    ,TO_CHAR( basicpay + sudang, 'L99G999G999')PAY
FROM insa;


-- 
SELECT TO_CHAR(100,'S9999')
        ,TO_CHAR(-100,'S9999')
        ,TO_CHAR(100,'9999MI')
        ,TO_CHAR(-100,'9999MI')
        ,TO_CHAR(-100,'9999PR')
FROM dual;


--예) 소수점 2자리까지 연봉을 출력...
SELECT ename
        ,TO_CHAR( (sal+NVL(comm,0))*12 , 'L9,999,999.99'   )  -- 연봉
FROM emp;

-- 문제) emp 테이블의 입사일자를  '1998년 10월 11일 일요일' 형식으로 출력.

SELECT ename, hiredate
        ,TO_CHAR(hiredate, 'YYYY"년" MM"월" DD"일" DAY')
FROM emp;


------------------------------------------------------------------------------------------
-- 일반함수

SELECT NVL(COMM, 0)
        ,NVL2(COMM, COMM,0)
        ,NULLIF(3,3)
        ,COALESCE(COMM,0) --나열해 놓은 값을 순차적으로 체크하여 NULL이 아닌값을 리턴하는 함수
FROM emp;

SELECT COALESCE(NULL,NULL,100,200)
FROM dual;

------------------------------------------------------------------------------------------
-- 그룹함수 : COUNT() NULL 값을 제외한 집계(기억)

SELECT COUNT(COMM)
--        ,COUNT(*)
--        ,SUM(SAL)
--        ,SUM(comm)
--        ,AVG(sal)
        ,AVG(comm)
        ,SUM(comm) /COUNT(*)
        ,MAX(COMM)
        ,MIN(COMM)
        ,MAX(SAL)
        ,MIN(SAL)
FROM emp;

-- 예) emp 테이블에서 PAY(S+C)을  MAX,MIN 조회


SELECT 
        MAX(SAL+NVL(COMM,0))MAX_PAY  --5000
        ,MIN(SAL+NVL(COMM,0))MIN_PAY --800
FROM emp;

-- 예) emp 테이블에서 PAY를 가장 많이 받는 사원의 이름, 번호, PAY를 출력

SELECT ENAME,EMPNO,SAL,COMM
    , SAL +NVL(COMM,0) PAY
FROM EMP
WHERE SAL + NVL(comm,0) =
      (
        SELECT MAX(SAL + NVL(comm,0))
        FROM EMP
      );

SELECT *
FROM emp;


------------------------------------------------------------------------------------------
