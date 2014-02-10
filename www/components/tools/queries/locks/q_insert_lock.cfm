<!--- //

	Module:		Locks
	Function:	CreateExclusiveLock
	Description:Insert a new lock
	

// --->

<cfquery name="q_insert_lock" datasource="#request.a_str_db_tools#">
INSERT INTO
	exclusive_locks
	(
	userkey,
	dt_created,
	dt_timeout,
	entrykey,
	servicekey,
	objectkey,
	comment
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_timeout)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_lock_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">
	)
;
</cfquery>

