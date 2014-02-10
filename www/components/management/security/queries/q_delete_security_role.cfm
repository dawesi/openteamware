
<cfquery name="q_delete_security_role" datasource="#request.a_str_db_users#">
DELETE FROM
	securityroles
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>