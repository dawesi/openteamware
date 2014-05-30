<cfquery name="q_update_profile_set_inivisible">
UPDATE
	newsletter_profiles
SET
	hidden_profile = 1
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>