<!--- //

	delete outlook meta data ... 
	
	// --->
	
<cfquery name="q_delete_outlook_meta_data" datasource="#request.a_str_db_tools#">
DELETE FROM
	tasks_outlook_data
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>