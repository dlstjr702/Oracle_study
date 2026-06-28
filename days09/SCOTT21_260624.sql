-- SCOTT
-------------------------------------------------------------------------------------------------------------










-------------------------------------------------------------------------------------------------------------

INSERT INTO survey_emp (emp_no, grade) VALUES (1, '관리자');

INSERT INTO survey_user VALUES (1001, '김민준');
INSERT INTO survey_user VALUES (1002, '이서연');
INSERT INTO survey_user VALUES (1003, '박지훈');
INSERT INTO survey_user VALUES (1004, '최수아');
INSERT INTO survey_user VALUES (1005, '정도윤');
INSERT INTO survey_user VALUES (1006, '강하은');
INSERT INTO survey_user VALUES (1007, '조현우');
INSERT INTO survey_user VALUES (1008, '윤지아');
INSERT INTO survey_user VALUES (1009, '장민서');
INSERT INTO survey_user VALUES (1010, '임세진');
INSERT INTO survey_user VALUES (1011, '오준혁');
INSERT INTO survey_user VALUES (1012, '신예린');
INSERT INTO survey_user VALUES (1013, '한승현');
INSERT INTO survey_user VALUES (1014, '류지민');
INSERT INTO survey_user VALUES (1015, '남다은');
INSERT INTO survey_user VALUES (1016, '송태양');
INSERT INTO survey_user VALUES (1017, '전하린');
INSERT INTO survey_user VALUES (1018, '구민재');
INSERT INTO survey_user VALUES (1019, '심유진');
INSERT INTO survey_user VALUES (1020, '배성준');
INSERT INTO survey_user VALUES (1021, '노은서');
INSERT INTO survey_user VALUES (1022, '문준서');
INSERT INTO survey_user VALUES (1023, '안지은');
INSERT INTO survey_user VALUES (1024, '황도현');
INSERT INTO survey_user VALUES (1025, '임채원');
INSERT INTO survey_user VALUES (1026, '권소율');
INSERT INTO survey_user VALUES (1027, '차민호');
INSERT INTO survey_user VALUES (1028, '서예나');
INSERT INTO survey_user VALUES (1029, '고준영');
INSERT INTO survey_user VALUES (1030, '방수빈');
INSERT INTO survey_user VALUES (1031, '석지호');
INSERT INTO survey_user VALUES (1032, '위하준');
INSERT INTO survey_user VALUES (1033, '표나연');
INSERT INTO survey_user VALUES (1034, '봉민찬');
INSERT INTO survey_user VALUES (1035, '탁소현');
INSERT INTO survey_user VALUES (1036, '엄재원');
INSERT INTO survey_user VALUES (1037, '도하영');
INSERT INTO survey_user VALUES (1038, '지성민');
INSERT INTO survey_user VALUES (1039, '마유나');
INSERT INTO survey_user VALUES (1040, '변준우');
INSERT INTO survey_user VALUES (1041, '나가은');
INSERT INTO survey_user VALUES (1042, '성현진');
INSERT INTO survey_user VALUES (1043, '여민아');
INSERT INTO survey_user VALUES (1044, '추성훈');
INSERT INTO survey_user VALUES (1045, '편소윤');
INSERT INTO survey_user VALUES (1046, '어준혁');
INSERT INTO survey_user VALUES (1047, '피지수');
INSERT INTO survey_user VALUES (1048, '모하은');
INSERT INTO survey_user VALUES (1049, '음재현');
INSERT INTO survey_user VALUES (1050, '두나은');




-------------------------------------------------------------------------------------------------------------

-- 설문 등록 (1건)
INSERT INTO survey (survey_no, question, start_date, end_date, emp_no) VALUES (1, '좋아하는 색은 무슨색인가요?', SYSDATE, SYSDATE + 7, 1);

SELECT *
FROM survey_sub;

