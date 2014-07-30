<!--- //

	Component:	Locks
	Function:	GenerateLockDefaultInformationString
	Description:Select a lock by it's 'entrykey
	
	Header:		

// --->

<cfquery name="q_select_lock_by_entrykey">
SELECT
	userkey,
	dt_created,
	dt_timeout,
	entrykey,
	servicekey,
	objectkey
FROM
	exclusive_locks
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

