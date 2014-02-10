<cfquery name="q_delete_shareddata_storage" datasource="#request.a_str_db_tools#">
DELETE FROM
	directories_shareddata
WHERE
	directorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>