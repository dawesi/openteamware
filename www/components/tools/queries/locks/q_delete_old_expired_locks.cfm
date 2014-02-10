<!--- //

	Module:		Locks
	Action:		CreateExclusiveLock
	Description: 
	

// --->

<cfquery name="q_delete_old_expired_locks" datasource="#request.a_str_db_tools#">
DELETE FROM
	exclusive_locks
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
	AND
	dt_timeout < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">
;
</cfquery>

