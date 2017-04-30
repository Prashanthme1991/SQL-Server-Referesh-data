IF (OBJECT_ID('dbo.sp_delete_app_param_lkp') IS NOT NULL )
DROP PROCEDURE dbo.sp_delete_app_param_lkp
GO
CREATE PROCEDURE dbo.sp_delete_app_param_lkp( @PARAM_ID varchar(10) , @PARAM_CD varchar(10))
AS
BEGIN


DELETE 
FROM Mv_App_param_Lkp
where
 PARAM_ID = @PARAM_ID and PARAM_CD = @PARAM_CD
END
GO
