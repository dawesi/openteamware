<cfquery name="q_update_posting" datasource="#request.a_str_db_tools#">
UPDATE	
	postings
SET
	postingbody = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.body#">,
	postingbody_plaintext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#striphtml(arguments.body)#">,
	dt_last_updated_by_user = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetUTCTime(Now())#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>