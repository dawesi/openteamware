<cfquery name="q_select_roles" datasource="#request.a_str_db_users#">
SELECT
	roles
FROM
	workgroup_members
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>