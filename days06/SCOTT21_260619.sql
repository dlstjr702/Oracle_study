--SCOTT
------------------------------------------------------------------------------------------
-- 예) emp 테이블에서 급여 (sal) Top - 5 조회..
-- ㄱ. RANK 분석함수
-- ㄴ. TOP-N 방식
--            1) FROM ( 서브쿼리 정렬 )

SELECT *
FROM emp
ORDER BY sal DESC;

--            2) WHERE ROWNUM 컬럼 조건
-- 1부터만 가능함 중간 번호부터 가져오는건 불가능!!
SELECT e.*, ROWNUM seq
FROM (
    SELECT *
    FROM emp
    ORDER BY sal DESC
) e
--WHERE ROWNUM = 1; TOP1
--WHERE ROWNUM >= 4; X
WHERE ROWNUM <= 5;


-- 예2) TOP_N
-- emp 테이블에서 사원수가 가장 많은 부서번호, 사원수 조회.

-- 풀이 TOP-N 방식 : ROWNUM 의사 컬럼
SELECT e.*, ROWNUM seq 
FROM (
    SELECT b.deptno,dname
           ,COUNT(*) emp_cnt
    FROM emp a JOIN dept b ON a.deptno = b.deptno
    GROUP BY b.deptno,dname
    ORDER BY emp_cnt DESC
)e
WHERE ROWNUM = 1;


-- 풀이2 RANK분석함수
SELECT e.*
FROM (
    SELECT deptno
           ,COUNT(*) emp_cnt
           ,RANK() OVER (ORDER BY COUNT(*) DESC) rnk
    FROM emp a 
    GROUP BY deptno
)e
WHERE rnk  BETWEEN 2 AND 3;
--WHERE rnk = 1;

--
SELECT e.*
FROM (
    SELECT deptno
           ,COUNT(*) emp_cnt
           ,RANK() OVER (ORDER BY COUNT(*) DESC) rnk
           ,DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) rnk2
           ,ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) rnk3
    FROM emp e 
    GROUP BY deptno
)e
WHERE rnk  BETWEEN 1 AND 4;

-- 풀이3) FETCH절 :  오라클 12c
--      ㄴ 정렬된 결과 집합에서 원하는 갯수의 행만 가져오는 절.

SELECT deptno
    ,COUNT (*) emp_cnt
FROM emp
GROUP BY deptno
ORDER BY emp_cnt DESC
FETCH FIRST 2 ROW WITH TIES; -- 2등 여러명
FETCH FIRST 2 ROW ONLY; -- 1등 1명
FETCH FIRST 1 ROW ONLY;

-- 예) WHIT TIES확인 , sal

SELECT *
FROM emp
ORDER BY sal DESC
FETCH FIRST 2 ROW WITH TIES;
FETCH FIRST 2 ROW ONLY
FETCH FIRST 1 ROW ONLY;

-- 예) FETCH 절 OFFSET고 함께 사용해서 5~10 등 번째 데이터를 얻어 올 수있다.

SELECT *
FROM emp
ORDER BY sal DESC
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;



-- 풀이4) KEEP 함수    

SELECT
    -- e.deptno
    MAX(e.deptno) KEEP(DENSE_RANK FIRST ORDER BY e.emp_cnt DESC) max_deptno
    ,MAX(e.emp_cnt) max_emp_cnt
FROM(
    SELECT deptno,
            COUNT(*) emp_cnt
    FROM emp 
    GROUP BY deptno
)e;

-- 예) 각부서별로 최고액 , 최저액 사원의 정보를 조회

--SELECT *
--FROM emp e
--WHERE sal = (
--          SELECT MAX(sal)
--          FROM emp
--          WHERE deptno = e.deptno
--      )
--   OR sal = (
--          SELECT MIN(sal)
--          FROM emp
--          WHERE deptno = e.deptno
--      )
--ORDER BY deptno, sal;

