<cfquery name="q_delete_task" datasource="#request.a_str_db_tools#">
DELETE FROM
	tasks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>