--SCOTT
------------------------------------------------------------------------------------------
-- 선생님 코드
SELECT
    *
FROM
    (
        SELECT
            s.survey_no  AS 번호,
            s.question   AS 질문,
            e.grade      AS 작성자,
            s.start_date AS 시작일,
            s.end_date   AS 종료일,
            (
                SELECT
                    COUNT(*) AS item_cnt
                FROM
                    survey_sub i
                WHERE
                    s.survey_no = i.survey_no
            )            AS 항목수,
            (
                SELECT
                    COUNT(DISTINCT user_no) AS participant_cnt
                FROM
                    survey_answer a
                WHERE
                    s.survey_no = a.survey_no
            )            AS 참여자수,
            CASE
                WHEN sysdate < s.start_date                      THEN
                    '예정'
                WHEN sysdate BETWEEN s.start_date AND s.end_date THEN
                    '진행중'
                ELSE
                    '종료'
            END          AS 상태
        FROM
            survey     s
            LEFT JOIN survey_emp e ON s.emp_no = e.emp_no
        ORDER BY
            s.survey_no DESC
    )
-- 페이지 추가
OFFSET ( :currentpage - 1 ) * :pagesize ROWS FETCH NEXT :pagesize ROWS ONLY;





-------------------------------------------------------------------------------
-- ■ DB 모델링
--   1) 비디오샵 DB 모델링
--   2) 팀 세미 프로젝트 ( 실습 )
SELECT
    *
FROM
    user_tables
WHERE
    table_name LIKE 'T\_%' ESCAPE '\';
--------------------------------------------------------------------------------
-- ■ 1. 테이블 확인
SELECT
    *
FROM
    t_member;

SELECT
    *
FROM
    t_poll;

SELECT
    *
FROM
    t_pollsub;

SELECT
    *
FROM
    t_voter;
-- ■ 2. T_MEMBER 에 관리자 및 일반 회원 등록.
INSERT INTO t_member (
    memberseq,
    memberid,
    memberpasswd,
    membername,
    memberphone,
    memberaddress
) VALUES ( 1,
           'admin',
           '1234',
           '관리자',
           '010-1111-1111',
           '서울 강남구' );

INSERT INTO t_member (
    memberseq,
    memberid,
    memberpasswd,
    membername,
    memberphone,
    memberaddress
) VALUES ( 2,
           'hong',
           '1234',
           '홍길동',
           '010-1111-1112',
           '서울 동작구' );

INSERT INTO t_member (
    memberseq,
    memberid,
    memberpasswd,
    membername,
    memberphone,
    memberaddress
) VALUES ( 3,
           'kim',
           '1234',
           '김준석',
           '010-1111-1341',
           '경기 남양주시' );

COMMIT;
-- ■ 3. INSERT 확인
SELECT
    *
FROM
    t_member;
-- ■ 4. 설문 등록
--  1)
INSERT INTO t_poll (
    pollseq,
    question,
    sdate,
    edate,
    itemcount,
    polltotal,
    regdate,
    memberseq
) VALUES ( 1,
           '좋아하는 여배우?',
           TO_DATE('2026-06-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           TO_DATE('2026-06-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           5,
           0,
           TO_DATE('2026-06-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           1 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 1,
           '배슬기',
           0,
           1 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 2,
           '김옥빈',
           0,
           1 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 3,
           '아이유',
           0,
           1 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 4,
           '김선아',
           0,
           1 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 5,
           '홍길동',
           0,
           1 );

COMMIT;

--  2)
INSERT INTO t_poll (
    pollseq,
    question,
    sdate,
    edate,
    itemcount,
    polltotal,
    regdate,
    memberseq
) VALUES ( 2,
           '좋아하는 과목?',
           TO_DATE('2026-06-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           TO_DATE('2026-06-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           4,
           0,
           TO_DATE('2024-09-20 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),
           1 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 6,
           '자바',
           0,
           2 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 7,
           '오라클',
           0,
           2 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 8,
           'HTML5',
           0,
           2 );

INSERT INTO t_pollsub (
    pollsubseq,
    answer,
    acount,
    pollseq
) VALUES ( 9,
           'JSP',
           0,
           2 );

COMMIT;

--3) 
   INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'좋아하는 색?'
                          , TO_DATE( '2026-11-11 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2026-11-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2026-06-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );

INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  )  VALUES (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq , Answer , ACount , PollSeq  ) VALUES  (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) VALUES  (12 ,'파랑', 0, 3 ); 
   
   COMMIT;                    
--  
SELECT * FROM t_poll


-- ■ 5. 설문 목록 Query
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일
         , itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '진행 중';  
--WHERE 상태 != '시작 전';  



-- ■ 6. 투표
 INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
 VALUES
    (      1   ,  '홍길동'      , SYSDATE,   1  ,     2 ,        2 );
 COMMIT;
  -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 1;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 2;
    
    commit;
-- ■ 7.  1번 투표의 상세 보기
SELECT answer, acount
    , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 1 ) totalCount
    -- ,  막대그래프
    , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 1 ) * 100) || '%'
 FROM t_pollsub
