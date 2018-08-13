USE athena_dev;

SET STATISTICS IO ON
SET STATISTICS TIME ON
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/07
-- Description : Output the "BRAND" grouping result as a table, 
--               by forming a new table for each single car in 
--				 every day, every category, every direction, from all_wOD
-- =====================================================
CREATE PROCEDURE dbo.All_GetCarBrandGroupResult
(	
	@CATEGORY NVARCHAR(20)
)
AS
BEGIN
	DECLARE @sql VARCHAR(2000)
	SET @sql = '
	WITH VEHICLE_BRAND AS (
		SELECT VEHICLE_ID , BRAND ,MVDIS_CATEGORY , count(*) as cnt
		FROM dbo.all_wOD
		WHERE STOP = ''P''
		GROUP BY VEHICLE_ID , BRAND ,MVDIS_CATEGORY 
	) 
		SELECT TOP 20 BRAND , count(*) AS cnt 
		FROM VEHICLE_BRAND 
		WHERE MVDIS_CATEGORY = ' + @CATEGORY + '
		GROUP BY BRAND ,MVDIS_CATEGORY 
		ORDER BY count(*) DESC 
	'
	EXEC (@sql)
END
GO
---------------------------------------------------

/*
EXECUTE All_GetCarBrandGroupResult 32
exec sp_help Taian
*/