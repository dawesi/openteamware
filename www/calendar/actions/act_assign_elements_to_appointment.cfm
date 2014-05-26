<!--- //
	Module:		Calendar
	Action:		DoAssignElementsToAppointment
	Description:assign resources/contacts or workmates that has been selected to event
	

	
// --->

<cfparam name="form.frmentrykey" type="string">
<cfparam name="form.frmtype" type="numeric">
<cfparam name="form.assigned_elements" type="string" default="">

<!--- assign all selected elements to event --->
<cfloop list="#form.assigned_elements#" delimiters="," index="a_str_parameter">
	<cfinvoke component="#application.components.cmp_calendar#" method="AddAttendeeToEvent" returnvariable="stReturn">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="eventkey" value="#form.frmentrykey#">
		<cfinvokeargument name="type" value="#form.frmtype#">
		<cfinvokeargument name="parameter" value="#a_str_parameter#">
	</cfinvoke>
</cfloop>

<cflocation url="index.cfm?action=DisplayAssignedElements&entrykey=#form.frmentrykey#">

