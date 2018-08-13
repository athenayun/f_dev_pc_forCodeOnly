USE athena_dev;
SET NOCOUNT ON;
GO
-- =====================================================
-- Author : Athena Lee
-- Create date : 2018/08/07
-- Description : Output the "Brand" grouping result as a table, 
--               by forming a new table for each single car in 
--				 every day, every category, every direction
-- =====================================================
CREATE FUNCTION dbo.GetCarBrandTable
(	
	@day int, 
	@direction nvarchar(10), 
	@category int
)
RETURNS @U_TABLE TABLE (
						VEHICLE_ID INT,
						DIRECTION_ID NVARCHAR(10),
						ENTRY_TIME DATETIME,
						MVDIS_CATEGORY INT, 
						BRAND NVARCHAR(10)
						)
AS
BEGIN

declare @i varchar(100)
declare @VEHICLE_ID INT,
		@DIRECTION_ID NVARCHAR(10),
		@ENTRY_TIME DATETIME,
		@MVDIS_CATEGORY INT, 
		@BRAND NVARCHAR(10)

declare cursor_1 cursor for	(	select DISTINCT VEHICLE_ID 
								from [athena_dev].[dbo].[Taian]
								where DAY(ENTRY_TIME) = @day
								and DIRECTION_ID = @direction
								AND MVDIS_CATEGORY = @category
								and STOP = 'P' )


open cursor_1
fetch next from cursor_1 into @i
while @@FETCH_STATUS = 0
begin
	DECLARE cursor_2 CURSOR STATIC LOCAL READ_ONLY FORWARD_ONLY
	FOR (	select TOP 1 VEHICLE_ID, DIRECTION_ID, ENTRY_TIME, MVDIS_CATEGORY, BRAND
			from [athena_dev].[dbo].[Taian]
			where VEHICLE_ID = @i
			and DAY(ENTRY_TIME) = @day
			and DIRECTION_ID = @direction
			AND MVDIS_CATEGORY = @category
			and STOP = 'P');
	OPEN cursor_2
	fetch next from cursor_2 into @VEHICLE_ID ,@DIRECTION_ID ,@ENTRY_TIME ,@MVDIS_CATEGORY, @BRAND 
		begin
			INSERT INTO @U_TABLE(VEHICLE_ID ,DIRECTION_ID,ENTRY_TIME ,MVDIS_CATEGORY, BRAND )
			values( @VEHICLE_ID ,@DIRECTION_ID ,@ENTRY_TIME ,@MVDIS_CATEGORY, @BRAND)

			fetch next from cursor_2 into @VEHICLE_ID ,@DIRECTION_ID ,@ENTRY_TIME ,@MVDIS_CATEGORY, @BRAND 
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
 select BRAND, count(*) as cnt
 from dbo.GetCarBrandTable(21, 'N', 31)
 group by BRAND
 order by count(*) desc