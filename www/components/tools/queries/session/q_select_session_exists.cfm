<cfquery name="q_select_session_exists" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	sessionkeys
WHERE
	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sessionkey#">
	AND
	ip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ip#">
	AND
	appname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationname#">
;
</cfquery>