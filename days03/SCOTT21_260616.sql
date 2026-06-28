--SCOTT
-- [문제] emp 테이블에서 월급(pay=sal+comm)이
--        2000 이상  4000 이하를 받는 사원 정보 조회
--        ( 부서번호, 사원명, 잡, 월급 )

SELECT *
FROM emp;


SELECT empno,ename,job,sal+NVL(comm,0) pay
FROM emp
WHERE sal+NVL(comm,0)BETWEEN 2000 AND 4000
--WHERE sal+NVL(comm,0)>=2000 AND sal+NVL(comm,0)<=4000
ORDER BY pay DESC;
--WHERE PAY>=2000 AND PAY<=4000;
--ORA-00904: "PAY": 부적합한 식별자


-- 위의 쿼리를 with 절을 사용해서 처리~
WITH empPay AS (
--sub query
    SELECT empno,ename,job,sal+NVL(comm,0) pay
    FROM emp
)
SELECT empPay.*-- main query
FROM empPay
WHERE empPay.pay BETWEEN 2000 AND 4000
ORDER BY empPAY.pay ASC;


-------------------------------------------------------------------
WITH empPay AS (
--sub query
    SELECT empno,ename,job,sal+NVL(comm,0) pay
    FROM emp
)
SELECT e.*-- main query
FROM empPay e  -- e는별칭
WHERE e.pay BETWEEN 2000 AND 4000
ORDER BY e.pay ASC;

-------------------------------------------------------------------

SELECT e.*-- main query
FROM ( -- FROM (sub query) 별칭 : 인라인뷰 (inline view)
    SELECT empno,ename,job,sal+NVL(comm,0) pay
    FROM emp
) e  -- e는별칭
WHERE e.pay BETWEEN 2000 AND 4000
ORDER BY e.pay ASC;

-------------------------------------------------------------------

SELECT *-- main query
FROM ( -- FROM (sub query) 별칭 : 인라인뷰 (inline view)
    SELECT empno,ename,job,sal+NVL(comm,0) pay
    FROM emp
) e  -- e는별칭/ alias는 서브쿼리가 여러개 일때 사용
WHERE pay BETWEEN 2000 AND 4000
ORDER BY pay ASC;

-------------------------------------------------------------------

SELECT ename,INITCAP(ename)
--LOWER(ename)
--,UPPER(ename)
--COUNT(*)
FROM emp;
--ORA-00937: 단일 그룹의 그룹 함수가 아닙니다
--https://docs.oracle.com/error-help/db/ora-00937/00937. 00000 -  "not a single-group group function"


-------------------------------------------------------------------
--insa 테이블에서 남자는 'X', 여자는 'O' 로 성별(gender) 출력하는 쿼리 작성   
--    NAME                 SSN            GENDER
--    -------------------- -------------- ------
--    홍길동               771212-1022432    X
--    이순신               801007-1544236    X
--    이순애               770922-2312547    O
--    김정훈               790304-1788896    X
--    한석봉               811112-1566789    X 
--    :

SELECT *
FROM insa;


SELECT NAME,
       SUBSTR(SSN, 1, 2) YY,
       SUBSTR(SSN, 3, 2) MM,
       SUBSTR(SSN, 5, 2) DD,
       SUBSTR(SSN, -7, 1) GENDER
FROM insa;


-------------------------------------------------------------------
-- 산술연산자 확인
-- 나머지 연산자 없더라
SELECT DISTINCT 3+5
FROM DEPT;


SELECT 3+5 , 3-5 , 3*5 , 3/5
FROM DUAL;


SELECT MOD(5,4)
FROM DUAL;


-------------------------------------------------------------------

SELECT NAME,SSN, --- 날짜 정보얻어오기
    SUBSTR(SSN,1,6)RRN6, 
    TO_DATE(SUBSTR(SSN,1,6))BIRTDAY,
    TO_CHAR(TO_DATE(SUBSTR(SSN,1,6)),'YYYY') YEAR,
    TO_CHAR(TO_DATE(SUBSTR(SSN,1,6)),'MM') MONTH,
    TO_CHAR(TO_DATE(SUBSTR(SSN,1,6)),'DD') DAY
    -- 날짜 타입으로 부터 날짜 정보를 얻어올때 EXTRACT()함수도 사용할 수 있다.
    ,EXTRACT(YEAR FROM TO_DATE (SUBSTR(SSN,1,6))) B_YEAR
    ,EXTRACT(MONTH FROM TO_DATE (SUBSTR(SSN,1,6))) B_MONTH
    ,EXTRACT(DAY FROM TO_DATE (SUBSTR(SSN,1,6))) B_DAY
