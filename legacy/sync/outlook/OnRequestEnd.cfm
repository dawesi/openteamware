<!---

	--->
	
<cfset a_int_runtime = GetTickCount() - request.a_tick_start>

<cfquery name="q_update_runtime" datasource="#request.a_str_db_log#">
UPDATE
	outlooksync_app
SET
	runtime = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_runtime#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_request_entrykey#">
;
</cfquery>