
<cfquery name="q_update_user_roles" datasource="#request.a_str_db_users#">
UPDATE
	workgroup_members
SET
	roles = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.rolekeys#">
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>