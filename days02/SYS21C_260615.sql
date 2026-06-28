SHOW USER;
SHOW CON_NAME;

--ALTER session set container = SYS;

select *
from dba_users;


----------용어정리
--1.데이터 : 컴퓨터에 저장된 값
--2. 정보: 
--3. 데이터 베이스(Database,DB) : 관련있는 데이터르 ㄹ체계적으로 저장한 공간
--4. DBMS: 데이터베이스를 관리하는 소프트웨어
-- 예) 엑셀프로그램
--5. 테이블 : 데이터를 저장하는 기본단위
--6. 스키마:사용자가 소유한 객체들의 집합
-- SCOTT
--│
--├─ TABLE
--│   ├─ EMP
--│   ├─ DEPT
--│   └─ BONUS
--│
--├─ VIEW
--│   └─ V_EMP
--│
--├─ INDEX
--│   └─ IDX_EMP_ENAME
--│
--├─ SEQUENCE
--│   └─ EMP_SEQ
--│
--├─ PROCEDURE
--│   └─ TEST_PROC
--│
--├─ FUNCTION
--│   └─ ADD_NUM
--│
--└─ TRIGGER
--    └─ TRG_EMP 
--    
--    등등등
--7. scott계정 소유의 db객체 :테이블 생성...
--BONUS,DEPT,EMP,SALGRADE




SELECT * 
FROM dba_tables; -- 데이터베이스에 존재하는 모든테이블정보


--XEPDB1
show con_name;
ALTER session set container = XEPDB1;
show con_name;


--SCOTT 계정확인
SELECT *
FROM dba_users
WHERE username  IN ('SCOTT','HR');
--WHERE username = 'SCOTT' OR username= 'HR';

