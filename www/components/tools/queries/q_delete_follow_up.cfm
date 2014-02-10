<cfquery name="q_delete_follow_up" datasource="#request.a_str_db_tools#">
DELETE FROM
	followups
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>