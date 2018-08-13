declare @i varchar(100)

declare cursor_1 cursor for	(	select MDSequenceNum 
								from [athena_practice].[dbo].[GantryData_20171115] 
								where MDSequenceNum like '%e_0' escape 'e' )


open cursor_1
fetch next from cursor_1 into @i
while @@FETCH_STATUS = 0
begin
	
	DECLARE cursor_2 CURSOR STATIC LOCAL READ_ONLY FORWARD_ONLY
	FOR (	select *
			from [athena_practice].[dbo].[GantryData_20171115]
			where MDSequenceNum = left( @i ,CHARINDEX('_', @i )-1));
	OPEN cursor_2
	FETCH NEXT FROM cursor_2
	INTO  @MDSequenceNum, @LPRNumber1, @LPRNumber2, @AVEID, @DetectionTime, @LaneSystemID, @LaneNr, @Violation, @Category, @SpeedIndication,
		@TransactionTime, @TagArriveTime, @TagDepartTime, @TransactionResult, @ReaderSN, @AuditRecord, @EPCID, @VehicleDeviceCategory,
		@ETagRSSIValue, @RFKeysetVersion, @Repeat_, @TID, @UserData2, @UserData3, @PictureTime, @KeepImageList, @MAC, @eTagLPRNumber,
		@StChargeFlag, @DecompositionFlag, @DeviceCategory, @DeviceStatus, @DeviceStatusCode, @Sender, @CheckCode, @DeviceServiceStatus,
		@DeviceVCID, @DeviceIdentity, @FreewayNo, @FreewayType, @FreewayKM, @FreewayDirection, @ImageRegetReturned, @OfflineTrans,
		@OcrSendFlag, @ViolationOrgn, @TransactionTimeOrgn, @ProcessedTime, @CreateId, @CreateDttm, @ModifyId, @ModifyDttm ;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @Output (MDSequenceNum, LPRNumber1, LPRNumber2, AVEID, DetectionTime, LaneSystemID, LaneNr, Violation, Category, SpeedIndication,
		TransactionTime, TagArriveTime, TagDepartTime, TransactionResult, ReaderSN, AuditRecord, EPCID, VehicleDeviceCategory,
		ETagRSSIValue, RFKeysetVersion, Repeat_, TID, UserData2, UserData3, PictureTime, KeepImageList, MAC, eTagLPRNumber,
		StChargeFlag, DecompositionFlag, DeviceCategory, DeviceStatus, DeviceStatusCode, Sender, CheckCode, DeviceServiceStatus,
		DeviceVCID, DeviceIdentity, FreewayNo, FreewayType, FreewayKM, FreewayDirection, ImageRegetReturned, OfflineTrans,
		OcrSendFlag, ViolationOrgn, TransactionTimeOrgn, ProcessedTime, CreateId, CreateDttm, ModifyId, ModifyDttm)

		VALUES (@MDSequenceNum, @LPRNumber1, @LPRNumber2, @AVEID, @DetectionTime, @LaneSystemID, @LaneNr, @Violation, @Category, @SpeedIndication,
		@TransactionTime, @TagArriveTime, @TagDepartTime, @TransactionResult, @ReaderSN, @AuditRecord, @EPCID, @VehicleDeviceCategory,
		@ETagRSSIValue, @RFKeysetVersion, @Repeat_, @TID, @UserData2, @UserData3, @PictureTime, @KeepImageList, @MAC, @eTagLPRNumber,
		@StChargeFlag, @DecompositionFlag, @DeviceCategory, @DeviceStatus, @DeviceStatusCode, @Sender, @CheckCode, @DeviceServiceStatus,
		@DeviceVCID, @DeviceIdentity, @FreewayNo, @FreewayType, @FreewayKM, @FreewayDirection, @ImageRegetReturned, @OfflineTrans,
		@OcrSendFlag, @ViolationOrgn, @TransactionTimeOrgn, @ProcessedTime, @CreateId, @CreateDttm, @ModifyId, @ModifyDttm);
	
		FETCH NEXT FROM cursor_2
		INTO  @MDSequenceNum, @LPRNumber1, @LPRNumber2, @AVEID, @DetectionTime, @LaneSystemID, @LaneNr, @Violation, @Category, @SpeedIndication,
		@TransactionTime, @TagArriveTime, @TagDepartTime, @TransactionResult, @ReaderSN, @AuditRecord, @EPCID, @VehicleDeviceCategory,
		@ETagRSSIValue, @RFKeysetVersion, @Repeat_, @TID, @UserData2, @UserData3, @PictureTime, @KeepImageList, @MAC, @eTagLPRNumber,
		@StChargeFlag, @DecompositionFlag, @DeviceCategory, @DeviceStatus, @DeviceStatusCode, @Sender, @CheckCode, @DeviceServiceStatus,
		@DeviceVCID, @DeviceIdentity, @FreewayNo, @FreewayType, @FreewayKM, @FreewayDirection, @ImageRegetReturned, @OfflineTrans,
		@OcrSendFlag, @ViolationOrgn, @TransactionTimeOrgn, @ProcessedTime, @CreateId, @CreateDttm, @ModifyId, @ModifyDttm ;
	END
	CLOSE cursor_2
	DEALLOCATE cursor_2
	
	fetch next from cursor_1 into @i
end
close cursor_1
deallocate cursor_1