SELECT Mtable.MM,
ISNULL(z1.每月土地租售收入, 0) AS 每月土地租售收入,
ISNULL(z2.[每月營建收入(營管系統)], 0) AS [每月營建收入(營管系統)],
ISNULL(z3.[每月營建收入(JDE系統)], 0) AS [每月營建收入(JDE系統)],
-ISNULL(z4.每月退地金額, 0) AS 每月退地金額,
(ISNULL(z1.每月土地租售收入, 0)
+ ISNULL(z2.[每月營建收入(營管系統)], 0)
+ ISNULL(z3.[每月營建收入(JDE系統)], 0)
- ISNULL(z4.每月退地金額, 0)) AS 每月收入總額
from
(select 1 as MM
union
select 2 as MM
union
select 3 as MM
union
select 4 as MM
union
select 5 as MM
union
select 6 as MM
union
select 7 as MM
union
select 8 as MM
union
select 9 as MM
union
select 10 as MM
union
select 11 as MM
union
select 12 as MM
) as Mtable
left join
(select a1.YYYY, a1.MM, sum(a1.NVL) as 每月土地租售收入
from
(
select left(IDATE_D, 4) as YYYY, cast(SUBSTRING(IDATE_D, 6, 2) as int) as MM, NVL
from [dbo].['Select in_inrec_pd_st$']
) as a1
group by a1.YYYY, a1.MM
) as z1
on Mtable.MM=z1.MM
full join
(
select b2.YYYY, cast(b2.MM as int) as MM, sum(cast(b2.AMT as float)) as [每月營建收入(營管系統)]
from
(
select MAX(YYYY) as YYYY
from [dbo].[F59B008_R01_20230321_BIG5]
) b1
left join
(
select *
from [dbo].[F59B008_R01_20230321_BIG5]
) b2
on b1.YYYY=b2.YYYY
group by b2.YYYY, b2.MM
) as z2
on Mtable.MM=z2.MM
full join 
(
select c2.YYYY, c2.MM, c2.GBAMT as [每月營建收入(JDE系統)]
from
(select max(YYYY) as YYYY
from [dbo].[F0902_20230321_BIG5_upload]) as c1
left join
(
select YYYY, cast(MM as int) as MM, GBAMT
from [dbo].[F0902_20230321_BIG5_upload]
where GBLT='AA' and GBOBJ='118100' and GBSUB='B18' and GBCO='11900'
) as c2
on c1.YYYY=c2.YYYY
) as z3
on Mtable.MM=z3.MM
full join
(
select d1.YYYY, d1.MM, sum(d1.退地金額) as 每月退地金額
from
(
SELECT CONCAT(glctry, glfy) as YYYY,glpn as MM, GLAA as 退地金額 
FROM [dbo].['Select f0911_pd_mv$']
) as d1
group by d1.YYYY, d1.MM
) as z4
on Mtable.MM=z4.MM
order by Mtable.MM