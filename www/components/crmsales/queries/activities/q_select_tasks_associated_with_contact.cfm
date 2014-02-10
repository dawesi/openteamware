<cfquery name="q_select_tasks_associated_with_contact" datasource="#request.a_str_db_tools#">
SELECT
	taskkey
FROM
	tasks_assigned_to_contacts
WHERE
	contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#">
;
</cfquery>