WHERE pollseq = 1;



-------------------------------------------------------------------------------
//조인

CREATE TABLE book(
       b_id    VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title   VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
 
 
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;



-------------------------------------------------------------------------------
--책(BOOK) 단가테이블

  CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL  -- PK , FK
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_danga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_danga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT;

SELECT *
FROM danga;


-------------------------------------------------------------------------------
-- 저자 테이블
CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) -- ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);
INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;


-------------------------------------------------------------------------------
-- 고객(각각의 서점이 고객이다)테이블생성

CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);
 
 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;


-------------------------------------------------------------------------------
-- 판매 테이블 

CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;     

-------------------------------------------------------------------------------
-- 예) 책id,책제목 , 출판사(c_name), 단가 정보를 조회...
--book : b_id,title,c_name
--danga: b_id , price
--book , danga 조인

-- 1)
SELECT book.b_id,title,c_name,price
FROM  book ,danga
WHERE book.b_id = danga.b_id


-- 2) 
SELECT b.b_id,title,c_name,price
FROM  book b,danga d
WHERE b.b_id = d.b_id;


-- 3) JOIN ON 구문
SELECT b.b_id,title,c_name,price
FROM  book b JOIN danga d ON b.b_id = d.b_id;


-- 4) USING문은 객체명, 별칭명을 사용하지 않습니다. USING절을 사용한다.
SELECT b_id,title,c_name,price
FROM  book JOIN danga USING(b_id);


-------------------------------------------------------------------------------
-- JOIN 예제
 -- *책id, *제목, 판매수량, *단가, 서점명(g_name), 판매금액( p_su * price) 출력.
 
-- book
--       b_id    VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
--      ,title   VARCHAR2(100) NOT NULL  -- 책 제목
--      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름

--  panmai
--      b_id  VARCHAR2(10)  NOT NULL  -- PK , FK
--      ,price  NUMBER(7) NOT NULL    -- 책 가격

--gogaek(
--      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
--      ,g_name   VARCHAR2(20) NOT NULL
--      ,g_tel      VARCHAR2(20)
--  panmai

 
SELECT b.b_id, title,p_su,price ,g_name ,p_su*price sale_amt
FROM book b, danga d,panmai p ,gogaek g
WHERE b.b_id = d.b_id AND p.b_id = b.b_id AND g.g_id = p.g_id;

-- JOIN ON 구문 수정
SELECT b.b_id, title,p_su,price ,g_name ,p_su*price sale_amt
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p  ON p.b_id = b.b_id 
            JOIN gogaek g  ON g.g_id = p.g_id;



SELECT b_id, title,p_su,price ,g_name ,p_su*price sale_amt
FROM book b JOIN danga d USING(b_id)
            JOIN panmai p  USING(b_id)
            JOIN gogaek g  USING(g_id);
            
            
            
-- 예) 출판된 책들이 각각 총 몇권이 판매가 되었는지 조회...
-- (책들의 총 판매수량을 확인)
-- (책 ID, 책제목, 총판매권수 , 단가 컬럼 출력)


SELECT b.b_id,
       title,
       price,
       SUM(p_su)
FROM book b
     JOIN danga d
          ON b.b_id = d.b_id
     JOIN panmai p
          ON b.b_id = p.b_id
GROUP BY b.b_id,
         title,
         price
ORDER BY b.b_id;
            



-- 예) 가장 많이 팔린 책 정보를 조회

SELECT b.b_id, b.title, d.price, SUM(p.p_su) max_book
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id, b.title,d.price
HAVING SUM(p.p_su) = (
    SELECT MAX(max_book)
    FROM (
        SELECT SUM(p_su) max_book
        FROM panmai
        GROUP BY b_id
    )
);


-- 선생님 풀이

SELECT b.b_id, title, price, SUM(p_su)
FROM book b JOIN danga d ON b.b_id = d.b_id
     JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id,title,price
ORDER BY b.b_id
Fetch FIRST 1 ROW ONLY;

-- 선생님 풀이 ) 공동 1등이 있을 경우
-- ROW_NUMBER()
-- RANK() OVER()
-- DENSE_RANK() OVER() *** 실무

SELECT t.*
FROM(
    SELECT b.b_id, title, price, SUM(p_su)
        , DENSE_RANK() OVER(ORDER BY SUM(p_su) DESC) 순위
    FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
    GROUP BY b.b_id,title,price
)t
WHERE 순위 = 1;

-- 선생님 풀이 3)

