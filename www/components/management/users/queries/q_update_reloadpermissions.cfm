<cfquery name="q_update_reloadpermissions" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	reloadpermissions = 1
WHERE
	entrykey =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>