<cfquery name="q_insert_virtual_user" datasource="#request.a_str_db_users#">
INSERT INTO
	virtual_mobilesync_users
	(
	userkey,
	principal_id,
	username,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.principal_id#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_virtual_username#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
	)
;
</cfquery>