<cfquery name="q_insert_session_data" datasource="#request.a_str_db_users#">
INSERT INTO
	sessionkeys
	(
	id,
	appname,
	ip,
	userkey,
	dt_lastcontact,
	dt_expires
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_timeout)#">
	)
;
</cfquery>