-- 풀이1) ROW_NUMBER() : 권장


SELECT deptno, ename,sal
FROM(
    SELECT deptno, ename,sal
        ,ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) sdr
        ,ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal ASC) sar
    FROM emp
)
WHERE sdr = 1 OR sar = 1;



-- 풀이 2) KEEP (DENSE_RANK...)사용

SELECT deptno
    ,MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal DESC) max_ename
    ,MAX(sal) max_ename
    ,MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal ) min_ename
    ,MAX(sal) min_ename
FROM emp
GROUP BY deptno
ORDER BY deptno;




-- 풀이 3) JOIN  : 동점자도 모두 조회

SELECT e.*
FROM emp e JOIN (
                    SELECT deptno
                        , MAX(sal) max_sal
                        , MIN(sal) min_sal
                    FROM emp
                    GROUP BY deptno
                ) t
            --ON NVL(t.deptno , -1) = NVL(e.deptno ,-1) --NULL = NULL X
            ON t.deptno = e.deptno OR ( e.deptno IS NULL AND  t.deptno IS NULL)
WHERE e.sal = t.max_sal OR e.sal = min_sal AND e.deptno = t.deptno
ORDER BY e.deptno, e.sal DESC;


-- 예) emp 테이블에서 sal 컬럼을 기준으로 3등급 (상/중/하) 출력하는 쿼리를 작성.

SELECT empno,ename,sal,
       CASE NTILE(3) OVER (ORDER BY sal DESC)
           WHEN 1 THEN '상'
           WHEN 2 THEN '중'
           WHEN 3 THEN '하'
       END grade
FROM emp;


SELECT empno,ename,sal,
       CASE 
           WHEN sal >= 3000 THEN '상'
           WHEN sal >= 1500 THEN '중'
           ELSE '하'
       END grade
FROM emp
ORDER BY sal DESC;


-- 풀이 1번
-- NON EQUAL JOIN
SELECT ename, sal, s.grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;


-- 풀이 2번 ) 
-- NTILE() 분석함수
-- N-타일 , 정렬된 데이터를 N개의 그룹으로 균등하게 나누는 분석함수
-- 번호 1/2/3 ~ 반환하는 함수
-- NTILE (N) OVER(ORDER BY 컬럼)
-- 최대한 균등하게 분배한다.


-- CASE 방법
SELECT ename, sal
        ,CASE NTILE(3) OVER (ORDER BY sal DESC)
           WHEN 1 THEN '상'
           WHEN 2 THEN '중'
           WHEN 3 THEN '하'
       END grade
FROM emp;

-- DECODE방법
SELECT ename, sal
        ,DECODE( NTILE(3) OVER (ORDER BY sal DESC) ,1,'상',2,'중',3,'하')grade
FROM emp;


-- 풀이 3번 ) PERCENT_RANK() 분석함수

SELECT ename, sal,TRUNC(p_r,4)
    ,CASE
        WHEN p_r < 0.33 THEN '상'
        WHEN p_r BETWEEN 0.33 AND 0.66 THEN '중'
        ELSE '하'
    END grade
FROM(
    SELECT ename, sal, 
        PERCENT_RANK() OVER(ORDER BY sal DESC) p_r
    FROM emp
)t;


-- 예) insa 테이블에서 오늘을 기준으로 생일이 지났다, 오늘이 생일이다, 생일이 지나지 않았다 출력
-- 6/19
-- 1001,1002 사원 생일 월/일 -> 6/19 수정

SELECT SYSDATE
    ,TO_CHAR( SYSDATE, 'MMDD' )
FROM dual

--

SELECT ssn
FROM insa
WHERE num IN (1001,1002);

-- 771212-1022432   770619-1022432
-- UPDATE

