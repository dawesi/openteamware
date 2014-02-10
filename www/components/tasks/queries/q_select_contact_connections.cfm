<cfquery name="q_select_contact_connections" datasource="#request.a_str_db_tools#">
SELECT
	contactkey
FROM
	tasks_assigned_to_contacts
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>