--SCOTT
------------------------------------------------------------------------------------------
-- 예) emp 테이블에서 comm이 400 미만이 사원의 정보 조회
-- (조건 : comm 이 null인 사원도 포함)

SELECT *
FROM emp
WHERE comm < 400 OR comm IS NULL;
-- LNNVL(조건) 함수 :  [L]LOGICALLY [N]NEGATED NVL 함수
--        조건이          NULL인 경우에 TRUE 반환
--        조건이          FALSE인 경우에도 TRUE 반환

SELECT *
FROM emp
WHERE NLNVL( comm >= 400 );


------------------------------------------------------------------------------------------
--SELECT문 7가지절
-- 1 WITH
-- 6 SELECT
-- 2 FROM
-- 3 WHERE
-- 4 GROUP BY 절 
-- 5 HAVING 절
-- 7 ORDER BY 

-- 예) 각 부서별 사원수 조회


SELECT *
FROM emp

--
SELECT deptno,
       COUNT(*) AS cnt
FROM emp
GROUP BY deptno;
--
SELECT COUNT(*) FROM emp WHERE deptno=10
UNION ALL
SELECT COUNT(*) FROM emp WHERE deptno=20
UNION ALL
SELECT COUNT(*) FROM emp WHERE deptno=30
UNION ALL
SELECT COUNT(*) FROM emp WHERE deptno=40
--
SELECT 10, COUNT(*) FROM emp WHERE deptno=10
UNION ALL
SELECT 20, COUNT(*) FROM emp WHERE deptno=20
UNION ALL
SELECT 30, COUNT(*) FROM emp WHERE deptno=30
UNION ALL
SELECT 40, COUNT(*) FROM emp WHERE deptno=40
UNION ALL
SELECT NULL, COUNT(*) FROM emp;
-- 
SELECT  DISTINCT deptno
    ,(SELECT  COUNT(*) FROM emp WHERE deptno=e.deptno) 사원수
FROM emp e
ORDER BY deptno ASC;
--

SELECT  DISTINCT deptno
    ,(SELECT  COUNT(*) FROM emp WHERE deptno=e.deptno) 사원수
FROM emp e
UNION ALL
SELECT NULL, 
COUNT(*) 
FROM emp
ORDER BY deptno ASC;

-- GROUP BY 절
SELECT deptno,COUNT(*),SUM (SAL +NVL(comm,0)),ROUND( AVG((SAL +NVL(comm,0))),2)
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

------------------------------------------------------------------------------------------
-- 예) 직속상사가 없는 사원의 사원번호를 NULL로 수정

SELECT *
FROM emp
WHERE mgr IS NULL;
--
UPDATE emp 
SET deptno = null 
WHERE empno = 7839;
COMMIT;
--WHERE ename = UPPER ('KING');


------------------------------------------------------------------------------------------
-- 예) 10,20,30,40 0 사원이 존재하지 않는 부서도 출력..
SELECT d.deptno, COUNT(empno)
--FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
FROM emp e FULL OUTER JOIN dept d ON d.deptno = e.deptno
GROUP BY d.deptno
ORDER BY d.deptno;

------------------------------------------------------------------------------------------
-- 예) insa 테이블에서 각 부서별 사원수 조회

SELECT buseo,
       COUNT(*) AS 카운트
FROM insa
GROUP BY buseo;

-- 각부서의 남자사원수 조회
SELECT BUSEO,
       COUNT(*) 남자사원수
FROM INSA
WHERE  MOD(SUBSTR(SSN,-7,1),2) =1
--WHERE SUBSTR(SSN, 8, 1) IN ('1', '3','5','7','9')
GROUP BY BUSEO;


--
SELECT t.*
FROM (
        SELECT buseo,COUNT(*) CNT
        FROM insa
        WHERE MOD(SUBSTR(ssn, -7,1),2) =1
        GROUP BY BUSEO
        ORDER BY BUSEO
        )t
