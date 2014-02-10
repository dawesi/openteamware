<cfquery name="q_select_event_handlers" datasource="#request.a_str_db_log#">
SELECT
	entrykey,clientkey,applicationkey
FROM
	webservice_event_handlers
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
;
</cfquery>