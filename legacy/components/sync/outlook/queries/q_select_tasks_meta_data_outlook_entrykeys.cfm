<cfquery name="q_select_tasks_meta_data_outlook_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	taskkey,
	outlook_id,
	program_id
FROM
	tasks_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
;
</cfquery>