UPDATE insa
--SET ssn = SUBSTR(ssn,1,2) || TO_CHAR( SYSDATE, 'MMDD' ) || SUBSTR(ssn,7);
SET ssn = REGEXP_REPLACE( ssn, '^(\d{2})(\d{4})(-\d{7})$', '\1' || TO_CHAR( SYSDATE, 'MMDD') || '\3')
WHERE num IN (1001,1002);
COMMIT;



SELECT ssn
FROM insa
WHERE num IN (1001,1002);

-- 


SELECT name, ssn
    , TO_CHAR(SYSDATE ,'MMDD')
    , SUBSTR(ssn, 3,4)
    , SIGN(TO_CHAR(SYSDATE ,'MMDD') - SUBSTR(ssn, 3,4))
    ,DECODE( SIGN(TO_CHAR(SYSDATE ,'MMDD') - SUBSTR(ssn, 3,4)),0
    
    
    
-- 예 ) insa 테이블에서 주민등록번호 (ssn)로 만나이를 계산해서 출력
-- 올해년도 2026   생일년도 2027
-- 만나이 = 생일년도 - 올해년도 = 1    생일이 지나지 않으면 -1
-- 성별 1/2/5/6   1900년대생
--     3/4/7/8    2000년대생
--        9/0     1800년대생
SELECT name, ssn, SYSDATE
        ,TO_CHAR(SYSDATE, 'YYYY') year
        , SUBSTR(ssn,1,2) birth_day
FROM insa;



SELECT name, ssn
--     , TO_CHAR( SYSDATE, 'MMDD' )
--     , SUBSTR( ssn, 3, 4 )
--     , SIGN(  TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( ssn, 3, 4 ) )
     , DECODE( SIGN(  TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( ssn, 3, 4 ) ), 0, '오늘', -1, '지나지않음', 1,  '지남' ) birthday_status
FROM insa;



-- 풀이 1) 

SELECT name, ssn,current_year,birth_year,current_year - birth_year + birthday_status
FROM(
    SELECT i.*
        , TO_CHAR(SYSDATE, 'YYYY') current_year
        --, SUBSTR(ssn,-7,1) gender
        ,  CASE
                WHEN SUBSTR(ssn,-7,1) IN (1,2,5,6) THEN 1900
                WHEN REGEXP_LIKE (SUBSTR(ssn,-7,1) ,'[3478]') THEN 2000
                ELSE 1800
        END +  SUBSTR(ssn,1,2) birth_year
        , DECODE( SIGN(  TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( ssn, 3, 4 ) ),  -1, -1,  0 ) birthday_status   
    FROM insa i
)
-- 풀이 2) 실무 + 오라클 : 만나이
-- 주민등록번호 -> 생일 날짜 생성

SELECT name,ssn
    , FLOOR( MONTHS_BETWEEN(SYSDATE ,birthday)/12)
FROM(
    SELECT
        insa.*
        ,SYSDATE
        ,SUBSTR(ssn,1,6)
        ,TO_DATE(
            CASE
                WHEN SUBSTR(ssn,-7,1) IN (1,2,5,6) THEN 19
                WHEN REGEXP_LIKE (SUBSTR(ssn,-7,1) ,'[3478]') THEN 20
                ELSE 18
            END ||  SUBSTR(ssn,1,6)
        ) birthday
    FROM insa
)t;



-- 예) insa 테이블에서 사원들을 랜덤하게 5명 뽑아서 청소...

SELECT *
FROM(
    SELECT e.*
        ,DBMS_RANDOM.VALUE rv
    FROM insa e
    ORDER BY rv
)
WHERE ROWNUM <=5;
-- 위의 쿼리 설명 .....

-- 0.0 <=       실수 DBMS_RANDOM.VALUE    <1.0
-- 1.0 <=       실수 DBMS_RANDOM.VALUE(1,46)    <46.0
-- 0.0 <=       실수 Math.random    <1.0


SELECT DBMS_RANDOM.VALUE
        ,FLOOR(DBMS_RANDOM.VALUE(1,46))
