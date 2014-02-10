<cfquery name="q_insert_running_job" datasource="#request.a_str_db_backup#">
INSERT INTO
	datarep_runningjobs
	(
	companykey,
	dt_created,
	jobkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_jobkey#">
	)
;
</cfquery>