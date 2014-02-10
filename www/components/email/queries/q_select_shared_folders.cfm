<cfquery name="q_select_shared_folders" datasource="#request.a_str_db_tools#">
SELECT
	folderdata,workgroupkey
FROM
	shareddata_email
WHERE
	workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#ValueList(arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)#">)	
;
</cfquery>