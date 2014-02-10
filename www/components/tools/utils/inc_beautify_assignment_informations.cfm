<!--- //

	Module:		Assignments
	Function:	Getassignments
	Description:Beautify output, especially set displayname
	

// --->

<cfloop query="q_select_assignments">
	<cfset tmp = QuerySetCell(q_select_assignments, 'displayname', application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_assignments.userkey), q_select_assignments.currentrow) />
</cfloop>


