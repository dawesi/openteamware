<!--- //

	Module:		Locks
	Function.	RemoveTimedOutExclusiveLocks
	Description: 
	

// --->

<cfquery name="q_select_timed_out_locks" datasource="#request.a_str_db_tools#">
SELECT
	objectkey,
	servicekey,
	entrykey,
	userkey
FROM
	exclusive_locks
WHERE
	dt_timeout < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#GetODBCUTCNow()#">
;
</cfquery>

<!--- <cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="q_select_timed_out_locks" type="html">

<cfdump var="#q_select_timed_out_locks#"></cfmail> --->

