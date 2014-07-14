<cfquery name="q_select_userkey_by_clientkey" datasource="#request.a_str_db_users#">
SELECT
	userkey
FROM
	webservices_enabled_applications
WHERE
	clientkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.clientkey#">
;
</cfquery>