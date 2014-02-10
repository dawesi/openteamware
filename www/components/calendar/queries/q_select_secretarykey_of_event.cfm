<cfquery name="q_select_secretarykey_of_event" datasource="#request.a_str_db_tools#">
SELECT
	createdbysecretarykey
FROM
	calendar
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>