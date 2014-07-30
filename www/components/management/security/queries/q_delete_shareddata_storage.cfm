<cfquery name="q_delete_shareddata_storage">
DELETE FROM
	directories_shareddata
WHERE
	directorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>