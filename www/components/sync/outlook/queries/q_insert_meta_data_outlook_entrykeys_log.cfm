<cfquery name="q_insert_meta_data_outlook_entrykeys_log" datasource="#request.a_str_db_log#">
INSERT INTO
	deleted_outlooksync_meta_data
	(
	userkey,
	dt_created,
	servicekey,
	program_id,
	wddx
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCdatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">,
	'#a_str_wddx#'
	)
;
</cfquery>