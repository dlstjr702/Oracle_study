
# Oracle_study
쌍용교육센터 오라클수업

<h1>오라클수업</h1>


-------------------------------------------------------------------------------------------------------

<h2>2026-06-12 수업자료</h2>

1. 오라클 DB설치<br>
   1) 오라클 설치 확인<br>
 	ㄴ cmd : sqlplus -v << 버전확인<br>
	ㄴ cmd : services.msc ( 검색창에 서비스검색)<br>
	    (설치된것중에 아래창 있는지 확인) <br>
		OracleServiceXE<br>
		OracleOraDB21Home1TNSListener	<br>
	ㄴ 리스너 확인<br>
	     cmd : lsnrctl status<br>
	ㄴ 데이터베이스 접속 확인: sqlplus / as sysdba<br>
	ㄴ Oracle Home 확인 : echo %ORACLE_HOME% <br>
   <br>
    2) 오라클삭제(이전에 설치된적이 있다면)<br>
	ㄴ Oracle 관련 서비를 모두 중지<br>
	     cmd : services.msc<br>
        ㄴ 제어판 > 오라클 설치된것 선택 > 프로그램 제거 또는 삭제클릭<br>
	ㄴ 폴더삭제<br>
        ㄴ 환경변수 설정된게 있다면 제거하기<br>
        ㄴ 레지스트리 정리(선택)<br>
    3) 오라클 다운로드 및 설치 (21c EX)<br>
        ㄴhttps://www.oracle.com/kr/database/technologies/xe-downloads.html?BOdNws=wHeEJ&utm_source=chatgpt.com<br>
        ㄴ OracleXE213_Win64.zip<br>
        ㄴ setup.exe 반드시 관리자 권한으로 실행<br>
        ㄴ SYS/SYSTEM/PDBADMIN 비밀번호 입력:  ss123$(대소문자구분하기)<br>
        설치 완료후 익스플로러 창에서 https://localhost:5500/em<br>
<br>
2. Scott 계정 생성<br>
    1) 관리자 계정으로 오라클 서버에 접속 : sqlplus 툴사용 (sqlplus /?)<br>
    sqlplus / as sysdba > db 접속<br>
     SQL> show con_name >> 현재 컨테이너를 확인하는 명령어<br>
     CON_NAME
------------------------------
CDB$ROOT

     CDB계정
     명령어
     CREATE USER c##hong IDENTIFIED BY 1234; (공통사용자시 c##) >> 계정생성
     sqlplus / as sysdba >> 계정으로 접속
     show user  >>현재 접속한 유저
     sqlplus sys/ss123$@localhost:1521/xe as sysdba
     disconn
     exit  >> 나가기
     SLECT > 조회
     윗방향키 누르면 카피
     show pdbs >> 컨테이너 항목조회

    SQL> SELECT username
    FROM DBA_USERS;   >>유저조회


     
     PDB 계정
     ㄴ  scott/tiger 
         (CREATE USER scott IDENTIFIED BY tiger DEFAULT TABLESPACE users;)<<scott 계정 생성명령어

   	CONNECT 로그인할수있는 권한 부여
   	RESOURCE   리소스 모든 권한 부여
   	UNLIMITED  

	ALTER USER SCOTT DEFAULT TABLESPACE USERS;
	ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;


3. Sql Developer 설치


