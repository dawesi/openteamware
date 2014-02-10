<cfquery name="q_insert_connection" datasource="#request.a_str_db_crm#">
INSERT INTO
	connecteditems
	(
	projectkey,
	objectkey,
	servicekey,
	objecttype,
	createdbyuserkey,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objecttype#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">
	)
;
</cfquery>