USE athena_dev;
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/07
-- Description : Output the "BRAND" grouping result as a table, 
--               by forming a new table for each single car in 
--				 every day, every category, every direction
-- =====================================================
CREATE PROCEDURE dbo.GetCarBrandGroupResult
(	
	@TABLE_NAME NVARCHAR(20),
	@DAY NVARCHAR(20),
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
		SELECT VEHICLE_ID , BRAND , DAY(ENTRY_TIME) AS ENTRY_DAY ,MVDIS_CATEGORY ,DIRECTION_ID
		FROM dbo.' + @tablename + '
		WHERE STOP = ''P'' 
		GROUP BY VEHICLE_ID , BRAND , DAY(ENTRY_TIME) ,MVDIS_CATEGORY ,DIRECTION_ID
	) 
		SELECT TOP 20 BRAND , count(*) AS cnt 
		FROM VEHICLE_BRAND 
		WHERE ENTRY_DAY = ' + @DAY +'
		AND MVDIS_CATEGORY = ' + @CATEGORY + '
		AND DIRECTION_ID = ''' + @DIRECTION + '''
		GROUP BY BRAND , ENTRY_DAY ,MVDIS_CATEGORY ,DIRECTION_ID
		ORDER BY count(*) DESC 
	'
	EXEC (@sql)
END
GO
---------------------------------------------------


EXECUTE GetCarBrandGroupResult Taian ,21, 32, N 
exec sp_help Taian