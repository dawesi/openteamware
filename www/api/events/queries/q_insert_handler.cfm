<cfquery name="q_insert_handler" datasource="#request.a_str_db_log#">
INSERT INTO
	webservice_event_handlers
	(
	applicationkey,
	clientkey,
	dt_created,
	type,
	href,
	entrykey,
	userkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.handlertype#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.href#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#application.directaccess.securitycontext[arguments.clientkey].myuserkey#">
	)
;
</cfquery>