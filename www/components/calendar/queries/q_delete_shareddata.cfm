<cfquery name="q_delete_shared_data" datasource="#request.a_str_db_tools#">
DELETE FROM
	calendar_shareddata 
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>