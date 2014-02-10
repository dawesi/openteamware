
<cfquery name="q_update_user_role" datasource="#request.a_str_db_users#">
UPDATE
	users
SET
	securityrolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rolekey#">
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>