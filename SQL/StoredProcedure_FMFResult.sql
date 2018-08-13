USE athena_dev;
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/06
-- Description : Output the "Gender" grouping result as a table, 
--               by forming a new table for each single car in 
--				 every day, every category, every direction
-- =====================================================
CREATE PROCEDURE dbo.GetFMFGroupResult
(	
	@TABLE_NAME NVARCHAR(20)
)
AS
BEGIN

	declare @tablename varchar(50) 
	set @tablename = @TABLE_NAME
	declare @sql varchar(2000)
	set @sql = '

	WITH tmp AS (
		SELECT VEHICLE_ID , Gender , DAY(ENTRY_TIME) AS ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID--, COUNT(*)
	  FROM dbo.'+ @tablename + '
	  WHERE STOP = "P" 
	  GROUP BY VEHICLE_ID , Gender , DAY(ENTRY_TIME) ,MVDIS_CATEGORY ,DIRECTION_ID
	  --HAVING COUNT(*)>1
	  )
	  , m as (
	  SELECT Gender , ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID , count(*) AS cnt FROM tmp 
	  GROUP BY Gender , ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
	 -- ORDER BY ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
	  )
	  , t AS (
	  SELECT  ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID FROM m 
	  group by  ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
	  )
	  SELECT t.* , m1.Gender AS MALE, m1.cnt AS m_cnt , m2.Gender AS FEMALE, m2.cnt AS f_cnt , m3.Gender AS NON, m3.cnt AS n_cnt   FROM t
	  LEFT JOIN m AS m1
	  ON t.ENTRY_TIME =m1.ENTRY_TIME
	  AND t.MVDIS_CATEGORY =m1.MVDIS_CATEGORY
	  AND  t.DIRECTION_ID =m1.DIRECTION_ID
	   AND m1.Gender="男"
	  LEFT JOIN m AS m2
	  ON t.ENTRY_TIME =m2.ENTRY_TIME
	  AND t.MVDIS_CATEGORY =m2.MVDIS_CATEGORY
	  AND  t.DIRECTION_ID =m2.DIRECTION_ID
	   AND m2.Gender="女"
	  LEFT JOIN m AS m3
	  ON t.ENTRY_TIME =m3.ENTRY_TIME
	  AND t.MVDIS_CATEGORY =m3.MVDIS_CATEGORY
	  AND  t.DIRECTION_ID =m3.DIRECTION_ID
	  AND m3.Gender="非自然人"
	  --ORDER BY ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID '

	exec (@sql)
END
GO
---------------------------------------------------



--EXECUTE GetFMFGroupResult Huko