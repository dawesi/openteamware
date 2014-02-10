<cfquery name="q_delete_meta_data_tasks_outlook_entrykeys" datasource="#request.a_str_db_tools#">
DELETE FROM
	tasks_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
;
</cfquery>