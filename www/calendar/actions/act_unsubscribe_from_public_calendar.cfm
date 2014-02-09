<!--- //

	Module:		Calendar
	Action:		unsubscribe
	Description:Unsubscribe from public VirtualCalendar
// --->

<cfinclude template="/login/check_logged_in.cfm">

<!--- entry key of the subscription record --->
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_calendar#" method="UnsubscribeFromPublicVirtualCalendar" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="subscriptionkey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="default.cfm?action=VirtualCalendars&ibxerrorno=#stReturn.error#">
</cfif>

<cflocation url="default.cfm?action=VirtualCalendars">

