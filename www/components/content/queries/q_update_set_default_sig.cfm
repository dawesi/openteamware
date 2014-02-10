<cfquery name="q_update_set_default_sig_1" datasource="#request.a_str_db_tools#">
UPDATE
	email_signatures
SET
	default_sig = 0
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	sig_type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.format#">
;
</cfquery>

<cfquery name="q_update_set_default_sig" datasource="#request.a_str_db_tools#">
UPDATE
	email_signatures
SET
	default_sig = 1
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>