<br>
<img width="814" height="600" alt="화면 캡처 2026-06-12 154734" src="https://github.com/user-attachments/assets/a6f5923a-1ff5-42a2-ad69-6b9c2fd03cf1" />
<img width="1536" height="1024" alt="KakaoTalk_20260612_162205610" src="https://github.com/user-attachments/assets/da24046c-fff0-4b0b-82dd-697a39e91281" />
<img width="503" height="387" alt="화면 캡처 2026-06-12 163120" src="https://github.com/user-attachments/assets/a22c6ff5-285d-49eb-91c8-7330bbf9bbf1" />
<img width="500" height="375" alt="화면 캡처 2026-06-12 161744" src="https://github.com/user-attachments/assets/496cbd2c-fa5b-4713-b2df-de05996d9ec2" />
<img width="724" height="557" alt="화면 캡처 2026-06-12 161233" src="https://github.com/user-attachments/assets/855974ed-5772-4576-aab7-bf4a9244c706" />
<img width="408" height="42" alt="화면 캡처 2026-06-12 171950" src="https://github.com/user-attachments/assets/f37e7e41-c519-4771-928e-3321b00f3e3c" />
<img width="701" height="334" alt="화면 캡처 2026-06-12 171339" src="https://github.com/user-attachments/assets/f85bd62a-0d0d-4949-b14f-88b9a9244e27" />
<img width="790" height="289" alt="화면 캡처 2026-06-12 171050" src="https://github.com/user-attachments/assets/82f01e41-d105-43ee-90ea-1065ba974a64" />
<img width="646" height="217" alt="화면 캡처 2026-06-12 170830" src="https://github.com/user-attachments/assets/6c117828-b7b9-403d-b448-9b9dc811333f" />
<img width="659" height="300" alt="화면 캡처 2026-06-12 170632" src="https://github.com/user-attachments/assets/81c3a402-c9c1-4067-87b9-f298155a1d23" />
<img width="557" height="515" alt="화면 캡처 2026-06-12 164845" src="https://github.com/user-attachments/assets/d41cf755-ef56-4a42-bfdf-271b4d3cbc2a" />
<img width="411" height="251" alt="화면 캡처 2026-06-12 164634" src="https://github.com/user-attachments/assets/225ee1eb-de9d-46bf-91fa-998dee2f7aa7" />
<img width="682" height="566" alt="화면 캡처 2026-06-12 173747" src="https://github.com/user-attachments/assets/1b17387e-2269-474e-a9ec-7e23950786ad" />
<img width="217" height="63" alt="화면 캡처 2026-06-12 173000" src="https://github.com/user-attachments/assets/69bf85e3-39c2-48db-b924-a8a6b5780db6" />
<img width="625" height="319" alt="화면 캡처 2026-06-12 172907" src="https://github.com/user-attachments/assets/8ff4dbc2-519a-4a1e-9a73-f1f36d63289e" />
<img width="506" height="330" alt="화면 캡처 2026-06-12 172250" src="https://github.com/user-attachments/assets/7124044c-76e4-42d1-9cae-dc7cfa90f9a6" />

<br>




명령어 정리
sqlplus - v   <<  버전확인 <br>
lsnrctl status  << 리스너 상태확인 <br>
lsnrctl start   << 리스너 실행 <br>
lsnrctl stop    << 리스너 종료 <br>
lsnrctl services << 등록된 서비스명 확인 <br>
sqlplus sys/비밀번호@localhost:1521/as sysdba <br>
또는 <br>
sqlplus / as sysdba << SQLPlus  sys 계정 접속 <br>
SELECT username FROM DBA_USERS;  << 현재 데이터베이스 확인 <br>
SHOW USER;   << 현재 사용자 확인
SHOW CON_NAME; << 현재 상자 이름
SHOW PDBS  << pdb확인




		

-------------------------------------------------------------------------------------------------------

<h2>2026-06-15 수업자료</h2>

1. CMD  SYS 계정으로 접속(연결)
sqlplus sys/ss123$@localhost:1521/XE as sysdba
2. 접속한 계정 확인
show user
3. 컨테이너 이름 확인
show con_name
4. PDBS 목록 확인
show pdbs;
5. PDB로 이동
ALTER SESSION SET CONTAINER = XEPDB1;
6. SCOTT 계정 확인
select username from dba_users where username='SCOTT';
7. SCOTT 권한 확인
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE='SCOTT';
8. SCOTT 롤(ROLE) 확인
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE='SCOTT';
9. XEPDB1에 HR계정 유무확인
select username from dba_users where username='HR';
10. HR/lion 계정 생성
CREATE USER HR IDENTIFIED BY lion DEFAULT TABLESPACE users;
11. HR 계정 권한 부여
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO HR;
12. CDB 전체사용가능한 C##HONG 계정확인
select username from dba_users where username='C##HONG';
13. CDB 컨테이너 이동
 ALTER SESSION SET CONTAINER= CDB$ROOT;
14. C##HONG 계정삭제
DROP USER C##HONG CASCADE;






Copyright (c) 1982, 2021, Oracle.  All rights reserved.


다음에 접속됨:
Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> ALTER SESSION SET CONTAINER = XEPDB1;

세션이 변경되었습니다.

SQL> show con_name;

