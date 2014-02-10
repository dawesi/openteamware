<cfquery name="q_select_event_raw" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	calendar
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>