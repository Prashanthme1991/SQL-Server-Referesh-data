	-- START the sync...
if OBJECT_ID('dbo.start_obj_refresh','P')is NULL
begin
EXEC sp_ExecuteSQL N'CREATE PROCEDURE [dbo].[start_obj_refres] as select 1 as x'
print 'View stub created for :[dbo.start_obj_refres]'
end
GO
	create procedure start_obj_refresh( 
		@p_obj_owner  varchar(4000) = 'user'
		, @p_object	 varchar(4000)
		, @q_new_object  varchar(4000)	
		, @q_cur_object varchar(4000)
		, @v_start_date datetime
		, @v_comments	 varchar(4000) = RUNNING
	)	
	as
	begin
		declare @num_recs		float;
	 
		print 'refresh_util.log_refresh...';
		
		set @num_recs = 0;	--  default to a forced failure
		select @num_recs = count(0)  from [dbo].[LOG_OBJ_REFRESH]  l
		   where upper(l.owner) = upper(@p_obj_owner)  and upper(l.table_name) = upper(@p_object)  and l.comments like 'RUNNING%';
		   
		if ( @num_recs = 0 ) begin
		
			insert into [dbo].[LOG_OBJ_REFRESH]( [owner], [table_name], [new_table_name], [cur_table_name], start_date, [comments], [rec_cnt])
			values ( @p_obj_owner, @p_object, @q_new_object, @q_cur_object, @v_start_date, @v_comments, 0 );
		
			return 0;
		end
		else begin 
			return 1;	-- ...object is being syncd
		end 

		if @@ERROR <> 0
		begin
			--RETURN 99 TO THE CALLING PROGRAM TO INDICATE THE FAILURE
			PRINT N'An eroor occured while inserting the values in the table.';
			RETURN 99;
		END
	ELSE 
		BEGIN
		--REUTN 0 TO THE CALLING PROGRAM TO INDIACTE SUCCESS
		PRINT N'The insert operation is succesfull.';
		RETURN 0;

		   
	end ;
		
		 