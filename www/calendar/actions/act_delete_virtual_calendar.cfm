<!--- //

	Module:		Calendar
	Action:		DoDeleteVirtualCalendar
	Description:Delete virtual calendar ...
	

// --->

<cfparam name="form.frmentrykey" type="string">
<cfparam name="form.frmdodeleteappointmentsaswell" type="boolean" default="false">

<cfinvoke component="#application.components.cmp_calendar#" method="DeleteVirtualCalendar" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="virtualcalendarkey" value="#form.frmentrykey#">
	<cfinvokeargument name="dodeleteappointmentsaswell" value="#form.frmdodeleteappointmentsaswell#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="default.cfm?action=VirtualCalendars&ibxerrorno=#stReturn.error#">
</cfif>

<cflocation url="default.cfm?action=VirtualCalendars">