SELECT MAX(b.b_id) KEEP(DENSE_RANK FIRST ORDER BY SUM(p_su) DESC) max_bid
    ,MAX(title) KEEP(DENSE_RANK FIRST ORDER BY SUM(p_su) DESC) max_bid
    ,MAX(price) KEEP(DENSE_RANK FIRST ORDER BY SUM(p_su) DESC) max_bid
    ,MAX(SUM(p_su)) KEEP(DENSE_RANK FIRST ORDER BY SUM(p_su) DESC) max_bid
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id,title,price;


-- 예) 위에서 총판매권수 조회, 총판매권수가 1위엔 책의 정보조회
--    총판매권수가 20권이 이상인 책의 정보를 조회...

SELECT b.b_id, title, price, SUM(p_su)
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
GROUP BY b.b_id,title,price
HAVING SUM(p_su) >= 20
ORDER BY SUM(p_su) DESC;


-- 예) BOOK 테이블에서 한번도 판매가 된적이 없는 책들의 정보를 조회
-- (책ID, 제목, 단가)

-- 책존재 확인
SELECT b.b_id, b.title
FROM book b

-- 판매된적있는 책 총 6권




-- 내풀이
SELECT b.b_id, b.title, d.price
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d ON b.b_id = d.b_id
WHERE p.b_id IS NULL;



-- 선생님 풀이(1) -- ANTI JOIN : NOT IN (서브쿼리)
SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE B.b_id NOT IN(SELECT DISTINCT b_id FROM panmai);


-- 선생님 풀이(2) -- OUTER JOIN
SELECT b.b_id, title,price
        --,p_su
FROM book b LEFT JOIN panmai p ON b.b_id = p.b_id
                JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL;


-- 1) EQUI JOIN (_)
-- FROM emp e JOIN dept d ON e.deptno = d.deptno


-- 2) NON-EQUI JOIN (_)
-- FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;


-- 3) INNER JOIN : 둘 이상의 테이블에서 join condition을 만족하는 행만 반환한다.

-- 4) ANTI JOIN : NOT IN(존재 X)
-- 5) SEMI JOIN : EXISTS(존재 O)

SELECT DISTINCT b.b_id, title
FROM book b INNER JOIN panmai p ON b.b_id = p.b_id;

-- SEMI JOIN

SELECT b.b_id, title
FROM book b
WHERE EXISTS (SELECT DISTINCT b_id FROM panmai WHERE b_id = b.b_id);




-- 예 ) 고객 중에 판매금액 X, 판매횟수(구매횟수)가 가장 많은 TOP 1 고객 정보 출력 (조회)

SELECT g.g_id, g_name,COUNT(*) 구매횟수
FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
GROUP BY g.g_id, g_name
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) cnt
        FROM panmai
        GROUP BY g_id
    )
);


-- 선생님 풀이
SELECT g.g_id, g_name,COUNT(p.p_Date) 구매횟수
FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
GROUP BY g.g_id, g_name
ORDER BY 구매횟수 DESC
FETCH FIRST 2 ROW ONLY;



-- DENSE_RANK 사용
WITH t AS(
    SELECT g.g_id, g_name,COUNT(p.p_Date) 구매횟수
        , DENSE_RANK() OVER(ORDER BY COUNT(p.p_Date) DESC) 구매순위
    FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
    GROUP BY g.g_id, g_name
)
SELECT *
FROM t
WHERE 구매순위 <= 2;


-- 예) CROSS JOIN  14*4 = 56
SELECT e.* , d.*
FROM emp e, dept d;


-- 예) 년도별/월별 판매 현황 구하기...
--    년도   월     판매금액( p_su * price )
--    ---- -- ----------
--  2000   03   6000
--  2000   07   1600
--  2000   10   10500
--  2024   08   41661


SELECT 
     TO_CHAR(p_date,'YYYY') 년도,
     TO_CHAR(p_date,'MM') 월
    ,SUM(p_su * price) 판매금액
FROM book b JOIN panmai p ON  b.b_id = p.b_id
            JOIN danga d ON b.b_id = d.b_id
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'MM')
ORDER BY 년도, 월 


-- 판매가 되지 않는 월 1~12 모두 출력 PARTITION OUTER JOIN 사용

WITH sales AS (
    SELECT TO_CHAR(p.p_date, 'YYYY') yyyy
        , TO_NUMBER(TO_CHAR(p.p_date, 'MM')) mm
        , SUM(d.price * p.p_su) total_amt
    FROM panmai p JOIN danga d ON p.b_id = d.b_id
    GROUP BY TO_CHAR(p.p_date, 'YYYY') , TO_NUMBER(TO_CHAR(p.p_date, 'MM'))
)
SELECT s.yyyy, LPAD(m.mm, 2, '0') 월, NVL(s.total_amt, 0) 총판매금액
FROM ( SELECT LEVEL mm  FROM dual CONNECT BY LEVEL <= 12 ) m
--   PARTITION OUTER JOIN 사용
LEFT OUTER JOIN sales s PARTITION BY (s.yyyy) ON (m.mm = s.mm)
ORDER BY  s.yyyy , m.mm;



