<!--- //

	Module:		Project
	Action:		DeleteProject
	
// --->

<cfquery name="q_delete_project" datasource="#request.a_str_db_crm#">
DELETE FROM
	projects
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>