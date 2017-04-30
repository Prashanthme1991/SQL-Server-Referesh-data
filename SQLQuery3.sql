/*
File:        

Desc:     Taken from...

Note:    
                                
Author: 
*/
use pedge2adm;

-- VIEW for internal usage;  Used for directly referencing EDW (to pull data over - i.e. contains the business rules to filter with)

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/

CREATE VIEW r_app_param_lkp
as 
   select * from openquery( oraprod,  'select * from team.app_param_lkp') ;
;


/* Creating a new table Z_1_app_param_lkp*/

Select * into dbo.Z_1_app_param_lkp from openquery( oraprod,  'select * from team.app_param_lkp') ;


/* Creating a new table Z_2_app_param_lkp*/


Select * into dbo.Z_2_app_param_lkp from openquery( oraprod,  'select * from team.app_param_lkp') ;


/*set the minimum records threshold needed for an acceptable sync...*/

GRANT Select on dbo.app_param_lkp to public;


/* Create a synonym to point to this object - from the corresponding schema (for the given role*/

use pedge2adm;
GO
CREATE SYNONYM dbo.sync_app_param_lkp
FOR dbo.Z_1_app_param_lkp;
GO

use pedge2adm;
GO
CREATE SYNONYM dbo.nact_app_param_lkp
FOR dbo.Z_2_app_param_lkp;
GO