FROM dual;
--TOP-N
-- 
SELECT *
FROM(
    SELECT *
    FROM emp
    ORDER BY DBMS_RANDOM.VALUE 
)
WHERE ROWNUM <=5;


SELECT DBMS_RANDOM.STRING('X', 10)  -- 대문자 + 숫자
     , DBMS_RANDOM.STRING('U', 10)  -- 대문자
     , DBMS_RANDOM.STRING('L', 10)  -- 소문자
     , DBMS_RANDOM.STRING('P', 10)  -- 대문자 + 소문자 + 숫자 + 특수문자
     , DBMS_RANDOM.STRING('A', 10)  -- 알파벳(대+소문자)
FROM dual;


-- LISTAGG 함수 AGG(aggreation)
-- ㄴ 여러 행(ROW)의 값을 하나의 문자열로 집계 (연결)하는 함수.
-- ㄴ LISTAGG( 컬러명, 구분자) WITHIN GROUP(ORDER BY 컬럼명)
-- 1) 모든 사원의 이름 출력

SELECT ename FROM emp;

--
SELECT LISTAGG(ename, ',') WITHIN GROUP (ORDER BY hiredate) "emp_list_agg"
FROM emp;

--
SELECT LISTAGG(ename, ',') WITHIN GROUP (ORDER BY hiredate) "emp_list_agg"
FROM emp;

-- 2) 부서별로 사원명 출력...

SELECT d.deptno,
       COUNT(e.empno) emp_cnt,
       NVL(
           LISTAGG(e.ename, ',')
           WITHIN GROUP (ORDER BY e.sal DESC),
           'EMPTY'
       ) emp_list_agg
FROM dept d
LEFT OUTER JOIN emp e
ON d.deptno = e.deptno
GROUP BY d.deptno
ORDER BY d.deptno;

--2-2

SELECT deptno
    , LISTAGG(ename, ',') WITHIN GROUP (ORDER BY sal DESC) OVER(PARTITION BY deptno)emp_list
FROM emp;



-- 예 ) 부서별 직무 목록 출력
SELECT deptno,
       LISTAGG(job, ',') WITHIN GROUP (ORDER BY job ASC)  "Employees"
FROM emp
GROUP BY deptno
ORDER BY deptno;

-- 부서명 출력
SELECT d.deptno,d.dname,
       LISTAGG(job, ',') WITHIN GROUP (ORDER BY job ASC)  "Employees"
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno,d.dname
ORDER BY d.deptno;

-- 예) 관리자별 부하 직원 목록 + mgr,ename
SELECT mgr
    ,LISTAGG(job, ',') WITHIN GROUP (ORDER BY ename)  "emp_list"
FROM emp 
WHERE mgr IS NOT NULL
GROUP BY mgr;

--
SELECT a.mgr, b.ename, a.emp_list
FROM (
    SELECT mgr
        ,LISTAGG(job, ',') WITHIN GROUP (ORDER BY ename) emp_list
    FROM emp 
    WHERE mgr IS NOT NULL
    GROUP BY mgr
)a JOIN emp b ON a.mgr = b.empno;

--

SELECT a.mgr,b.ename,
       LISTAGG(a.job, ',')WITHIN GROUP (ORDER BY a.ename) AS emp_list
FROM emp a JOIN emp b ON a.mgr = b.empno
WHERE a.mgr IS NOT NULL
GROUP BY a.mgr, b.ename;


--SELF JOIN

SELECT a.empno,a.ename,a.mgr, b.ename,
FROM emp a JOIN emp b ON a.mgr = b.empno;



-- 입사년도별 사원 목록


SELECT TO_CHAR(hiredate,'YYYY')
    ,COUNT(*)
    ,LISTAGG(ename,',')WITHIN GROUP(ORDER BY ename) "Emp_list"
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY 1;


