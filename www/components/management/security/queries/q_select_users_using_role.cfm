
<cfquery name="q_select_users_using_role" datasource="#request.a_str_db_users#">
SELECT
	username,entrykey,firstname,surname
FROM
	users
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	securityrolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>