<!--- //

	Module:        Import
	Description:   Select field mappings
	

// --->
<cfquery name="q_select_field_mappings" datasource="#request.a_str_db_tools#">
SELECT 
	jobkey,
	ibxfield_md5,
	importfieldname
FROM 
	importfieldmappings 
WHERE
	jobkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">
;
</cfquery>

