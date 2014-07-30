<cfquery name="q_delete_task">
DELETE FROM
	tasks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>