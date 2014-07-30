
<cfquery name="q_select_reload_settings">
UPDATE
	users
SET
	reloadpermissions = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>