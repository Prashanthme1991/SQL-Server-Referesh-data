CREATE VIEW dbo.R_App_Param_Lkp 
AS
SELECT * FROM OPENQUERY(ORAPROD, 'select * from team.app_param_lkp');
--CREATE TABLE dbo.Mv_App_Param_Lkp
SELECT * INTO dbo.Mv_App_param_Lkp FROM dbo.R_App_Param_Lkp;


SELECT * FROM dbo.Mv_App_param_Lkp;


