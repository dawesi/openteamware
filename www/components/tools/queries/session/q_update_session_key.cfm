<cfquery name="q_update_session_key" datasource="#request.a_str_db_users#">
UPDATE
	sessionkeys
SET
	hitcount = hitcount + 1,
	dt_expires = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(a_dt_timeout)#">,
	dt_lastcontact = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(Now())#">
WHERE
	appname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationname#">
	AND
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">
	AND
	ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip#">
;
</cfquery>