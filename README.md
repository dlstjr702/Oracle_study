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
sqlplus sys/비밀번호@localhost:1521/orcl as sysdba <br>
또는 <br>
sqlplus / as sysdba << SQLPlus  sys 계정 접속 <br>
SELECT username FROM DBA_USERS;  << 현재 데이터베이스 확인 <br>
SHOW USER;   << 현재 사용자 확





		

-------------------------------------------------------------------------------------------------------

<h2>2026-06-15 수업자료</h2>





-------------------------------------------------------------------------------------------------------