-- 풀이 3) 실무에서는 PARTITION OUTER JOIN 사용하기 보다 CROSS JOIN 훨씬 많이 사용한다.
WITH years AS (
          SELECT DISTINCT
            TO_CHAR(p_date,'YYYY') yyyy
          FROM panmai
)
, months AS (
          SELECT LEVEL mm
          FROM dual
          CONNECT BY LEVEL <= 12
)
SELECT y.yyyy 년도 , LPAD(m.mm,2,'0') 월
    , NVL(SUM(p.p_su * d.price),0) 판매금액
FROM years y CROSS JOIN months m
LEFT JOIN panmai p ON TO_CHAR(p.p_date,'YYYY') = y.yyyy AND TO_NUMBER(TO_CHAR(p.p_date,'MM')) = m.mm
LEFT JOIN danga d       ON p.b_id = d.b_id
GROUP BY    y.yyyy   , m.mm
ORDER BY    y.yyyy   , m.mm;


-- 예) 올해 가장 많이 판매가 된 책 정보 조회 ( ID , 제목, 책 수량)
SELECT b.b_id, b.title, SUM(p.p_su) 책수량
FROM book b JOIN panmai p ON b.b_id = p.b_id
WHERE TO_CHAR(p.p_date,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
GROUP BY b.b_id, b.title
HAVING SUM(p.p_su) = (
    SELECT MAX(책수량)
    FROM (
        SELECT SUM(p_su) 책수량
        FROM panmai
        WHERE TO_CHAR(p_date,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
        GROUP BY b_id
    )
);

-- 선생님 풀이
SELECT  TO_CHAR( p_date, 'YYYY') p_year, b_id
    , SUM( p_su ) y_s_q
FROM panmai p
WHERE TO_CHAR(p.p_date,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
GROUP BY TO_CHAR( p_date, 'YYYY'), b_id
-- ORDER BY TO_CHAR( p_date, 'YYYY'), b_id
ORDER BY y_s_q DESC
FETCH FIRST 1 ROW ONLY;


-- 책에 제목이 빠져서 조인...
SELECT  TO_CHAR( p_date, 'YYYY') p_year, b.b_id,b.title
    , SUM( p_su ) y_s_q
FROM book b JOIN panmai p ON b.b_id = p.b_id
WHERE TO_CHAR(p.p_date,'YYYY') = TO_CHAR(SYSDATE,'YYYY')
GROUP BY TO_CHAR( p_date, 'YYYY'), b.b_id,b.title
-- ORDER BY TO_CHAR( p_date, 'YYYY'), b.b_id
ORDER BY y_s_q DESC
FETCH FIRST 1 ROW ONLY;




-- 예) 각 년도별 가장 많이 판매가 된 책 정보 조회( ID, 제목, 책 수량)

SELECT 년도,
       MAX(b_id) KEEP(DENSE_RANK FIRST ORDER BY 판매수량 DESC) b_id,
       MAX(title) KEEP(DENSE_RANK FIRST ORDER BY 판매수량 DESC) title,
       MAX(판매수량) 판매수량
FROM (
    SELECT TO_CHAR(p.p_date,'YYYY') 년도, b.b_id, b.title,
           SUM(p.p_su) 판매수량
    FROM book b JOIN panmai p ON b.b_id = p.b_id
    GROUP BY TO_CHAR(p.p_date,'YYYY'),b.b_id,b.title
)
GROUP BY 년도
ORDER BY 년도;


-- 선생님 풀이
WITH T AS(
    SELECT  TO_CHAR( p_date, 'YYYY') p_year, b.b_id,b.title
        , SUM( p_su ) y_s_q
        , DENSE_RANK() OVER ( PARTITION BY TO_CHAR(p_date,'YYYY')  ORDER BY  SUM(p_su) DESC) s_q_rank
    FROM book b JOIN panmai p ON b.b_id = p.b_id
    GROUP BY TO_CHAR( p_date, 'YYYY'), b.b_id,b.title
)
SELECT *
FROM t
WHERE s_q_rank = 1;
-- ORDER BY TO_CHAR( p_date, 'YYYY'), b.b_id
--ORDER BY p_year, y_s_q DESC




-- [문제] 서점별 판매현황 구하기
--서점코드  서점명  판매금액합  비율(소수점 둘째반올림)  
-- g_id    g_name
------------ -------------------------- ----------------
--7       강북서점    15300      26%
--4       서울서점    11551      19%
--2       도시서점    6000      10%
--6       강남서점    18060      30%
--1       우리서점    8850      15%


-------------------------------------------------------------------------------
//뷰