FROM insa;


-------------------------------------------------------------------

SELECT NAME,SSN,
    --SUBSTR(SSN,-7,1) GENDER,
    MOD (SUBSTR(SSN,-7,1),2) GENDER,
    --REPLACE(REPLACE( MOD (SUBSTR(SSN,-7,1),2),1,'X'),0,'O')GENGER
    NULLIF(MOD (SUBSTR(SSN,-7,1),2),0),
    NVL2(NULLIF(MOD (SUBSTR(SSN,-7,1),2),0),'X','O')GENDER
FROM insa;


-------------------------------------------------------------------
--REPLACE() 함수

SELECT REPLACE('AAABBB','A','B') BBBBB
        ,REPLACE('AAABBB','A') BBBBB
FROM DUAL;

-------------------------------------------------------------------
-- NULLIF()함수설명
SELECT NULLIF(1,1),
        NULLIF(1,2)
FROM DUAL;
-------------------------------------------------------------------
--INSA 테이블에서 70년대(70~79년생) 12월생 모든 사원정보를 조회
--    NAME                 SSN           
--    -------------------- --------------
--    문길수               721217-1951357
--    김인수               731211-1214576
--    홍길동               771212-1022432   

SELECT NAME , SSN
FROM INSA 
WHERE SUBSTR(SSN,1,1)='7' AND SUBSTR(SSN,3,2)='12' 
ORDER BY SSN ASC;

--LIKE 연산자 설명
SELECT NAME, SSN
FROM INSA
WHERE SSN LIKE '7_12%';

--
SELECT NAME, SSN
FROM INSA
WHERE REGEXP_LIKE(SSN,'^7[0-9]12')
ORDER BY SSN ASC;

--
SELECT NAME, SSN
FROM INSA
--WHERE REGEXP_LIKE(SSN,'^7\d12')
WHERE REGEXP_LIKE(SSN,'^7.12')
ORDER BY SSN ASC;

-------------------------------------------------------------------
SELECT deptno,sal +NVL(comm,0)PAY,ename,HIREDATE
FROM EMP
ORDER BY 1,2 DESC;
--ORDER BY deptno ASC,PAY DESC;

-------------------------------------------------------------------
--[문제]INSA테이블에서 70년대 남자만 조회(이름,주민번호)


-- 1) LIEK 연산자

SELECT * 
FROM INSA;

SELECT NAME,SSN
FROM INSA
WHERE SSN LIKE '7_____-1%'
   OR SSN LIKE '7_____-3%'
   OR SSN LIKE '7_____-5%'
   OR SSN LIKE '7_____-7%'
   OR SSN LIKE '7_____-9%';



-- 2) REGEXP_LIK연산자
SELECT NAME,SSN
FROM INSA
WHERE REGEXP_LIKE(SSN,'^7\d{5}-{13579}');


-------------------------------------------------------------------
--[문제]EMP 테이블의 ENAME에 LA/la/lA/La라는 문자열이 포함된 사원의 정보를 조회
SELECT *
FROM EMP;

--
SELECT ENAME
FROM EMP
WHERE ENAME LIKE '%LA%' OR
      ENAME LIKE '%la%' OR
      ENAME LIKE '%La%' OR
      ENAME LIKE '%lA%';
      
--      
SELECT ENAME
FROM EMP
WHERE LOWER (ENAME)LIKE '%la%';
      
--      
SELECT ENAME
FROM EMP
WHERE REGEXP_LIKE(ENAME,'la','i');



-------------------------------------------------------------------
--LIKE 연산자의 ESCAPE옵션

-------------------------------------------------------------------
-- 힌트 ) REPLACE(),REGEXP_REPLACE()
SELECT ename, REPLACE(ENAME,'LE','**')
FROM emp
WHERE ENAME LIKE '%L%';


SELECT ename, REPLACE(ENAME,'L','*') a
FROM emp
WHERE ENAME LIKE '%L%';


SELECT ename, REGEXP_REPLACE(ENAME,'LE','**',1,0,'i')
FROM emp;





