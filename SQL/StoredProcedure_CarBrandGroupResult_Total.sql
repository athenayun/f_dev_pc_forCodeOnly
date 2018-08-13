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
CREATE PROCEDURE dbo.GetCarBrandGroupResult_Total
(	
	@TABLE_NAME NVARCHAR(20),
	@DAY NVARCHAR(20),
	@DIRECTION NVARCHAR(20)
)
AS
BEGIN
	DECLARE @tablename VARCHAR(50) 
	SET @tablename = @TABLE_NAME
	DECLARE @sql VARCHAR(2000)
	SET @sql = '
	WITH VEHICLE_BRAND AS (
		SELECT VEHICLE_ID , BRAND , DAY(ENTRY_TIME) AS ENTRY_DAY ,DIRECTION_ID
		FROM dbo.' + @tablename + '
		WHERE STOP = ''P'' 
		GROUP BY VEHICLE_ID , BRAND , DAY(ENTRY_TIME) ,DIRECTION_ID
	) 
		SELECT TOP 20 BRAND , count(*) AS cnt 
		FROM VEHICLE_BRAND 
		WHERE ENTRY_DAY = ' + @DAY +'
		AND DIRECTION_ID = ''' + @DIRECTION + '''
		GROUP BY BRAND , ENTRY_DAY ,DIRECTION_ID
		ORDER BY count(*) DESC 
	'
	EXEC (@sql)
END
GO
---------------------------------------------------
use athena_dev
EXECUTE GetCarBrandGroupResult_Total Taian ,21, N 
go