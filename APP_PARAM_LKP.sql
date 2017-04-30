/*
File:	CDM/all/emp_phones.sql

Desc:	Taken from EDW.V_EMPEE_CAMPUS_TELE_HIST@dsprod01.uis.edu

		tele_primary_ind  { Y, N } : [Y] if entry is the designated primary phone;
		unlisted_ind { Y, N } : [Y] if phone is to be unlisted;

Note:	
		uis_edw.emp_phones - is set of listed phones;
		uis_edw.emp_phones_ALL - includes unlisted set;
		
Author: Vern Huber
*/
-- VIEW for internal usage;  Used for directly referencing EDW (to pull data over - i.e. contains the business rules to filter with)
create or replace view  app_param_lkp
as 
   select *  from EDW.APP_PARAM_LKP@dsprod01.uis.edu
;

-- Create initial tables (to be used in swap)...
create table uis_edw.Z_1_APP_PARAM_LKP NOLOGGING  as select * from uis_edw.z_1_app_param_lkp ;
-- truncate table uis_edw.z_1_emp_phones;
create table uis_edw.Z_2_APP_PARAM_LKP  NOLOGGING  as select * from uis_edw.z_2_app_param_lkp ;

-- ...indexes
/*create index uis_edw.z_1_emp_phones_PERS_ID		ON uis_edw.z_1_emp_phones ( edw_pers_id )  NOLOGGING;
create index uis_edw.z_2_emp_phones_PERS_ID		ON uis_edw.z_2_emp_phones ( edw_pers_id )  NOLOGGING;*/

-- Create synonym used to point to the first table 
create or replace  synonym  uis_edw.SYN_APP_PARAM_LKP for uis_edw.z_1_app_param_lkp;

-- Create synonym used to point to the second table
create or replace synonym uis_edw.SYN_APP_PARAM_LKP for uis_edw.z_2_app_param_lkp;

/*-- VIEW for listed phones only;
create or replace view  uis_edw.emp_phones
as 
   select  *  from  uis_edw.syn_emp_phones  where unlisted_ind != 'Y'
;

-- VIEW for un/listed phones (all);
create or replace view  uis_edw.EMP_PHONES_ALL
as 
   select  *  from  uis_edw.syn_emp_phones
;*/

-- ...set the minimum records threshold needed for an acceptable sync...
insert into uis_edw.BASE_OBJ_METADATA ( owner, table_name, MIN_SYNC_CNT )  values('UIS_EDW', 'APP_PARAM', 50000 );

-- ...as well as schedule the sync job for the object:  datafeeds/refresh_util/cdm_sync_schedule.sql

-- ...you should now be able to run:  exec uis_edw.refresh_util.refresh_object( 'UIS_EDW', 'EMP_PHONES' );

-- Give read access to private role(s)  (Note: Unlisted phones are private only);
grant select on uis_edw.app_param_lkp  to CDM_READER;
grant select on uis_edw.app_param_lkp  to CDM_READER_PRIVATE;
--
grant select on uis_edw.app_param_lkp  to CDM_READER_PRIVATE;

-- Create a synonym to point to this object - from the corresponding schema (for the given role).
create or replace  synonym  uis_cdm.app_param_lkp  for uis_app_param_lkp;
create or replace  synonym  uis_cdm_app_param_lkp  for uis_app_param_lkp;
--
create or replace  synonym  uis_cdm_pvt.app_param_lkp  for uis_edw.app_param_lkp;
