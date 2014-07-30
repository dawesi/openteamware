<!--- //

	Component:	Assignments
	Function: 	GetAssignments
	Description:Load assignments
	
				Add a virtual column for displayname of assigned employee
				
	

// --->
<cfif Len(arguments.objectkeys) IS 0>
	<cfset arguments.objectkeys = '123' />
</cfif>

<cfquery name="q_select_assignments">
SELECT
	dt_created,
	objectkey,
	userkey,
	createdbyuserkey,
	comment,
	'' AS displayname
FROM
	assigned_items
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">
	AND
	objectkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkeys#" list="yes">)
;
</cfquery>

