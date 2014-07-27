<cfquery name="q_delete_outlook_meta_data" datasource="#request.a_str_db_tools#">
DELETE FROM
	calendar_outlook_data
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>