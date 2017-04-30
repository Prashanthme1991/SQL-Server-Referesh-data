create function dbo.refresh_util()

returns varchar
as
begin
declare  @g_obj_prefeix varchar = 'Z_'
declare	 @g_syn_prefix varchar = 'SYN_'
declare @g_nact_prefix varchar = 'NACT'
declare @g_vw_prefix varchar = 'R_'

	
	RETURN 'varchar'
	end
	GO