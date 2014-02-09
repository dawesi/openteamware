<!--- //

	delete tasks
	
	// --->
	


<!---<cfinvoke component="components/cmp_delete_tasks" method="DeleteTasks" returnvariable="a_bol_return">
	<cfinvokeargument name="program_id" value="#form.program_id#">
	<cfinvokeargument name="outlook_ids" value="#form.outlook_ids#">
	<cfinvokeargument name="userid" value="#request.stSecurityContext.myuserid#">
</cfinvoke>--->

<!--- call central component ... --->

<cfloop list="#form.outlook_ids#" delimiters="," list="sEntrykey">

</cfloop>