<cfquery name="q_select_clientkey_already_issued" datasource="#request.a_str_db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	webservices_enabled_applications
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">
	AND
	applicationkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">
	AND
	<!--- already started --->
	status = 1
;
</cfquery>