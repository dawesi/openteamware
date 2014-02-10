<!--- //

	Module:		Resources
	Function:	DoesResourceExists
	Description:Check if a resource with the given entrykey exists at all
	

// --->

<cfquery name="q_select_resource_exists" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	resources
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">
;
</cfquery>

