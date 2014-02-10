<cfquery name="q_delete_shareddata_database" datasource="#request.a_str_custom_database#">
DELETE FROM
	shared_databases
WHERE
	databasekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>