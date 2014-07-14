
<cfquery name="q_insert_request" datasource="#request.a_str_db_users#">
INSERT INTO
	webservices_enabled_applications
	(
	entrykey,
	userkey,
	applicationkey,
	dt_created,
	status
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_request_key#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<!--- in progress ... --->
	-1
	)
;
</cfquery>