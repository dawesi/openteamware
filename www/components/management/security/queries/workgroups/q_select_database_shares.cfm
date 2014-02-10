<cfquery name="q_select_shares" datasource="#request.a_str_custom_database#">
SELECT
	workgroupkey,
	'' AS workgroupname
FROM
	shared_databases
WHERE
	databasekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
AND
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(securitycontext.q_select_workgroup_permissions.workgroup_key)#" list="yes">)
;
</cfquery>