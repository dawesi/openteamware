<cfquery name="q_delete_lock_internally" datasource="#request.a_str_db_tools#">
DELETE FROM
	exclusive_locks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>