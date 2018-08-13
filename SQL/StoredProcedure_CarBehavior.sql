USE athena_dev;
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/07
-- Description : Output the statistic of count(*) , "WEEKDAY_CNT" and "Holiday_cnt"  
--               grouping result as a table, by forming a new table for each single car in 
--				 every day, every category, every direction
-- =====================================================
CREATE PROCEDURE dbo.GetCarBehaviorResult
(	
	@TABLE_NAME NVARCHAR(20),
	@CATEGORY NVARCHAR(20),
	@DIRECTION NVARCHAR(20)
)
AS
BEGIN
	DECLARE @tablename VARCHAR(50) 
	SET @tablename = @TABLE_NAME
	DECLARE @sql VARCHAR(2000)
	SET @sql = '
	WITH VEHICLE_BRAND AS (
		SELECT VEHICLE_ID, MVDIS_CATEGORY, DIRECTION_ID, WEEKDAY_CNT, Holiday_cnt
		FROM dbo.' + @tablename + '
		WHERE STOP = ''P'' 
		GROUP BY VEHICLE_ID ,MVDIS_CATEGORY,DIRECTION_ID, WEEKDAY_CNT, Holiday_cnt
		
	) 
		SELECT MVDIS_CATEGORY, DIRECTION_ID , count(*) AS cnt , round(avg(cast(WEEKDAY_CNT as float)), 2) AS WD, round(avg(cast(Holiday_cnt as float)), 2) AS WK 
		FROM VEHICLE_BRAND 
		WHERE DIRECTION_ID = ''' + @DIRECTION + '''
		AND MVDIS_CATEGORY = ' + @CATEGORY +'
		GROUP BY MVDIS_CATEGORY,DIRECTION_ID
	'
	EXEC (@sql)
END
GO
---------------------------------------------------
/*
use athena_dev
EXECUTE GetCarBehaviorResult Taian ,31, S 
go




WITH VEHICLE_BRAND AS (
		SELECT VEHICLE_ID, MVDIS_CATEGORY, DIRECTION_ID, WEEKDAY_CNT, Holiday_cnt--, COUNT(*)
		FROM dbo.Taian
		WHERE STOP = 'P' 
		GROUP BY VEHICLE_ID ,MVDIS_CATEGORY,DIRECTION_ID, WEEKDAY_CNT, Holiday_cnt
		--HAVING COUNT(*) >1
	) 
		SELECT MVDIS_CATEGORY, DIRECTION_ID , count(*) AS cnt , round(avg(cast(WEEKDAY_CNT as float)), 2) AS WD, round(avg(cast(Holiday_cnt as float)), 2) AS WK 
		FROM VEHICLE_BRAND 
		WHERE DIRECTION_ID = 'N'
		AND MVDIS_CATEGORY = 31
		GROUP BY MVDIS_CATEGORY,DIRECTION_ID
*/