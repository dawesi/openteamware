


<cfquery name="q_delete_shareddata_addressbook" datasource="#request.a_str_db_tools#">
DELETE FROM
	shareddata
WHERE
	addressbookkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>