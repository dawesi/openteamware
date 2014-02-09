<cfquery name="q_update_wireless_status" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	wirelessstatus = 0
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>