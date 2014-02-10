<cfquery name="q_select_shares" datasource="#request.a_str_db_crm#">
SELECT
	directories_shareddata.workgroupkey,
	<!--- select the parentkey too --->
	directories.parentdirectorykey,
	'' AS workgroupname
FROM
	directories_shareddata
LEFT JOIN directories
	ON (directories_shareddata.directorykey = directories.entrykey)
WHERE
	directories_shareddata.directorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
AND
	directories_shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(securitycontext.q_select_workgroup_permissions.workgroup_key)#" list="yes">)
;
</cfquery>