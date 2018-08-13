CREATE FUNCTION dbo.OutputTripTable
(	
	@i VARCHAR(100)
)
RETURNS TABLE
AS
RETURN (
	SELECT SERVICE_AREA, COUNT(*) AS CNT
	FROM [athena_dev].[dbo].[all_wOD]
	WHERE BMS_TX_BATCH = @i
	AND STOP = 'P'
	GROUP BY SERVICE_AREA
)
---------------------------------------------------------------
select COUNT(*)
from dbo.OutputTripTable(1805270002316853771)



SELECT COUNT(*)--BMS_TX_BATCH, COUNT(*) AS CNT
FROM [athena_dev].[dbo].[all_wOD]
WHERE STOP = 'P'
AND MVDIS_CATEGORY = 31
AND SERVICE_AREA = '®õ¦w'
--GROUP BY BMS_TX_BATCH
--ORDER BY CNT DESC

SELECT COUNT(*) as cnt
FROM (	SELECT DISTINCT BMS_TX_BATCH, SERVICE_AREA, VEHICLE_ID
		FROM [athena_dev].[dbo].[all_wOD]
		WHERE STOP = 'P'
		AND MVDIS_CATEGORY = 31
		AND SERVICE_AREA = '®õ¦w') AS CNT