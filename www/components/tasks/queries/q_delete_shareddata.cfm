<!--- //

	delete shareddata items
	
	// --->
	
<cfquery name="q_delete_shareddata">
DELETE FROM
	tasks_shareddata
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>