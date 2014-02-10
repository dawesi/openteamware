
<cfquery name="q_delete_workgroup_member" datasource="#request.a_str_db_users#">
DELETE FROM
	workgroup_members
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>