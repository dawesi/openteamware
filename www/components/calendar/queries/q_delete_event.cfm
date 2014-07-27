<cfquery name="q_delete_event" datasource="#request.a_str_db_tools#">
DELETE FROM
	calendar
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>