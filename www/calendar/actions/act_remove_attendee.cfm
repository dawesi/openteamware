<!--- //
	Module:		Calendar
	Action:		RemoveAssignedElementFromAppointment
	Description:remove selected resource/contact or workmate from the event
	

	
// --->

<cfparam name="url.eventkey" type="string">
<cfparam name="url.type" type="numeric">
<cfparam name="url.parameter" type="string">

<cfinvoke component="#application.components.cmp_calendar#" method="DeleteAttendeeFromEvent" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="eventkey" value="#url.eventkey#">
	<cfinvokeargument name="type" value="#url.type#">
	<cfinvokeargument name="parameter" value="#url.parameter#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="index.cfm?action=DisplayAssignedElements&entrykey=#url.eventkey#&ibxerrorno=#stReturn.error#">
</cfif>

<cflocation url="index.cfm?action=DisplayAssignedElements&entrykey=#url.eventkey#">