WHERE  t.CNT >= 5
ORDER BY t.CNT DESC;

--HAVING 절 
SELECT buseo,COUNT(*) CNT
FROM insa
WHERE MOD(SUBSTR(ssn, -7,1),2) =1
GROUP BY BUSEO
HAVING COUNT(*) >= 5
ORDER BY BUSEO;


SELECT *
FROM insa

------------------------------------------------------------------------------------------
--예) 각 부서별로 최고급여액을 받는 사원의 정보를 조회.

SELECT NAME, BUSEO, BASICPAY, SUDANG,
       BASICPAY + SUDANG PAY
FROM INSA I
WHERE BASICPAY + SUDANG =
      (
        SELECT MAX(BASICPAY + SUDANG)
        FROM INSA
      )
ORDER BY PAY DESC;


SELECT NAME, BUSEO, BASICPAY, SUDANG,
       BASICPAY + SUDANG AS PAY
FROM INSA I
WHERE BASICPAY + SUDANG =
      (
        SELECT MAX(BASICPAY + SUDANG)
        FROM INSA
        WHERE BUSEO = I.BUSEO
);


SELECT *
FROM emp

SELECT *
FROM EMP M
WHERE SAL+NVL(COMM,0) =(
        SELECT  MAX(SAL+NVL(COMM,0))
        FROM EMP
        WHERE DEPTNO = M.DEPTNO
    )
    
    
-- 3) GROUP BY 절 IN 연산자

SELECT *
FROM EMP E
WHERE (E.DEPTNO, SAL+NVL(COMM,0)) IN (
    SELECT DEPTNO, MAX(SAL+ NVL(COMM,0))
    FROM emp
    GROUP BY DEPTNO
)
ORDER BY E.DEPTNO;


-- 4) 급여순으로 등수 ,RANK() 함수

SELECT E.*
    ,SAL + NVL(COMM,0) PAY
FROM EMP E
ORDER BY PAY DESC;

--

SELECT *
FROM(
    SELECT E.*
    ,RANK () OVER(ORDER BY SAL + NVL(COMM , 0) DESC ) PAY_RANK
    FROM EMP E
) T
WHERE T.PAY_RANK =1;


-- 각부서별 급여 1등
SELECT T.DEPTNO, T.PAY_RANK,EMPNO,ENAME,SAL + NVL(COMM,0)PAY
FROM(
    SELECT E.*
        ,RANK() OVER( PARTITION BY DEPTNO ORDER BY SAL+ NVL(COMM,0) ) PAY_RANK
    FROM EMP E
)T
WHERE PAY_RANK <=2; -- 각부서 2등까지
--WHERE PAY_RANK = 1; -- 각부서 1등



------------------------------------------------------------------------------------------
-- 예) 각 부서의 사원 조회.

SELECT COUNT(*) FROM emp WHERE deptno=10;
SELECT COUNT(*) FROM emp WHERE deptno=20;
SELECT COUNT(*) FROM emp WHERE deptno=30;
SELECT COUNT(*) FROM emp WHERE deptno=40;
SELECT COUNT(*) FROM emp WHERE deptno IS NULL;

-- 한번에 출력


SELECT 
    (SELECT COUNT(*) FROM emp WHERE deptno=10 ) deptno_10
    ,(SELECT COUNT(*) FROM emp WHERE deptno=20 ) deptno_20
    ,(SELECT COUNT(*) FROM emp WHERE deptno=30 ) deptno_30
    ,(SELECT COUNT(*) FROM emp WHERE deptno=40 ) deptno_40
    ,(SELECT COUNT(*) FROM emp WHERE IS NULL ) deptno_null
FROM dual

--DECODE() 수정
--if(A=B){C}
--DECODE(A,B,C);

--DECODE(A,B,C,D)
--if(A=B){
--    ㄱ
--}else if(A=C){
--    ㄴ
--}else if(A=D){
--    ㄷ
--}else{
--    ㄹ
--}


