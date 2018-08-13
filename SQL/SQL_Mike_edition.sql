USE [athena_dev]
GO
WITH tmp AS (
SELECT [VEHICLE_ID] , [Gender] , DAY(ENTRY_TIME) AS ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID--, COUNT(*)
  FROM [dbo].[Taian]
  WHERE STOP = 'P' 
  GROUP BY [VEHICLE_ID] , [Gender] , DAY(ENTRY_TIME) ,MVDIS_CATEGORY ,DIRECTION_ID
  --HAVING COUNT(*)>1
  )
  , m as (
  SELECT [Gender] , ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID , count(*) AS cnt FROM tmp 
  GROUP BY [Gender] , ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
 -- ORDER BY ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
  )
  , t AS (
  SELECT  ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID FROM m 
  group by  ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
  )
  SELECT t.* , m1.[Gender] AS MALE, m1.cnt AS m_cnt , m2.[Gender] AS FEMALE, m2.cnt AS f_cnt , m3.[Gender] AS NON, m3.cnt AS n_cnt   FROM t
  LEFT JOIN m AS m1
  ON t.ENTRY_TIME =m1.ENTRY_TIME
  AND t.MVDIS_CATEGORY =m1.MVDIS_CATEGORY
  AND  t.DIRECTION_ID =m1.DIRECTION_ID
   AND m1.Gender='�k'
  LEFT JOIN m AS m2
  ON t.ENTRY_TIME =m2.ENTRY_TIME
  AND t.MVDIS_CATEGORY =m2.MVDIS_CATEGORY
  AND  t.DIRECTION_ID =m2.DIRECTION_ID
   AND m2.Gender='�k'
  LEFT JOIN m AS m3
  ON t.ENTRY_TIME =m3.ENTRY_TIME
  AND t.MVDIS_CATEGORY =m3.MVDIS_CATEGORY
  AND  t.DIRECTION_ID =m3.DIRECTION_ID
  AND m3.Gender='�D�۵M�H'
  --ORDER BY ENTRY_TIME ,MVDIS_CATEGORY ,DIRECTION_ID
GO

