--HR
------------------------------------------------------------------------------------------

SELECT *
FROM employees;

------------------------------------------------------------------------------------------
-- 예) 분기별 입사한 사원수를 파악...

SELECT 
        TO_CHAR(hire_date, 'Q') 분기,
        COUNT(*) 사원수
FROM employees
GROUP BY TO_CHAR(hire_date, 'Q')
ORDER BY TO_CHAR(hire_date, 'Q');



SELECT hire_date
        ,TO_CHAR(hire_date, 'MM') h_month
        ,EXTRACT(MONTH FROM hire_date) h_month
        ,CASE
            WHEN EXTRACT(MONTH FROM hire_date) BETWEEN 1 AND 3 THEN '1Q'
            WHEN EXTRACT(MONTH FROM hire_date) BETWEEN 4 AND 6 THEN '2Q'
            WHEN EXTRACT(MONTH FROM hire_date) BETWEEN 7 AND 9 THEN '3Q'
        ELSE '4Q'
        END Quater
        ,TO_CHAR(hire_date,'Q') Quater2
FROM employees;

------------------------------------------------------------------------------------------
-- DECODE() 사용 --
SELECT 
     COUNT(DECODE(TO_CHAR(hire_date,'Q'),1,'O')) quarter1
    ,COUNT(DECODE(TO_CHAR(hire_date,'Q'),2,'O')) quarter2
    ,COUNT(DECODE(TO_CHAR(hire_date,'Q'),3,'O')) quarter3
    ,COUNT(DECODE(TO_CHAR(hire_date,'Q'),4,'O')) quarter4
FROM employees;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------