--DECODE로 수정
SELECT 
     COUNT( DECODE(deptno,10,'O')) deptno_10
     ,COUNT( DECODE(deptno,20,1000)) deptno_20
     ,COUNT( DECODE(deptno,30,1)) deptno_30
     ,COUNT( DECODE(deptno,40,2)) deptno_40
--    ,COUNT( DECODE(deptno,'null',-1)) deptno_null    = 비교연산자  
--    ,(SELECT COUNT(*) FROM emp WHERE deptno=20 ) deptno_20
--    ,(SELECT COUNT(*) FROM emp WHERE deptno=30 ) deptno_30
--    ,(SELECT COUNT(*) FROM emp WHERE deptno=40 ) deptno_40
--    ,(SELECT COUNT(*) FROM emp WHERE IS NULL ) deptno_null
FROM emp;


--insa 테이블에서  이름 , 주민번호, 성별(남자,여자) 출력


SELECT *
FROM insa;

SELECT name
    ,ssn
    ,MOD(SUBSTR(ssn, 8, 1) , 2 )성별
    ,NVL( DECODE(SUBSTR(ssn,-7,1) ,1,'남자'),'여자') 성별
    ,NVL2( NULLIF( MOD( SUBSTR(ssn, -7, 1) , 2 ) , 1 ), 'O', 'X') gender
    ,REPLACE(REPLACE(MOD(SUBSTR(ssn, 8, 1) , 2 ), 1, 'X'), 0, 'O') gender
    ,CASE MOD( SUBSTR(ssn, -7, 1) , 2 )
        WHEN 1 THEN '남자'
        ELSE        '여자'
     END GENDER_CASE
    ,CASE 
        WHEN MOD( SUBSTR(ssn, -7, 1) , 2 )=1 THEN '남자'
        ELSE  '여자'
     END
FROM insa;


SELECT name
      , ssn
      , CASE MOD(SUBSTR(ssn, -7, 1), 2)
            WHEN 1 THEN '남자'
            ELSE '여자'
        END  gender
      , CASE  WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN 'Male'
            ELSE 'feMale'
        END  gender2
FROM insa;

--예) emp 테이블에서 모든사원의 PAY의 10%인상해서 출력하는 쿼리 작성.

SELECT e.*,SAL
    ,SAL+NVL(COMM,0)PAY
    ,'10%'
    ,(SAL+NVL(COMM,0))*1.1
FROM emp e
-- 10%인상 업데이트문
--UPDATE emp
--SET sal = sal*1.1;
--ROLLBACK;

--예) emp 테이블에서 10번 부서원은 sal 10% 인상, 20번 25%, 30번 15% 인상 그외는 인상하지 않도록 조회

SELECT ename, sal
    , CASE deptno
         WHEN 10 THEN '10%'
         WHEN 20 THEN '25%'
         WHEN 30 THEN '15%'
         ELSE '0%' 
      END rate
    , sal * DECODE( deptno, 10,  1.1, 20 , 1.25, 30,  1.15 )   i_sal
    , sal *  CASE deptno
                WHEN 10 THEN 1.1
                WHEN 20 THEN 1.25
                WHEN 30 THEN 1.15        
             END i_sal2
FROM emp;


--예) 위와 같이 sal 인상률만큼 업데이트하는 문을 작성

--UPDATE emp
--SET sal = sal *  CASE deptno
--                WHEN 10 THEN 1.1
--                WHEN 20 THEN 1.25
--                WHEN 30 THEN 1.15        
--             END;

--SELECT * 
--FROM emp;
--
--ROLLBACK;


------------------------------------------------------------------------------------------
-- CASE 함수 선언 형식
--CASE 컬럼명 또는 수식
--    WHEN 조건1 THEN 결과1
--    WHEN 조건2 THEN 결과2
--    :
--    ELSE            결과
--END 별칭


