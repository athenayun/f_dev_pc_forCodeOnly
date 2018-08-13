
SET STATISTICS IO ON
SET STATISTICS TIME ON

WITH FIRST_LAYER AS (
	-- UNIQUE BMS WHICH HAVE BEEN TO THE FIRST SA, IN PARTICULAR CAR TYPE
	SELECT BMS_TX_BATCH, SERVICE_AREA, COUNT(*) AS CNT
	FROM [athena_dev].[dbo].[all_wOD]
	WHERE STOP = 'P'
	AND MVDIS_CATEGORY = 31
	GROUP BY BMS_TX_BATCH, SERVICE_AREA
	
)
	SELECT SERVICE_AREA, COUNT(*) AS CNT
	FROM FIRST_LAYER
	--WHERE BMS_TX_BATCH = '1805270002314673011'
	GROUP BY SERVICE_AREA

-----------------------------------------------------

WITH UNIQUE_BMS AS (
	SELECT DISTINCT BMS_TX_BATCH--, SERVICE_AREA, VEHICLE_ID, MVDIS_CATEGORY, 
					--STOP, in_location, out_location, O_COUNTRY, D_COUNTRY
	FROM [athena_dev].[dbo].[all_wOD]
	WHERE STOP = 'P'
	AND MVDIS_CATEGORY = 31
	AND SERVICE_AREA = '泰安'
) 
	SELECT BMS_TX_BATCH, SERVICE_AREA, VEHICLE_ID, MVDIS_CATEGORY, 
			STOP, in_location, out_location, O_COUNTRY, D_COUNTRY
	FROM [athena_dev].[dbo].[all_wOD]
	WHERE SERVICE_AREA = '中壢'
	AND BMS_TX_BATCH IN UNIQUE_BMS
	--AND MVDIS_CATEGORY = 31
	--AND SERVICE_AREA = '泰安'--'中壢'

---------------------------------------------------------------------

--BMS_TX_BATCH, SERVICE_AREA, VEHICLE_ID, MVDIS_CATEGORY, 
--		STOP, in_location, out_location, O_COUNTRY, D_COUNTRY

SELECT DISTINCT VEHICLE_ID
FROM [athena_dev].[dbo].[all_wOD] 
WHERE BMS_TX_BATCH IN (	SELECT DISTINCT BMS_TX_BATCH
						FROM [athena_dev].[dbo].[all_wOD]
						WHERE STOP = 'P'
						AND MVDIS_CATEGORY = 31
						AND SERVICE_AREA = '泰安')
AND SERVICE_AREA = '中壢'
AND STOP = 'P'
-- =================================================================================
SELECT TOP 3 (in_location + '-' + out_location ) AS HOT_SPOT
FROM [athena_dev].[dbo].[all_wOD] 
WHERE VEHICLE_ID IN (	SELECT DISTINCT VEHICLE_ID
						FROM [athena_dev].[dbo].[all_wOD] 
						WHERE BMS_TX_BATCH IN (	SELECT DISTINCT BMS_TX_BATCH
												FROM [athena_dev].[dbo].[all_wOD]
												WHERE STOP = 'P'
												AND MVDIS_CATEGORY = 31
												AND SERVICE_AREA = '泰安')
						AND SERVICE_AREA = '中壢'
						AND STOP = 'P')
GROUP BY in_location, out_location
ORDER BY COUNT(*) DESC





-----------------------------------------------------
WITH VEHICLE_BRAND AS (
		SELECT VEHICLE_ID , BRAND  , count(*) as cnt
		FROM dbo.all_wOD
		WHERE STOP = 'P' 
		GROUP BY VEHICLE_ID , BRAND 
	) 
		SELECT TOP 20 BRAND , count(*) AS cnt 
		FROM VEHICLE_BRAND 
		--WHERE MVDIS_CATEGORY = 31
		GROUP BY BRAND 
		ORDER BY count(*) DESC 