<!--- //

	Module:		resources
	function:	deleteresource
	Description: 
	

// --->

<cfquery name="q_delete_resource" datasource="#request.a_str_db_tools#">
DELETE FROM
	resources
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>


