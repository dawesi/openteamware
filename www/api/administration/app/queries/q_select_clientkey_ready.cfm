<cfquery name="q_select_clientkey_ready" datasource="#request.a_str_db_users#">
SELECT
	clientkey
FROM
	webservices_enabled_applications
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requestkey#">
	AND
	applicationkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationkey#">
	AND
	status = 1
	AND
	enabled = 1
;
</cfquery>