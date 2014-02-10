

<cfquery name="q_delete_shareddata_tasks" datasource="#request.a_str_db_tools#">
DELETE FROM
	tasks_shareddata
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>