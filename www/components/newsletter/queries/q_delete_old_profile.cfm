<cfquery name="q_delete_old_profile" datasource="#request.a_str_db_crm#">
DELETE FROM
	newsletter_profiles
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>