------------------------------------------------------------------------------------------
-- 예) 설문조사
--     시작일 : 26.6.1 오전 6:00
--     종료일 : 26.6.15 오후 12:00
--     지금 설문이 가능한지 여부?

SELECT SYSDATE,
       TO_CHAR(SYSDATE, 'DS TS'),
       TO_CHAR(
           TO_DATE('26/06/11 09:00', 'YY/MM/DD HH24:MI'),
           'DS TS'
       )
FROM DUAL;


--
SELECT  TO_CHAR( SYSDATE, 'DS TS' )
--       , TO_DATE( '26/06/11 09:00', 'YY/MM/DD HH24:MI' )  start_date 
       , TIMESTAMP '2026-03-20 09:00:00'
       , TO_DATE( '26/06/17 18:00', 'YY/MM/DD HH24:MI' )  end_date
       , CASE
            WHEN SYSDATE < TIMESTAMP '2026-03-20 09:00:00' THEN '설문 시작 전: 불가'               
            WHEN SYSDATE > TO_DATE( '26/06/17 18:00', 'YY/MM/DD HH24:MI' ) THEN '설문 종료 후: 불가'               
            WHEN SYSDATE BETWEEN TIMESTAMP '2026-03-20 09:00:00' AND TO_DATE( '26/06/17 18:00', 'YY/MM/DD HH24:MI' ) THEN '설문 가능'               
            ELSE '설문 불가'
         END survey_status
FROM dual;
------------------------------------------------------------------------------------------
-- 집계함수( 컬럼 )  KEEP (DENSE_RANK FIRST |LAST ORDER BY 정렬컬럼)
-- 예) MAX급여, MIN 급여 조회

SELECT MAX(sal), MIN(sal)
FROM emp;
-- 예) MAX 급여: 사원번호 , MIN 급여 : 사원명 조회



SELECT deptno
     ,MAX(empno) KEEP (DENSE_RANK FIRST ORDER BY sal DESC) MAX_PAY
     ,MIN(ename) KEEP (DENSE_RANK FIRST ORDER BY sal ASC) MIN_PAY
FROM emp
GROUP BY deptno;

------------------------------------------------------------------------------------------

SELECT TRUNC(SYSDATE,'MONTH')+ LEVEL -1
FROM dual
CONNECT BY LEVEL <= TO_CHAR( LAST_DAY(SYSDATE),'DD');

------------------------------------------------------------------------------------------
-- [문제] insa 테이블에서 총사원수, 남자사원수, 여자사원수를 조회.

--1)
SELECT 
    (SELECT COUNT(*)FROM insa)
    , (SELECT COUNT(*)FROM insa WHERE MOD(SUBSTR(SSN, -7,1),2)=1) 남자사원수
    , (SELECT COUNT(*)FROM insa WHERE MOD(SUBSTR(SSN, -7,1),2)=0) 여자사원수
FROM dual;

--2) SET 연산자( UNION)
SELECT null GENDER, COUNT(*) CNT
FROM insa
UNION
SELECT '남자',COUNT(*)
FROM insa 
WHERE MOD(SUBSTR(SSN, -7,1),2)=1
UNION
SELECT '여자',COUNT(*)
FROM insa 
WHERE MOD(SUBSTR(SSN, -7,1),2)=0;

--3) DECODE 함수

SELECT COUNT(
           DECODE(
               MOD(TO_NUMBER(SUBSTR(SSN, -7, 1)), 2),
               1, '0'
           )
       ) AS 남자사원수
FROM INSA;

--4) CASE

SELECT COUNT(
           CASE
               WHEN MOD(TO_NUMBER(SUBSTR(SSN, -7, 1)), 2) = 1
               THEN 1
           END
       ) AS 남자사원수
FROM INSA;

