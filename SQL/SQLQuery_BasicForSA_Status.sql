/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
SELECT TOP (1000) [index]
      ,[SERVICE_AREA]
      ,[BMS_TX_BATCH]
      ,[DIRECTION_ID]
      ,[ENTRY_TIME]
      ,[EXIT_TIME]
      ,[STOP]
      ,[STOP_DURATION]
      ,[VEHICLE_ID]
      ,[IDENTITY_ID]
      ,[Gender]
      ,[MVDIS_CATEGORY]
      ,[MANU_YEAR]
      ,[MANU_MONTH]
      ,[VEHICLE_AGE]
      ,[MVDIS_BRAND]
      ,[BRAND]
      ,[Holiday_cnt]
      ,[WEEKDAY_CNT]
      ,[TX_cnt]
      ,[T_MILEAGE]
      ,[O_CITY]
      ,[O_TIME]
      ,[O_MILEAGE]
      ,[D_CITY]
      ,[D_TIME]
      ,[TRIP_DURATION]
      ,[TRIP_DISTANCE]
      ,[ENTRY_SITE]
      ,[EXIT_SITE]
      ,[NAME]
  FROM [athena_dev].[dbo].[Taian]

use athena_dev;
go

-- describe table using "exec sp_help [table_name]"
exec sp_help Taian; 
select count(*) FROM [athena_dev].[dbo].[Taian]

-- setting the sql statement
select count(*) as total
FROM [athena_dev].[dbo].[Taian]
where day(ENTRY_TIME) = 22 
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'
and STOP = 'P' ;

select round(AVG(cast(STOP_DURATION as float)), 2) as avg_stD
FROM [athena_dev].[dbo].[Taian]
where day(ENTRY_TIME) = 21 
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'
and STOP = 'P' ;

select AVG(STOP_DURATION ) as avg_stD
FROM [athena_dev].[dbo].[Taian]
where day(ENTRY_TIME) = 21 
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'
and STOP = 'P' ;

select avg(cast(STOP_DURATION as float))
FROM [athena_dev].[dbo].[Taian]


select  datepart(hour, ENTRY_TIME), count(*) as in_cnt
FROM [athena_dev].[dbo].[Taian]
where day(ENTRY_TIME) = 22 
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'
and STOP = 'P' 
group by datepart(hour, ENTRY_TIME)
--order by datepart(hour, ENTRY_TIME) 

UNION ALL

select datepart(hour, ENTRY_TIME),count(*) as total_cnt
FROM [athena_dev].[dbo].[Taian]
where day(ENTRY_TIME) = 22 
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'
group by datepart(hour, ENTRY_TIME)

order by #1


select count(*) as hour_cnt
FROM [athena_dev].[dbo].[Taian]
where datepart(hour, ENTRY_TIME) = 0
and day(ENTRY_TIME) = 21
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'


select count(*) as min_cnt , avg(cast(STOP_DURATION as float)) as min_stD
FROM [athena_dev].[dbo].[Taian]
where datepart(hour, ENTRY_TIME) = 0
and DATEPART(MINUTE, ENTRY_TIME) <= 10
and DATEPART(MINUTE, ENTRY_TIME) >= 0
and STOP = 'P'
and day(ENTRY_TIME) = 21
and MVDIS_CATEGORY = 31
and DIRECTION_ID = 'N'



SELECT *
FROM [athena_dev].[dbo].[Taian]
WHERE VEHICLE_ID IN (	SELECT DISTINCT VEHICLE_ID
						FROM [athena_dev].[dbo].[Taian]
						WHERE day(ENTRY_TIME) = 21
						and DIRECTION_ID = 'N'
						and STOP = 'P') AS DIS_VE