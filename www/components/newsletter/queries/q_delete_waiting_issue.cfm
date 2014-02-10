<cfquery name="q_delete_waiting_issue" datasource="#request.a_str_db_crm#">
DELETE FROM
	newsletter_issues
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>