CON_NAME
------------------------------
XEPDB1
SQL> @?/demo/schema/human_resources/hr_main.sql

specify password for HR as parameter 1:
1의 값을 입력하십시오: lion

specify default tablespeace for HR as parameter 2:
2의 값을 입력하십시오: users

specify temporary tablespace for HR as parameter 3:
3의 값을 입력하십시오: temp

specify log path as parameter 4:
4의 값을 입력하십시오: C:\app\Tkddyd\product\21c\dbhomeXE\demo\schema\log


<img width="1018" height="628" alt="화면 캡처 2026-06-15 111837" src="https://github.com/user-attachments/assets/f531034b-43c3-44b2-ba47-ad22aeb453dc" />





-------------------------------------------------------------------------------------------------------
<h2>2026-06-16 수업자료</h2>

select 컬럼리스트 | 5. 컬럼 지정(보고 싶은 열만 가져오기) > Projection <br>
from 테이블 | 1. 테이블 지정<br>
where 조건 | 2. 조건 지정(레코드에 대한 조건 - 개인조건) > Selection<br>
group by 기준 | 3. (레코드)그룹을 나눈다.<br>
having 조건 | 4. 조건 지정(그룹에 대한 조건 - 그룹조건 >> 집계함수에 대해 조건)<br>
order by 정렬기준 | 6. 순서(정렬)<br>

-------------------------------------------------------------------------------------------------------
<h2>2026-06-17 수업자료</h2>
- 함수관련
-------------------------------------------------------------------------------------------------------
<h2>2026-06-18 수업자료</h2>
-GROUP BY절
-------------------------------------------------------------------------------------------------------
<h2>2026-06-19 수업자료</h2>
- 피벗
-------------------------------------------------------------------------------------------------------
<h2>2026-06-20 / 2026-06-21 복습</h2>
- 오라클 설치
- 기본구문 
- 연산
- INSERT문 , 업데이트문 
- DB 설계

- 쿼리 연습

- 

--------------------------------------------------------------------------
--🟢 1번 (INNER JOIN 기본)
--
--EMP 테이블과 DEPT 테이블을 이용해서
--
--👉 사원 이름, 부서명, 급여를 출력하시오.
--
--EMP: empno, ename, deptno, sal
--DEPT: deptno, dname
--
--조건
--부서가 있는 사원만 출력

SELECT e.ename,e.deptno, e.sal
FROM emp e LEFT JOIN dept d ON d.deptno = e.deptno;




--------------------------------------------------------------------------
--🟢 2번 (JOIN + 조건)
--
--👉 부서명이 'SALES'인 사원들의 이름과 급여를 출력하시오.
--

SELECT *
FROM DEPT;

SELECT e.ename,e.sal
FROM emp e JOIN dept d ON e.deptno = d.deptno
WHERE d.dname = 'SALES';




--SELECT ename, job,sal
--FROM emp
--WHERE SUBSTR(job,1,5)= 'SALES';


--------------------------------------------------------------------------
--🟢 3번 (SELF JOIN)
--
--EMP 테이블에서
--
--👉 사원 이름과 해당 사원의 매니저 이름을 출력하시오.
--
--EMP.empno = 사원
--EMP.mgr = 매니저 empno

SELECT e.ename,e.mgr
FROM emp e JOIN emp d ON e.deptno = d.deptno;



--------------------------------------------------------------------------
--🟢 4번 (LEFT JOIN)
--
--👉 모든 부서와 그 부서에 속한 사원 수를 출력하시오.
--
--(사원이 없는 부서도 포함)
--


SELECT d.deptno,COUNT(e.empno)
FROM  dept d LEFT JOIN emp e  ON  d.deptno= e.deptno
GROUP BY d.deptno;


--------------------------------------------------------------------------
--🟢 5번 (JOIN + WHERE 조건)
--
--👉 급여가 3000 이상인 사원의 이름, 부서명 출력
--
--🔥 GROUP BY 핵심 문제 세트

SELECT e.ename,d.dname
FROM  dept d LEFT JOIN emp e  ON  d.deptno= e.deptno
WHERE e.sal>=3000;

--------------------------------------------------------------------------
--🟡 6번 (기본 GROUP BY)
--
--👉 부서별 사원 수를 출력하시오.
--

