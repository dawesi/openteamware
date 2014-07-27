<!--- //

	Module:		Calendar
	Action:		subscribe
	Description:Subscribe to public VirtualCalendar
// --->

<cfinclude template="/login/check_logged_in.cfm">

<!--- entry key of the virtual calendar we want to subsscribe into --->
<cfparam name="url.entrykey" type="string" default="">

<cfif len(url.entrykey) is 0>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

<cfinvoke component="#application.components.cmp_calendar#" method="SubscribeToPublicVirtualCalendar" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="virtualcalendarkey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT stReturn.result>
	<cflocation url="index.cfm?action=VirtualCalendars&ibxerrorno=#stReturn.error#">
</cfif>

<cflocation url="index.cfm?action=VirtualCalendars">

