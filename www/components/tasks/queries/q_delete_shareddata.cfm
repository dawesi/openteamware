<!--- //

	delete shareddata items
	
	// --->
	
<cfquery name="q_delete_shareddata" datasource="#request.a_str_db_tools#">
DELETE FROM
	tasks_shareddata
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>