

<cfquery name="q_delete_shareddata_email" datasource="#request.a_str_db_tools#">
DELETE FROM
	shareddata_email
WHERE
	folderdata = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>