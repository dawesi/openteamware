<!--- //

	Module:		Assignments
	Function:	RemoveAllAssignments
	Description: 
	

// --->

<cfquery name="q_delete_all_assignment">
DELETE FROM
	assigned_items
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">
;
</cfquery>