SELECT ename, deptno
FROM EMP;

-------------------------------------------------------------------


SELECT ename,job,sal ,deptno
from emp p
where deptno IN (
    SELECT deptno 
    FROM dept
    WHERE deptno=p.deptno
);
-------------------------------------------------------------------
SELECT ename,job,sal ,deptno
FROM emp p
WHERE EXISTS (-- 존재한다면/ NOT이 붙으면 존재하지 않는다면
    SELECT 'x' 
    FROM dept 
    WHERE deptno=30
);


-------------------------------------------------------------------
--김씨
SELECT num, name
FROM insa
WHERE name LIKE '_김_';
--WHERE name LIKE '%김%';
--WHERE name LIKE '%김';
--WHERE name LIKE '김_%';
--WHERE name LIKE '김%'


-------------------------------------------------------------------
--조인(JOIN)
사원테이블
사번 사원명 입사일자 ... 부서명 부서번호 부서장
1001 홍길동             영업부  101    김기수
1001 홍길동             영업부  101    김기수
1001 홍길동             영업부  101    김기수
1001 홍길동             영업부  101    김기수
1001 홍길동             영업부  101    김기수


부서테이블
부서번호  부서명 부서번호 부서장
 10        영업부  101    류호훈
 20        영업부  101    정창기
 30        영업부  101    홍길동
 40        영업부  101    서영학
 
 --사원정보 사번 사원명 부서명
-- EMP : EMPNO,ENAME
-- DEPT: DNAME
 
 
SELECT emp.empno, emp.ename, dept.dname 
FROM dept,emp  --오라클 전통 조인(old style Join) oracle 8i ~
WHERE dept.deptno = emp.deptno;


SELECT e.empno, e.ename, d.dname 
FROM dept d, emp e  --오라클 전통 조인(old style Join) oracle 8i ~
WHERE d.deptno = e.deptno;

SELECT *
FROM DEPT

--ANSI JOIN(표준조인)
SELECT empno,ename, ename, d.deptno
FROM dept d JOIN emp e ON d.deptno = e.deptno;

-------------------------------------------------------------------
-- 오늘날짜/시간 조회하는 쿼리...
SELECT SYSDATE,CURRENT_TIMESTAMP
FROM dual;

--SYSDATE함수 + TO_CHAR 함수: 내가 원하는 날짜/시간 정보 출력....
-- TO_CHAR(): 숫자, 문자열 -> 문자 형변환하는 함수.
SELECT 100, TO_CHAR(100)
FROM dual;


SELECT SYSDATE
    , TO_CHAR(SYSDATE,'YYYY') YEAR
    , TO_CHAR(SYSDATE,'MM') MONTH
    , TO_CHAR(SYSDATE,'MONTH') MONTH
    , TO_CHAR(SYSDATE,'MON') MONTH
    , TO_CHAR(SYSDATE,'DD') "DATE"
    --시간 분초 요일
    , TO_CHAR(systimestamp,'HH') TIME
    , TO_CHAR(SYSDATE,'MI') "M"
    , TO_CHAR(SYSDATE,'SS') "S"
    , TO_CHAR(SYSDATE,'DY') "DY"
    , TO_CHAR(SYSDATE,'AM') "AM/PM"
    , TO_CHAR(SYSDATE,'DL') "DL"
    , TO_CHAR(SYSDATE,'DS') "DS"
    
    , TO_CHAR(SYSDATE,'W') "W"    --이번달 3주차
    , TO_CHAR(SYSDATE,'WW') "WW" -- 연주 24주
    
    , TO_CHAR(SYSDATE,'IW') "IW" -- 연주 24주
    -- WW, IW 차이점 ~
    
FROM dual;


-------------------------------------------------------------------
-- DML : UPDATE문 ~
--       INSERT 문
SELECT *
FROM dept;


INSERT INTO  테이블명 (컬럼명) VALUES (컬럼값...);
INSERT INTO dept (deptno,dname,loc)VALUES (50,'QC','SEOUL');
INSERT INTO dept VALUES (60,'Engineering','POHANG');
INSERT INTO dept VALUES (70,null,null);
INSERT INTO dept (deptno) VALUES (70);
--SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
COMMIT;



SELECT *
FROM dept
ORDER BY deptno ASC;


