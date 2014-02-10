

<cfquery name="q_select_shares" datasource="#request.a_str_db_tools#">
SELECT
	workgroupkey,
	'' AS workgroupname
FROM
	tasks_shareddata
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
AND
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(securitycontext.q_select_workgroup_permissions.workgroup_key)#" list="yes">)
;
</cfquery>