-- 설문항목 등록 (5건)
INSERT INTO survey_sub VALUES (1, 1, '빨간색');
INSERT INTO survey_sub VALUES (2, 1, '파란색');
INSERT INTO survey_sub VALUES (3, 1, '노란색');
INSERT INTO survey_sub VALUES (4, 1, '흰색');
INSERT INTO survey_sub VALUES (5, 1, '검은색');



-------------------------------------------------------------------------------------------------------------
-- 설문 등록 (1건)
INSERT INTO survey (survey_no, question, start_date, end_date, emp_no) VALUES (2, '가장 좋아하는 여자 연예인은?', SYSDATE, SYSDATE + 3, 1);

-- 설문항목 등록 (6건)
INSERT INTO survey_sub VALUES (1, 2, '배슬기');
INSERT INTO survey_sub VALUES (2, 2, '김옥빈');
INSERT INTO survey_sub VALUES (3, 2, '아이비 꺄~~ 사.랑.해.요 아.이.비.');
INSERT INTO survey_sub VALUES (4, 2, '한효주');
INSERT INTO survey_sub VALUES (5, 2, '김선아');
INSERT INTO survey_sub VALUES (6, 2, '아이유');



-------------------------------------------------------------------------------------------------------------
INSERT INTO survey_answer VALUES (1001, 1, 1); -- 빨간색
INSERT INTO survey_answer VALUES (1002, 3, 1); -- 노란색
INSERT INTO survey_answer VALUES (1003, 2, 1); -- 파란색
INSERT INTO survey_answer VALUES (1004, 5, 1); -- 검은색
INSERT INTO survey_answer VALUES (1005, 1, 1); -- 빨간색
INSERT INTO survey_answer VALUES (1006, 4, 1); -- 흰색
INSERT INTO survey_answer VALUES (1007, 2, 1); -- 파란색
INSERT INTO survey_answer VALUES (1008, 3, 1); -- 노란색
INSERT INTO survey_answer VALUES (1009, 5, 1); -- 검은색
INSERT INTO survey_answer VALUES (1010, 1, 1); -- 빨간색






-- 예시 1: 가장 기본적인 설문 테이블 조회
SELECT * FROM survey;


SELECT *
FROM survey;





----------------------------
-- 최종출력

SELECT s.survey_sub_content AS "항목",
       COUNT(a.user_no) AS "득표수",
       TO_CHAR(
           ROUND(
               COUNT(a.user_no)
               / DECODE(SUM(COUNT(a.user_no)) OVER(),0,1,SUM(COUNT(a.user_no)) OVER())
               * 100, 2
           ),
           'FM990.00'
       ) || '%' AS "비율",
       NVL(RPAD(
           ' ',
           ROUND(
               COUNT(a.user_no)
               / DECODE(SUM(COUNT(a.user_no)) OVER(),0,1,SUM(COUNT(a.user_no)) OVER())
               * 10
           ),
           '■'
       ),' ') AS "차트"
FROM survey_sub s
LEFT JOIN survey_answer a ON s.survey_sub_no = a.survey_sub_no AND s.survey_no = a.survey_no
WHERE s.survey_no = 2
GROUP BY s.survey_sub_no, s.survey_sub_content
ORDER BY s.survey_sub_no;

--
--SELECT *
--FROM survey_answer
--WHERE survey_no = 2;
--
--
--INSERT INTO survey_answer VALUES (1001, 6, 2); -- 아이유
--INSERT INTO survey_answer VALUES (1002, 6, 2); -- 아이유
--INSERT INTO survey_answer VALUES (1003, 4, 2); -- 한효주
--INSERT INTO survey_answer VALUES (1004, 1, 2); -- 배슬기
--INSERT INTO survey_answer VALUES (1005, 6, 2); -- 아이유
--COMMIT;

SELECT survey_sub_no,
       COUNT(*) answer_count,
       ROUND(COUNT(*) * 100
           / SUM(COUNT(*)) OVER ()
           , 2
       ) || '%' percentage
FROM survey_answer
GROUP BY survey_sub_no
ORDER BY survey_sub_no ASC;





SELECT *
FROM survey_sub;

