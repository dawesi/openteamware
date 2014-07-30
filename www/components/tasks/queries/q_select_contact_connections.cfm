<cfquery name="q_select_contact_connections">
SELECT
	contactkey
FROM
	tasks_assigned_to_contacts
WHERE
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>