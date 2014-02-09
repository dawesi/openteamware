<cfset a_int_runtime = GetTickCount() - request.a_tc_begin>

<cfquery name="q_uptime_runtime" datasource="#request.a_str_db_log#">
UPDATE
	webservices_log
SET
	runtime = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_runtime#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_request_uuid#">
;
</cfquery>