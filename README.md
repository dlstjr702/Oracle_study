# Oracle_study
쌍용교육센터 오라클수업

<h1>오라클수업</h1>


-------------------------------------------------------------------------------------------------------

<h2>2026-06-12 수업자료</h2>

1. 오라클 DB설치<br>
   1) 오라클 설치 확인<br>
 	ㄴ cmd : sqlplus -v<br>
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


<br>
<img width="814" height="600" alt="화면 캡처 2026-06-12 154734" src="https://github.com/user-attachments/assets/a6f5923a-1ff5-42a2-ad69-6b9c2fd03cf1" />
<img width="1536" height="1024" alt="KakaoTalk_20260612_162205610" src="https://github.com/user-attachments/assets/da24046c-fff0-4b0b-82dd-697a39e91281" />
<img width="503" height="387" alt="화면 캡처 2026-06-12 163120" src="https://github.com/user-attachments/assets/a22c6ff5-285d-49eb-91c8-7330bbf9bbf1" />
<img width="500" height="375" alt="화면 캡처 2026-06-12 161744" src="https://github.com/user-attachments/assets/496cbd2c-fa5b-4713-b2df-de05996d9ec2" />
<img width="724" height="557" alt="화면 캡처 2026-06-12 161233" src="https://github.com/user-attachments/assets/855974ed-5772-4576-aab7-bf4a9244c706" />
<br>






		
<br>
2. Scott 계정 생성<br>
<br>
3. Sql Developer 설치<br>
<br>


-------------------------------------------------------------------------------------------------------