--5) GROUP BY
SELECT DECODE(
           MOD(TO_NUMBER(SUBSTR(SSN, -7, 1)), 2),
           1, '남자',
           '여자'
       ) AS GENDER,
       CASE MOD(TO_NUMBER(SUBSTR(SSN, -7, 1)), 2)
           WHEN 1 THEN '남자'
           ELSE '여자'
       END AS GENDER2,
       COUNT(*) CNT
FROM INSA
GROUP BY MOD(TO_NUMBER(SUBSTR(SSN, -7, 1)), 2)
--UNION
--SELECT NULL, COUNT(*)
--FROM insa;

------------------------------------------------------------------------------------------
--ROLLUP/ CUBE
SELECT MOD(SUBSTR(SSN,-7,1),2)
    ,COUNT(*)
FROM insa
GROUP BY ROLLUP( MOD(SUBSTR(SSN,-7,1),2));

-- 성별별 집계
-- 전체 집계 (추가)


------------------------------------------------------------------------------------------GROUPING 함수 사용 : 총계 행을 구분하기 위해서..
SELECT 
    --MOD(SUBSTR(SSN,-7,1),2)
    CASE
        -- GROUPING()  ROLLUP/CUBE가 생성한 집계행 : 1    0
        WHEN GROUPING( MOD(SUBSTR(SSN,-7,1),2))=1 THEN '전체'
        WHEN MOD(SUBSTR(SSN,-7,1),2)=1 THEN '남자'
        ELSE '여자'
    END gender
    ,COUNT(*)
FROM insa
GROUP BY ROLLUP( MOD(SUBSTR(SSN,-7,1),2));



------------------------------------------------------------------------------------------

SELECT deptno, job,sal
FROM emp;
--


-- 부서별로 그룹화 -> 급여합
SELECT deptno,
       job,
       SUM(sal) sum_sal
FROM emp
GROUP BY deptno, job
UNION
SELECT deptno,
       NULL,
       SUM(sal)
FROM emp
GROUP BY deptno
UNION
SELECT NULL,
       NULL,
       SUM(sal)
FROM emp
ORDER BY 1, 2;

----------

SELECT deptno, job
       , SUM(sal)
FROM emp
GROUP BY ROLLUP( deptno, job)
ORDER BY deptno , job;


--GROUP BY ROLLUP( deptno, job)
--           1) deptno +job 집계
--           2) deptno 집계
--           3) ()  집계

--GROUP BY ROLLUP( deptno), job
--           1) deptno +job 집계
--           2) job 집계


--GROUP BY GROUPING SET ((DEPTNO,JOB),(JOB))


------------------------------------------------------------------------------------------
--FIRST_VALUE / LAST_VALUE 분석 함수
--FIRST_VALUE(컬럼) OVER(ORDER BY 정렬 컬럼)
--LAST_VALUE(컬럼) OVER(ORDER BY 정렬 컬럼)

SELECT ename, sal
    --,( SELECT MAX(sal) FROM emp) max_sal
    --,FRIST_VALUE(empno) OVER(ORDER BY sal DESC)
    --,FRIST_VALUE(ename) OVER(ORDER BY sal DESC)
    ,FIRST_VALUE(sal) OVER(ORDER BY sal DESC)
FROM emp;


-- 결과가 이상하네요..이유? 현재 행까지의 마지막 값
SELECT ename, sal
    ,LAST_VALUE(sal) OVER(
        ORDER BY sal DESC
--        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
FROM emp;

-- 예) 부서별 최고 급여자 표시

SELECT DEPTNO,
       ENAME,
       SAL,
       FIRST_VALUE(ENAME)
           OVER (
               PARTITION BY DEPTNO
               ORDER BY SAL DESC
           ) AS TOP_ENAME
FROM EMP;


--RANK() OVER() X
-- 예) 로직으로 순위 매겨서 출력

