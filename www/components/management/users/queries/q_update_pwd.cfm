
<cfquery name="q_update_pwd">
UPDATE
	users
SET
	pwd = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>