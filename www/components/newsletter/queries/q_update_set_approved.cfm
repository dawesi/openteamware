<cfquery name="q_update_set_approved" datasource="#request.a_str_db_crm#">
UPDATE
	newsletter_issues
SET
	approved = 1,
	dt_approved = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateODBCDateTime(GetUTCTime(Now()))#">,
	approvedbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issuekey#">
	AND
	createdbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery> 