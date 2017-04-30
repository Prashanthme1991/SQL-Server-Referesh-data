-- CHK to make sure the refresh was successful.
	
IF OBJECT_ID('dbo.valid_refresh') IS NOT NULL
  DROP FUNCTION valid_refresh
GO
create function [dbo].[valid_refresh] (
		@p_obj_owner  varchar(4000) = 'user'
		, @p_object	 varchar(4000)
		, @q_new_object  varchar(4000))
		
		returns float		
	as
	begin
		declare @rec1_cnt       float;
		declare @min_cnt		float;
		
		declare @q_object		varchar(100);
		declare @stmt			varchar(2000);		-- SQL str to execute after formatting
		declare @term_name		varchar(25);
	 
		PRINT 'refresh_util.valid_refresh... ';
		
		set @q_object = upper( @q_new_object );
		
		set @stmt = 'select count(0)  from '+ isnull(@q_object, '');
		PRINT  "..."+isnull(@stmt, '');
		execute sp_executesql @stmt= into  @rec_cnt;
		
		
		SET @min_cnt = 0;	--  default to a forced failure
		select @min_cnt = 'min_sync_cnt' from dbo.BASE_OBJ_METADATA where upper('owner') = upper('@p_obj_owner') and upper('table_name') = upper('@p_object') ;

		PRINT  'min_cnt = '+' isnull(@min_cnt. '') ' +', and actual cnt = '+' isnull(@rec_cnt, '')';
		
		
		-- For Summer semesters, drop the threshold...
		select @term_name = upper( 'cur_term_name' )  from master.VW_SEMESTER;
		
		case
		   when ( term_name like SUM% ) then set min_cnt = rec_cnt * 0.05;
		   else NULL;
		end case;
				
		if ( 'rec_cnt' < 'min_cnt'  or 'min_cnt' = 0 ) begin
			return 0;
		end
		else begin 
			return 'rec_cnt';
		end
		
		
		EXCEPTION
		When NO_DATA_FOUND  then 
		   print  ISNULL(SQLERRM, '') +': '+ ISNULL(SQLERRM, '');		
		   refresh_util.log_refresh_action( p_obj_owner, p_object, q_new_object, 'NA', rec_cnt, getdate()
		      , 'EXCEPTION ('+ ISNULL(SQLCODE, '') +') No [min_sync_cnt] found in uis_edw.BASE_OBJ_METADATA.'+ isnull(substring(SQLERRM, 1,200), '') );
		   return 0;
		   
		 EXCEPTION(
		When others then
		   rollback;
		   print  ISNULL(SQLERRM, '') +":" + ISNULL(SQLERRM, '');
		   refresh_util.log_refresh_action( p_obj_owner, p_object, q_new_object, NA, rec_cnt, getdate()
		      , EXCEPTION (+ ISNULL(SQLCODE, '') +) "+ " isnull(substring(SQLERRM, 1,200), '') )
			  
	end;   
	/*
	BEGIN TRY

   
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;

	


	if @@ERROR <> 0
		begin
			--RETURN 99 TO THE CALLING PROGRAM TO INDICATE THE FAILURE
			PRINT N'An eroor occured .';
			RETURN 99;
		END
	ELSE 
		BEGIN
		--REUTN 0 TO THE CALLING PROGRAM TO INDIACTE SUCCESS
		PRINT N'The insert operation is succesfull.';
		RETURN 0;
		*/S