--70번 부서의 부서명(PRODUCTION), 지역명(SEOUL) 수정(UPDATE)
UPDATE dept
SET dname ='Production',loc ='SEOUL'
WHERE deptno = 70;
-- 새로 추가된 부서삭제: DML - DELETE문

--DELETE 테이블명
--WHERE 삭제할 조건식;

DELETE dept
--WHERE deptno >=50;
WHERE deptno IN (50,60,70);
--WHERE deptno = 50 OR deptno = 60 OR deptno = 70;

-- 문제 ) 부서명   pro 문자열이 포함된 부서를 검색 후 삭제....
--- 검색 쿼리 1개

SELECT *
FROM dept
--WHERE REGEXP_LIKE (dname,'pro','i');
WHERE UPPER(dname) LIKE '%PRO%';

--- 삭제 쿼리 1개
DELETE dept
WHERE deptno = 90;


COMMIT;

ROLLBACK;


-------------------------------------------------------------------
-- [문제] 50번 새로운 부서를 추가할 예정
-- 부서명 30번 부서명의 +2 "SALES2"
-- 부서명 40번 부서의 지역명과 동일 "BOSTON"




  


INSERT INTO dept (deptno,dname,loc) VALUES (50,'SALES2','BOSTON');


-- [문제] 가장 큰 부서번호+ 10 새로운 부서를 추가할 예정
--      부서명   30번 부서의 부서명, 지역명과 동일하게..



SELECT COUNT(deptno),MAX(deptno),MIN(deptno)
FROM dept;

--

SELECT MAX(deptno)+10
FROM dept;

INSERT INTO dept (deptno,dname,loc) VALUES ( 
    (SELECT MAX(deptno)+10 FROM dept ) ,
    (SELECT dname FROM dept WHERE deptno=30),
    (SELECT loc FROM dept WHERE deptno=30)
);


-------------------------------------------------------------------
UPDATE dept 
SET (dname,loc) = (SELECT dname, loc FROM dept WHERE deptno = 40)
WHERE deptno =50;
COMMIT;

SELECT *
FROM dept;

DELETE FROM dept
WHERE deptno = 50;

-------------------------------------------------------------------
-- [문제] 50번 부서를 수정 추가할 예정
UPDATE dept
SET dname = dname ||'2' ,loc = (SELECT loc FROM dept WHERE deptno=40)
WHERE deptno= 50;

-------------------------------------------------------------------
INSERT INTO dept (deptno,dname,loc) VALUES ( 
    (SELECT MAX(deptno)+10 FROM dept ) ,
    (SELECT dname FROM dept WHERE deptno=30),
    (SELECT loc FROM dept WHERE deptno=30)
);

--PL/SQL 사용해서 처리 ^
--DECLARE
    -- 변수 선언
--BEGIN
    -- 실행명령문: INSERT,UPDATE,DELETE,SELECT 여러개....
--EXCEPTION
    -- 예외처리 블럭
--END;


DECLARE
  -- 변수 선언
  vdeptno NUMBER(2);
  vdname  VARCHAR2(14);
  vloc    VARCHAR2(10);
BEGIN
  --  실행명령문: INSERT, UPDATE, DELETE, SELECT 여러개...
  SELECT MAX( deptno ) + 10 INTO vdeptno FROM dept;
  SELECT dname || '2' INTO vdname  FROM dept WHERE deptno= 30;
  SELECT loc INTO vloc FROM dept WHERE deptno= 40;  
  INSERT INTO dept VALUES (  vdeptno, vdname, vloc );
  COMMIT;
END;


DELETE FROM dept
WHERE deptno = 50;
COMMIT;

-------------------------------------------------------------------
-- [문제] emp 테이블의 모든 사원의 sal기본급을 20%인상하는 update문을 작성하세요...

SELECT *
FROM emp;


UPDATE emp
SET sal = sal * 1.2;

-------------------------------------------------------------------
-- TBL_TEST
SELECT *
FROM tbl_test;

-- 문제) 이메일의 .CO.KR 0> .COM 수정(UPDATE)
-- (힌트) REPLACE(), REGEXP_REPLACE()


SELECT email
FROM tbl_test;


UPDATE tbl_test
SET email = REPLACE(email,'.co.kr','.com');




-------------------------------------------------------------------
-------------------------------------------------------------------









