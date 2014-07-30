<cfquery name="q_delete_lock_internally">
DELETE FROM
	exclusive_locks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>