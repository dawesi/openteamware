<cfquery name="q_select_task_raw" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	tasks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>