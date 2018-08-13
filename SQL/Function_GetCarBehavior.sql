USE athena_dev;
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/07
-- Description : Output the statistic of count(*) , "WEEKDAY_CNT" and "Holiday_cnt"  
--               by forming a new table for each single car in 
--				 every day, every category, every direction
-- =====================================================
CREATE FUNCTION dbo.GetCarBehavior
(	
	@direction nvarchar(10), 
	@category int
)
RETURNS @U_TABLE TABLE (
						VEHICLE_ID INT,
						DIRECTION_ID NVARCHAR(10),
						ENTRY_TIME DATETIME,
						MVDIS_CATEGORY INT, 
						WEEKDAY_CNT FLOAT,
						HOLIDAY_CNT FLOAT
						)
AS
BEGIN

declare @i varchar(100)
declare @VEHICLE_ID INT,
		@DIRECTION_ID NVARCHAR(10),
		@ENTRY_TIME DATETIME,
		@MVDIS_CATEGORY INT, 
		@WEEKDAY_CNT FLOAT,
		@HOLIDAY_CNT FLOAT

declare cursor_1 cursor for	(	select DISTINCT VEHICLE_ID 
								from [athena_dev].[dbo].[Taian]
								WHERE DIRECTION_ID = @direction
								AND MVDIS_CATEGORY = @category
								and STOP = 'P' )


open cursor_1
fetch next from cursor_1 into @i
while @@FETCH_STATUS = 0
begin
	DECLARE cursor_2 CURSOR STATIC LOCAL READ_ONLY FORWARD_ONLY
	FOR (	select TOP 1 VEHICLE_ID, DIRECTION_ID, ENTRY_TIME, MVDIS_CATEGORY, WEEKDAY_CNT, Holiday_cnt
			from [athena_dev].[dbo].[Taian]
			where VEHICLE_ID = @i
			and DIRECTION_ID = @direction
			AND MVDIS_CATEGORY = @category
			and STOP = 'P');
	OPEN cursor_2
	fetch next from cursor_2 into @VEHICLE_ID ,@DIRECTION_ID ,@ENTRY_TIME ,@MVDIS_CATEGORY, @WEEKDAY_CNT, @HOLIDAY_CNT 
		begin
			INSERT INTO @U_TABLE(VEHICLE_ID ,DIRECTION_ID,ENTRY_TIME ,MVDIS_CATEGORY, WEEKDAY_CNT, HOLIDAY_CNT  )
			values( @VEHICLE_ID ,@DIRECTION_ID ,@ENTRY_TIME ,@MVDIS_CATEGORY, @WEEKDAY_CNT, @HOLIDAY_CNT )

			fetch next from cursor_2 into @VEHICLE_ID ,@DIRECTION_ID ,@ENTRY_TIME ,@MVDIS_CATEGORY, @WEEKDAY_CNT, @HOLIDAY_CNT 
		end
		CLOSE cursor_2
		DEALLOCATE cursor_2
	
		fetch next from cursor_1 into @i
end
close cursor_1
deallocate cursor_1

RETURN
END




go



--------------------------------------------------------

 use athena_dev
 select count(*) as cnt, AVG(WEEKDAY_CNT) AS WD, AVG(HOLIDAY_CNT) AS WK
 from dbo.GetCarBehavior('N', 31)
 

 