<!--- //

	Module:		resources
	function:	deleteresource
	Description: 
	

// --->

<cfquery name="q_delete_resource">
DELETE FROM
	resources
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>