SELECT deptno,empno,ename,sal
    ,(SELECT COUNT(*)+1 FROM emp WHERE e.sal < sal) sal_lank
    ,(SELECT COUNT(*)+1 FROM emp WHERE e.sal < sal AND deptno = e.deptno) sal_lank_deptno
FROM emp e
ORDER BY deptno,sal_lank_deptno;

------------------------------------------------------------------------------------------
-- [문제] insa 테이블에서 여자사원수가 5명 이상인 부서명, 사원수 조회..

SELECT BUSEO,
       COUNT(*) WOMEN
FROM INSA
WHERE SUBSTR(SSN, -7, 1) IN ('2', '4','6','8')
GROUP BY BUSEO
HAVING COUNT(*) >= 5;

-- 선생님 풀이
SELECT buseo,COUNT(*)
FROM insa
WHERE MOD( SUBSTR(SSN, -7, 1),2) =0
GROUP BY buseo
HAVING COUNT(*) >= 5;




-- [문제] emp 테이블에서 (사원 전체 평균 급여)보다 사원의 급여(pay)가 많으면 "많다", "적다" 출력.


SELECT *
FROM emp


-- 내풀이
SELECT sal,comm,
       sal + NVL(COMM, 0) PAY,
       CASE
           WHEN sal + NVL(COMM, 0) >
                (
                    SELECT AVG(sal + NVL(comm, 0))
                    FROM emp
                )
           THEN '많다'
           ELSE '적다'
       END TOTAL_PAY
FROM emp;


-- 1) UNION/UNION ALL
SELECT AVG(sal + NVL(comm,0)) avg_pag
FROM emp;
--
SELECT emp.*, '많다'
FROM emp
WHERE  sal + NVL(comm,0) > ( SELECT AVG(sal + NVL(comm,0)) avg_pag FROM emp )
UNION
SELECT emp.*, '작다'
FROM emp
WHERE  sal + NVL(comm,0) < ( SELECT AVG(sal + NVL(comm,0)) avg_pag FROM emp );


-- 2) DECODE, CASE 함수
SELECT e.ename, e.pay, e.avg_pay
      , CASE
          WHEN e.pay > e.avg_pay THEN '많다'
          WHEN e.pay < e.avg_pay THEN '작다'
          ELSE '같다'
        END pay_status
FROM (
        SELECT emp.*
            -- 월급
            , sal + NVL(comm,0) pay
            -- 모든 행마다 평균값을 컬럼으로 추가
            , (SELECT AVG(sal + NVL(comm,0) ) FROM emp )  avg_pay
        FROM emp
) e;


-- (3)
SELECT e.ename, e.pay, e.avg_pay
     --              음수(적다) 양수(많다)
      , NVL2(  NULLIF( SIGN(e.pay-avg_pay), 1 )    , '적다', '많다')  "평가"
FROM (
        SELECT emp.*
            , sal + NVL(comm,0) pay
            , (SELECT AVG(sal + NVL(comm,0) ) FROM emp )  avg_pay
        FROM emp
    ) e;
    
--
SELECT SIGN(200), SIGN(-231),SIGN(0)
FROM dual;

-- 4) 권장 (1,2,3번풀이는 성능이 안좋음)
SELECT ename, pay
    ,DECODE( SIGN( pay - avg_pay),1,'많다',-1,'작다','같다')
FROM(
    SELECT ename, sal+NVL(comm,0) pay
        ,AVG(sal+NVL(comm,0)) OVER() avg_pay
    FROM emp
);

--AVG() 복수행(집계) 함수 :    한개의 행 줄어들다.
--AVG() OVER () : 모든 행 마다 전체 평균을 표시한다.



SELECT deptno, ename, sal+NVL(comm,0) pay
        ,AVG(sal+NVL(comm,0)) OVER(PARTITION BY deptno) avg_pay
FROM emp;