-- 급여 등급별로 사원 목록
SELECT grade,
       LISTAGG(ename, ',') WITHIN GROUP (ORDER BY sal DESC) emp_list
FROM (
    SELECT ename, sal,
           CASE NTILE(3) OVER (ORDER BY sal DESC)
               WHEN 1 THEN '상'
               WHEN 2 THEN '중'
               WHEN 3 THEN '하'
           END grade
    FROM emp
)
GROUP BY grade
ORDER BY grade;


-- 선생님 풀이 방식

SELECT *FROM emp;
SELECT *FROM slgrade;
--
SELECT ename ,sal, losal ||'~' ||hisal ,grade
FROM emp e JOIN salgrade s ON sal BETWEEN losal AND hisal;
--

SELECT t.grade
    ,LISTAGG(ename,',') WITHIN GROUP (ORDER BY ename) emp_list
FROM (
    SELECT e.*
        ,grade
    FROM emp e JOIN salgrade s ON sal BETWEEN losal AND hisal
)t
GROUP BY t.grade
ORDER BY t.grade


-- 문제) 사원수가 가장 많은 부서 및 가장 적은 부서 정보 출력

    DEPTNO DNAME                 CNT   CNT_RANK
---------- -------------- ---------- ----------
        30 SALES                   6          1
        40 OPERATIONS              0          4
        
        
-- 내풀이
SELECT deptno,
       dname,
       cnt,
       cnt_rank
FROM(
    SELECT d.deptno, d.dname
        ,COUNT(e.empno) cnt
        ,RANK() OVER(ORDER BY COUNT(e.empno) DESC) cnt_rank
        ,RANK() OVER(ORDER BY COUNT(e.empno) ASC) min_rank
    FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno 
    GROUP BY d.deptno, d.dname
)
WHERE cnt_rank = 1 OR min_rank = 1

-- 선생님 풀이

WITH a AS(
    SELECT d.deptno, d.dname,COUNT(e.empno) emp_cnt
        ,RANK() OVER(ORDER BY COUNT(*) DESC) cnt_rank
    FROM dept d LEFT OUTER JOIN emp e ON d.deptno = e.deptno 
    GROUP BY d.deptno, d.dname
),
b AS(
    SELECT MAX(emp_cnt) maxcnt,MIN(emp_cnt) mincnt
    FROM a
)
SELECT a.*
FROM a JOIN b ON a.emp_cnt IN (b.maxcnt, b.mincnt);


-- 피벗(PIVOT) /언피봇(UNPIVOT) 설명
-- 피봇 : 행 데이터를 열로 회전시켜 보여주는 기능.
-- 1단계) 대상쿼리 (원본쿼리)

SELECT job
FROM emp;

--CLERK
--SALESMAN
--SALESMAN
--MANAGER
--SALESMAN
--MANAGER
--MANAGER
--PRESIDENT
--SALESMAN
--CLERK
--ANALYST
--CLERK
--ANALYST
--CLERK

-- 2단계) 오라클 피봇 기능을 사용하지 않고 ~~
SELECT 
    COUNT(DECODE(job,'CLERK','O')) CLERK
    ,COUNT( DECODE(job,'SALESMAN','O')) SALESMAN
    ,COUNT(DECODE(job,'PRESIDENT','O')) PRESIDENT
    ,COUNT(DECODE(job,'MANAGER','O')) MANAGER
    ,COUNT(DECODE(job,'ANALYST','O')) ANALYST
FROM emp;

-- 3단계) 피봇기능


--SELECT *
--FROM (
--    1) 원본쿼리 : 결과가 
--)
--PIVOT (
--    집계함수  COUNT(*,JOB)
--    FOR 회전할컬럼 원본쿼리의 컬럼 중에 JOB컬럼
--    IN (값1, 값2, 값3 ...직무 LIST)
--);
----------
SELECT *
FROM(
    SELECT job
    FROM emp
)
PIVOT(
    COUNT(*)
    FOR job
    IN('CLERK' ,'SALESMAN' ,'PRESIDENT' ,'MANAGER' ,'ANALYST')
);

