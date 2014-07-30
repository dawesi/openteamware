<!--- //

	Module:		Locks
	Function;	ExclusiveLockExistsForObject
	Description:Check if a lock exists for a certain object
	

// --->

<cfquery name="q_select_lock">
SELECT
	userkey,
	dt_created,
	dt_timeout,
	entrykey,
	servicekey,
	objectkey,
	comment
FROM
	exclusive_locks
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
	AND
	dt_timeout > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">
;
</cfquery>

