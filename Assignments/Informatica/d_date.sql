CREATE TABLE d_date AS
    SELECT
       n AS Date_ID,
       TO_DATE('31/12/2007','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day') AS Full_Date,
       TO_CHAR(TO_DATE('31/12/2007','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'DD') AS Days,
       TO_CHAR(TO_DATE('31/12/2007','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'Mon') AS Month_Short,
       TO_CHAR(TO_DATE('31/12/2007','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'MM') AS Month_Num,
       TO_CHAR(TO_DATE('31/12/2007','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'Month') AS Month_Long,
       TO_CHAR(TO_DATE('31/12/2007','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'YYYY') AS Year
   FROM (
   select level n
   from dual
   connect by level <= 2000
   );