--
SELECT *
FROM(
    SELECT d.deptno,dname,job -- 대상(원본) 쿼리
    FROM emp e FULL JOIN dept d ON e.deptno = d.deptno
)
PIVOT(
    COUNT(*)
    FOR job
    IN('CLERK' ,'SALESMAN' ,'PRESIDENT' ,'MANAGER' ,'ANALYST')
)
ORDER BY deptno;

--
------------------------------------------------------------------------------------------
-- UNPIVOT 예제
A)
   'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
---------- ---------- ----------- ---------- ----------
         4          4           1          3          2
         
B)
JOB          EMP_CNT
--------- ----------
CLERK              4
SALESMAN           4
PRESIDENT          1
MANAGER            3
ANALYST            2
;

SELECT *
FROM (
    SELECT *
    FROM (
        SELECT job
        FROM emp
    )
    PIVOT (
        COUNT(*)
        FOR job IN (
            'CLERK'     AS CLERK,
            'SALESMAN'  AS SALESMAN,
            'PRESIDENT' AS PRESIDENT,
            'MANAGER'   AS MANAGER,
            'ANALYST'   AS ANALYST
        )
    )
) t
UNPIVOT (
    emp_cnt
    FOR job IN (
        CLERK,
        SALESMAN,
        PRESIDENT,
        MANAGER,
        ANALYST
    )
);

------------------------------------------------------------------------------------------
-- UNPIVOT 구문 형식
UNPIVOT (
    값컬럼명
    FOR 구분컬럼명
    IN (
        컬럼1,
        컬럼2,
        컬럼3
    )
)
------------------------------------------------------------------------------------------
-- 예) 피봇 2번째 예제
-- emp 테이블에서 각 월별 입사한 사원수 조회....
-- 1단계 ) 피봇 대상 쿼리

SELECT 
    --TO_CHAR (hiredate, 'YYYY') year
    TO_CHAR(hiredate,'MM') month
FROM emp;

-- 피봇


SELECT *
FROM(
    SELECT
        TO_CHAR (hiredate, 'YYYY') year
        ,TO_CHAR(hiredate,'MM') month
    FROM emp
)
PIVOT(
    COUNT(*)
    FOR month
    IN('01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12')
);



-- 예 ) insa 테이블 생일 지남 유무...
-- 생 X 오  생o
-- 10   2    57
-- 1) DECODE 집계

WITH t AS(
    SELECT ssn
        ,TO_CHAR( SYSDATE , 'MMDD') current_md
        ,SUBSTR(ssn , 3,4) birth_md
        ,SIGN( TO_CHAR( SYSDATE , 'MMDD') - SUBSTR(ssn , 3,4)) birth_sign
    FROM insa
)
SELECT 
    COUNT( DECODE( birth_sign, 0,'O' ))오늘생일
    ,COUNT( DECODE( birth_sign, 1,'O' ))생일지남
    ,COUNT( DECODE( birth_sign, -1,'O' ))생일안지남
FROM t;



-- PIVOT 
SELECT *
FROM(
   SELECT ssn
        ,SIGN( TO_CHAR( SYSDATE , 'MMDD') - SUBSTR(ssn , 3,4)) birth_sign
    FROM insa
)
PIVOT(
    COUNT(*)
    FOR birth_sign
    IN(  0  AS "오늘생일",1  AS "생일지남",-1  AS "생일안지남")
);


-- 2) PIVOT 집계
------------------------------------------------------------------------------------------
---- [ 피봇의 실무 사용  ]
--1. 월별 매출 보고서
--2. 부서별 직급 인원 현황
--3. 설문조사 결과 집계
--4. 병원 진료 통계
----> DBMS 호환성과 유지보수 때문에 X.

