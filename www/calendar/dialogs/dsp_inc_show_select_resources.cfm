<!--- //
	Module:            calendar
	Action:            AssignNewElementToAppointment
	Description:       Renders the resources where user can select which ones should be assigned to event
// --->

<cfinvoke component="#application.components.cmp_resources#" method="GetAvailableResources" returnvariable="q_available_resources">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
</cfinvoke>

<table class="table_overview">
	<tr class="tbl_overview_header">
        <td>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_resource')#</cfoutput>
		</td>
		<td>
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>
		</td>
	</tr>
<cfoutput query="q_available_resources">
	<tr>
		<td>
			<input <cfif ListFindNoCase(a_str_assigned_entrykeys, q_available_resources.entrykey) GT 0>checked</cfif> type="checkbox" name="assigned_elements" value="#q_available_resources.entrykey#"/>
		</td>
		<td>
			#htmleditformat(q_available_resources.title)#
		</td>
		<td>
			#htmleditformat(q_available_resources.description)#
		</td>
	</tr>
</cfoutput>
</table>


