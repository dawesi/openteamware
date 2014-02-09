<!--- //

	Module:		Calendar
	Description:Load certain display properties ...
	

// --->


<cfsilent>
	
<cfset request.a_bol_display_show_private_events = GetUserPrefPerson('calendar', 'display.includeview.privateevents', 'true', '', false) />
	
<!--- check workgroup display properties ... --->
<cfset request.a_str_display_show_workgroup_events = ''>

<cfloop query="request.stSecurityContext.q_select_workgroup_permissions">
		
	<cfset a_bol_display_show_workgroup_events = GetUserPrefPerson('calendar', 'display.includeview.workgroups.#request.stSecurityContext.q_select_workgroup_permissions.workgroup_key#', '', '', false) />
		
	<cfif a_bol_display_show_workgroup_events IS TRUE>
		<cfset request.a_str_display_show_workgroup_events = ListPrepend(request.a_str_display_show_workgroup_events, request.stSecurityContext.q_select_workgroup_permissions.workgroup_key)>
	</cfif>

</cfloop>


</cfsilent>

