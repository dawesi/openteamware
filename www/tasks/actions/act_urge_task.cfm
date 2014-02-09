<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_tasks#" method="UrgeTask" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
</cfinvoke>

<cflocation addtoken="no" url="default.cfm?action=showtask&entrykey=#url.entrykey#">