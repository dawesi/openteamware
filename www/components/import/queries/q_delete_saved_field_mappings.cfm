<!--- //

	Module:		Import
	Function:	DeleteFieldMappingsOfJob
	Description: 
	

// --->

<cfquery name="q_delete_saved_field_mappings">
DELETE FROM
 	importfieldmappings
WHERE
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">
;
</cfquery>

