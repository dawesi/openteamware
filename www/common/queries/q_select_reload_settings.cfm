
<cfquery name="q_select_reload_settings">
SELECT
	reloadpermissions
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>