SELECT d.deptno, COUNT(*)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno

--------------------------------------------------------------------------
--🟡 7번 (GROUP BY + AVG)
--
--👉 부서별 평균 급여를 출력하시오.
--
SELECT d.deptno, AVG(e.sal)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno


--------------------------------------------------------------------------
--🟡 8번 (GROUP BY + HAVING)
--
--👉 사원 수가 3명 이상인 부서만 출력하시오.
--
SELECT d.deptno, COUNT(*)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
HAVING COUNT(*) >=3


--------------------------------------------------------------------------
--🟡 9번 (GROUP BY + SUM)
--
--👉 부서별 급여 총합을 출력하시오.
--

SELECT d.deptno, SUM(e.sal)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
--------------------------------------------------------------------------
--🟡 10번 (GROUP BY + 정렬)
--
--👉 부서별 평균 급여를 구하고, 평균 급여 높은 순으로 정렬하시오.
--
SELECT d.deptno, AVG(e.sal)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
ORDER BY AVG(e.sal) DESC

--------------------------------------------------------------------------
--🟡 11번 (GROUP BY + 2컬럼)
--
--👉 부서별 + 직무별 사원 수를 출력하시오.
--

SELECT d.deptno, job,COUNT(*)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno,e.job


SELECT *
FROM emp

--------------------------------------------------------------------------
--🟡 12번 (HAVING 핵심)
--
--👉 평균 급여가 2000 이상인 부서만 출력하시오.
--
--🔥 JOIN + GROUP BY 합체 문제 (시험 핵심)

SELECT d.deptno,AVG(e.sal)
FROM emp e JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
HAVING AVG(e.sal)>=2000


--------------------------------------------------------------------------
--🔴 13번 (가장 중요)
--
--👉 부서명별 사원 수를 출력하시오.
--
--DEPT + EMP JOIN
--사원 없는 부서도 포함


SELECT d.dname, COUNT(e.empno)
FROM dept d JOIN emp e ON d.deptno = e.deptno
GROUP BY d.dname;

--------------------------------------------------------------------------
c

--------------------------------------------------------------------------
--🔴 15번 (실전형)
--
--👉 부서명 + 직무별 사원 수를 출력하시오.

SELECT d.dname,e.job ,COUNT(*)
FROM dept d JOIN emp e ON d.deptno = e.deptno
GROUP BY d.dname,e.job;



-------------------------------------------------------------------------------------------------------
<h2>2026-06-22 수업자료</h2>

-- 테이블 생성, 수정, 삭제
--     DDL문 :  CREATE, ALTER, DROP
--          CREATE TABLE, ALTER TABLE, DROP TABEL
--          CREATE USER, ALTER USER, DROP USER
--          CREATE DB객체명 , ALTER DB객체명, DROP DB객체명

-- 고유한키 (PRIMARY KEY)
-- 회원을 구분할수 있는 고유한 키 : 아이디
-- 예) 아이디(id)=문자(가변)    VARCHAR2(10)
-- 이름(nmae)=문자(가변)        VARCHAR2(20)
-- 나이(age)=숫자(정수)         NUMBER(3) 
-- 연락처(tel)=문자(가변/고정)   VARCHAR2(20)
-- 생일(birth)=날짜             DATE
-- 비고(etc)= 문자(가변)        LONG


-------------------------------------------------------------------------------------------------------
<h2>2026-06-23 수업자료</h2>
-- 병합(MERGE)<br>
-- 제약조건<br>
--데이터베이스 모델링<br>
https://terms.naver.com/entry.naver?docId=3431222&ref=y&cid=58430&categoryId=58430<br>
<br>
- 정규화 (제1정규화/2정규화/3정규화/4정규화)
-------------------------------------------------------------------------------------------------------
<h2>2026-06-24 수업자료</h2>
-- 조인정리<br>
-- 뷰<br>
-- PL/SQL<br>
- exERD
<img width="596" height="637" alt="화면 캡처 2026-06-24 103634" src="https://github.com/user-attachments/assets/fb13d932-cc4d-468e-acf7-f2309560507a" />






-------------------------------------------------------------------------------------------------------
<h2>2026-06-25 ~ 2026-06-26 수업자료</h2>
- 데이터베이스 모델링 프로젝트<br>
- 요구분석<br>






