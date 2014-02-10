<cfquery name="q_insert_job_done" datasource="#request.a_str_db_backup#">
INSERT INTO
	datarep_backups
	(
	entrykey,
	dt_started,
	dt_end,
	datasize,
	description,
	companykey,
	taroutput
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_jobkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(stReturn.start)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_bigint" value="#a_int_datasize#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_tar_output#">
	)
;
</cfquery>