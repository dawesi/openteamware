
<cfquery name="q_select_securityrolekey_of_user" datasource="#request.a_str_db_users#">
SELECT
	securityrolekey
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>