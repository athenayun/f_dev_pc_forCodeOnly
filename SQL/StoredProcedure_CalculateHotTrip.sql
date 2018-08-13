USE athena_dev;

SET STATISTICS IO ON
SET STATISTICS TIME ON
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/10
-- Description : Output Top 3 HOT_SPOT grouping result (in_location & out_location) 
--               as a table, by performing a sql query : select unique bms_num into
--               sa1, then select the vehicle_id into sa2, then do the grouping
-- =====================================================



CREATE PROCEDURE dbo.CalculateHotTrip
(
	@SA1 NVARCHAR(10),
	@SA2 NVARCHAR(10),
	@CATEGORY INT
)
AS
BEGIN
	SELECT TOP 3 (in_location + '-' + out_location ) AS HOT_SPOT
	FROM [athena_dev].[dbo].[all_wOD] 
	WHERE VEHICLE_ID IN (	SELECT DISTINCT VEHICLE_ID
							FROM [athena_dev].[dbo].[all_wOD] 
							WHERE BMS_TX_BATCH IN (	SELECT DISTINCT BMS_TX_BATCH
													FROM [athena_dev].[dbo].[all_wOD]
													WHERE STOP = 'P'
													AND MVDIS_CATEGORY = @CATEGORY
													AND SERVICE_AREA = @SA1)
							AND SERVICE_AREA = @SA2
							AND STOP = 'P')
	GROUP BY in_location, out_location
	ORDER BY COUNT(*) DESC
END
GO


------------------------------------------------------
EXECUTE dbo.CalculateHotTrip '®õ¦w', '¦è´ò', 31