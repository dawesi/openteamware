<cfquery name="q_select_contacts_assigned_to_sales_project" datasource="#request.a_str_db_crm#">
SELECT
	contactkey,
	dt_created,
	contact_type,
	comment,
	role_type,
	internal_user,
	salesprojectentrykey
FROM
	salesprojects_assigned_contacts
WHERE
	salesprojectentrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
ORDER BY
	contact_type,role_type
;
</cfquery>