------------------------------------------------------------------------------------------
-- 예) 각 부서별 pay 총합 행 -> 열 (피봇)

--SELECT deptno
--    ,SUM( sal +NVL(comm,0)) pay
--FROM emp
--ORDER BY deptno;


--
SELECT *
FROM(
    SELECT DEPTNO, SAL+NVL(COMM,0) PAY
    FROM EMP
)
PIVOT(
    SUM(PAY)
    ,MAX(PAY) AS 최고액
    ,MIN(PAY) AS 최저액
    FOR DEPTNO
    IN( 10,20,30,40,NULL)
);


------------------------------------------------------------------------------------------
-- 예) WIDTH_BUCKET(expression, min_value, max_value, num_buckets)
-- 숫자값을 지정된 범위 (min_value ~max_value)를 균등한 구간 (bucket)을 나누어서
-- 해당 숫자값이 어떤 구간(버킷)에 해당하는 지를 반환하는 함수


-- 0<= 5RNRKS <= 5000

SELECT 
    --ename,sal
    WIDTH_BUCKET(sal, 0,5001, 5) wb
    ,COUNT(*) cnt
FROM emp
GROUP BY WIDTH_BUCKET(sal, 0,5001, 5);


-- 실무 활용 사례 1. 고객 구매금액 등급
-- 실무 활용 사례 2. 연령대 분석
-- 실무 활용 사례 3. 시험 점수 분포
-- 실무 활용 사례 4. 급여 구간 분석


-- 차이점 :  NTILE(5) OVER (ORDER BY sal) 레코드(행) 수 균등하게 분배해서 구간...


--[ SET 연산자 ] + SQL 연산자 (ANY , SOME, ALL, EXISTS)정리
-- 예) EMP 테이블에서 사원이 존재하지 않는 부서번호 + 부서명 조회
WITH t AS(
    SELECT deptno
    FROM dept
    MINUS
    SELECT DISTINCT deptno
    FROM emp
)
SELECT t.deptno,d.dname
FROM t JOIN dept d ON t.deptno = d.deptno;


--Exists연산자..
SELECT deptno
FROM dept m
WHERE  NOT EXISTS (SELECT empno FROM emp WHERE deptno = m.deptno );

-- 

SELECT d.deptno, COUNT(empno)
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
HAVING COUNT(empno) = 0;

------------------------------------------------------------------------------------------
-- ■ [문제] 
-- DDL 문 : CREATE 
CREATE TABLE tbl_pivot
(
--    컬럼명 자료형(크기)       제약조건...
     no    NUMBER            PRIMARY KEY -- 고유한키(PK) 제약조건 = UK + NN
   , name  VARCHAR2(20 BYTE) NOT NULL    -- NN 제약조건(== 필수입력사항)
   , jumsu NUMBER(3)         -- NULL 허용
);


-- Table TBL_PIVOT이(가) 생성되었습니다.
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '박예린', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '박예린', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '박예린', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '안시은', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '안시은', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '안시은', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '김민', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '김민', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '김민', 100 );  -- mat 

COMMIT; 
---

SELECT * 
FROM tbl_pivot;

--( 피봇되어져서 결과 출력)
--번호 이름 국 영 수
--1 박예린 90 89 99
--2 안시은 56 45 12
--3 김민   99 85 100




SELECT ROW_NUMBER() OVER(ORDER BY first_no) 번호,
       name 이름,국,영,수
FROM (
    SELECT *
    FROM (
        SELECT MIN(no) OVER(PARTITION BY name) first_no,name,jumsu,
               ROW_NUMBER() OVER(PARTITION BY name ORDER BY no) rn
        FROM tbl_pivot
    )
    PIVOT (
        MAX(jumsu)
        FOR rn IN (
            1 AS 국,
            2 AS 영,
            3 AS 수
        )
    )
)
ORDER BY 번호;




------------------------------------------------------------------------------------------