-- [문제] insa 테이블에서
--   서울 출신 사원 중에 부서별 남자, 여자 사원수
--                           남자급여총합, 여자 급여총합 조회(출력)
-- [출력 형식]
--BUSEO           남자인원수   여자인원수   남자급여합   여자급여합     
----------------- ---------- ---------- ---------- ----------
--개발부                   0          2             1,790,000
--기획부                   2          1  5,060,000  1,900,000
--영업부                   4          5  6,760,000  6,400,000
--인사부                   1          0  2,300,000           
--자재부                   0          1               960,400
--총무부                   2          1  3,760,000    920,000
--홍보부                   0          1               950,000






SELECT buseo,
       COUNT(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),1,1))  남자인원수,
       COUNT(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),0,1))  여자인원수,
       SUM(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),1,BASICPAY+SUDANG))  남자급여합,
       SUM(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),0,BASICPAY+SUDANG))  여자급여합
FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo ;



--선생님 풀이
--1) 풀이 GROUP BY X

WHIT temp AS(
    SELECT * FROM insa
    WHERE city = '서울'
)
SELECT DISTINCT 
    buseo
    --(SELECT COUNT(*) FORM temp)총사원수
    ,(SELECT COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, 'O' )) FROM  temp WHERE buseo = t.buseo) 남자사원수
    ,( SELECT SUM(basicpay) FROM  temp WHERE buseo = t.buseo ) 총급여합
    , ( SELECT SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, basicpay )) FROM  temp WHERE buseo = t.buseo ) 남급여합
    , ( SELECT SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0, basicpay )) FROM  temp WHERE buseo = t.buseo ) 여급여합
FROM temp t
ORDER BY buseo;


--2) 풀이 GROUP BY O

SELECT buseo
    ,DECODE(MOD(SUBSTR(ssn, -7, 1),2),1,'남자',0,'여자' )성별
    ,COUNT(*) --인원수
    ,TO_CHAR( SUM(basicpay),'L999,999,999') 급여합
FROM insa
WHERE city = '서울'
--GROUP BY ROLLUP(buseo, MOD(SUBSTR(ssn, -7, 1),2))
GROUP BY CUBE(buseo, MOD(SUBSTR(ssn, -7, 1),2))
ORDER BY buseo, MOD(SUBSTR(ssn, -7, 1),2);


--3) 풀이 GROUP BY O

SELECT
    buseo
    ,COUNT(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),1,1))  남자인원수,
    COUNT(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),0,1))  여자인원수,
    SUM(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),1,BASICPAY+SUDANG))  남자급여합,
    SUM(DECODE(MOD(TO_NUMBER(SUBSTR(SSN,-7,1)),2),0,BASICPAY+SUDANG))  여자급여합
FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo;


-- 문제) emp 테이블에서 sal 기준으로 상위 20%에 해당되는 사원정보 조회.

SELECT FLOOR (COUNT(*) *0.2)
FROM emp
--


-- 풀이 1
SELECT *
FROM(
SELECT emp.*
    ,RANK() OVER(ORDER BY sal DESC) sal_rank
    ,DENSE_RANK() OVER(ORDER BY sal DESC) Dsal_rank
    ,ROW_NUMBER() OVER(ORDER BY sal DESC) Rsal_rank
FROM emp
)
WHERE sal_rank <=(
    SELECT FLOOR (COUNT(*) *0.2)
    FROM emp
);


-- 풀이 2
-- PERCENT_RANK() : 현재 행의 순위가 전체 데이터에서 몇 %에 해당하는 지 계산해 주는 분석함수.

SELECT *
FROM(
    SELECT ename, sal
        ,RANK() OVER(ORDER BY sal DESC) sal_rank
        ,ROUND( PERCENT_RANK() OVER(ORDER BY sal DESC),2 )*100 sal_percent
    FROM emp
)
WHERE sal_percent <= 20;
WHERE sal_percent <=-- 0.2;

--PERCENT_RANK /CUME_DIST() 차이점

------------------------------------------------------------------------------------------

