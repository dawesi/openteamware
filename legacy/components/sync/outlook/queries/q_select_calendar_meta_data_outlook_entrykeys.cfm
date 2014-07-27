<cfquery name="q_select_calendar_meta_data_outlook_entrykeys" datasource="#request.a_str_db_tools#">
SELECT
	eventkey,
	program_id,
	outlook_id
FROM
	calendar_outlook_data
WHERE
	program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.program_id#">
;
</cfquery>