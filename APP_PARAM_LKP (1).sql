/*
File:        

Desc:     Taken from...

Note:    
                                
Author: 
*/
use pedge2adm;

-- VIEW for internal usage;  Used for directly referencing EDW (to pull data over - i.e. contains the business rules to filter with)
create view dbo.r_app_param_lkp
as 
   select * from openquery( oraprod,  'select * from team.app_param_lkp') ;
;/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Z_1
	(
	param_seq_no nvarchar(50) NOT NULL,
	param_id nvarchar(50) NOT NULL,
	param_cd varchar(50) NOT NULL,
	param_name nvarchar(50) NOT NULL,
	param_value nvarchar(50) NOT NULL,
	param_description varchar(50) NOT NULL,
	param_type varchar(50) NOT NULL,
	param_data_type varchar(50) NOT NULL,
	delete_flag varchar(50) NOT NULL,
	source_sys_id nvarchar(50) NOT NULL,
	created_dt smalldatetime NOT NULL,
	created_by varchar(50) NOT NULL,
	modified_dt timestamp NOT NULL,
	modified_by varchar(50) NOT NULL,
	is_restricted nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Table_1 SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Z_2
	(
	param_seq_no nvarchar(50) NOT NULL,
	param_id nvarchar(50) NOT NULL,
	param_cd varchar(50) NOT NULL,
	param_name varchar(50) NOT NULL,
	param_value nvarchar(50) NOT NULL,
	param_description varchar(50) NOT NULL,
	param_type varchar(50) NOT NULL,
	param_data_type varchar(50) NOT NULL,
	delete_flag varchar(50) NOT NULL,
	source_sys_id nvarchar(50) NOT NULL,
	created_dt smalldatetime NOT NULL,
	created_by varchar(50) NOT NULL,
	modified_dt timestamp NOT NULL,
	modified_by varchar(50) NOT NULL,
	is_restricted nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Z_1 SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.Z_1)
	 EXEC('INSERT INTO dbo.Tmp_Z_1 (param_seq_no, param_id, param_cd, param_name, param_value, param_description, param_type, param_data_type, delete_flag, source_sys_id, created_dt, created_by, modified_by, is_restricted)
		SELECT param_seq_no, param_id, param_cd, CONVERT(varchar(50), param_name), param_value, param_description, param_type, param_data_type, delete_flag, source_sys_id, created_dt, created_by, modified_by, is_restricted FROM dbo.Z_1 WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Z_1
GO
EXECUTE sp_rename N'dbo.Tmp_Z_1', N'Z_1', 'OBJECT' 
GO
COMMIT

/*set the minimum records threshold needed for an acceptable sync...*/
insert into dbo.BASE_OBJ_METADATA ( param_seq_no, table_name, MIN_SYNC_CNT ) values('PEDGE2ADM','APP_PARAM_LKP', 50 );

USE pedge2adm;
GRANT SELECT ON dbo_app_param_lkp :: Z_1 TO CDM_READER;
GO

USE pedge2adm;
GRANT SELECT ON dbo_app_param_lkp :: Z_1 TO CDM_READER_PRIVATE;
GO

USE pedge2adm;
GRANT SELECT ON dbo_app_param_lkp :: Z_2 TO CDM_READER;
GO

USE pedge2adm;
GRANT SELECT ON dbo_app_param_lkp :: Z_2 TO CDM_READER_PRIVATE;
GO

/* Create a synonym to point to this object - from the corresponding schema (for the given role*/

use pedge2adm;
GO
CREATE SYNONYM Active
FOR app_param_lkp.Z_1;
GO

use pedge2adm;
GO
CREATE SYNONYM NotActive
FOR app_param_lkp.Z_2;
GO