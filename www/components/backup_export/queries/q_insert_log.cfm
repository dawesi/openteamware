<cfsetting requesttimeout="30000">

<cfquery name="q_insert_log" datasource="#request.a_str_db_backup#">
INSERT INTO
	datarep_log
	(
	companykey,
	userkey,
	dt_created,
	jobkey,
	msg,
	runtime
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_datarep_log_companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_datarep_log_userkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_datarep_log_jobkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.msg#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#(GetTickCount() - request.a_backup_tc_start)#">
	)
;
</cfquery>