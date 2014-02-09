
<cfquery name="q_select_reload_settings" datasource="#request.a_str_db_users#">
SELECT
	reloadpermissions
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>