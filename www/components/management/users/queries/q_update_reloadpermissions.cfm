<cfquery name="q_update_reloadpermissions">
UPDATE
	users
SET
	reloadpermissions = 1
WHERE
	entrykey =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>