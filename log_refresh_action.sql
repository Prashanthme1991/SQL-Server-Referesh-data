-- LOG the outcome of sync...
if OBJECT_ID('dbo.log_refresh_action','P')is NULL
begin
EXEC sp_ExecuteSQL N'CREATE PROCEDURE [dbo].[log_refresh_action] as select 1 as x'
print 'View stub created for :[dbo.log_refresh_action]'
end
GO
	create procedure log_refresh_action( 
		@p_obj_owner  varchar(4000) = 'user'
		, @p_object	 varchar(4000) 
		, @q_new_object  varchar(4000)	
		, @q_cur_object varchar(4000)
		, @v_num_recs	 float
		, @v_start_date datetime
		, @v_comments varchar(4000) = 'NA'
	) 
	as
	begin
	set nocount on;
		print 'refresh_util.log_refresh_action: ' + isnull(@v_comments, '');
-- Reflect completed refresh - failure or success...
		UPDATE  LOG_OBJ_REFRESH set new_table_name = 'q_new_object', cur_table_name = 'q_cur_object'
		   , comments = 'v_comments', rec_cnt = 'v_num_recs', end_date = getdate()
        where upper(owner) = upper('p_obj_owner')  and upper(table_name) = upper('p_object')  and start_date = 'v_start_date' ;
		
		BEGIN TRY 
		insert into dbo.LOG_OBJ_REFRESH( owner, table_name, new_table_name, cur_table_name, start_date, end_date, comments, rec_cnt )
			values ( 'p_obj_owner', 'p_object', 'q_new_object', 'q_new_object', 'v_start_date', getdate(), 'v_comments', 'v_num_recs' )
			END TRY

			BEGIN CATCH
			SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_MESSAGE() AS ErrorMessage;
			END CATCH


end; 
	