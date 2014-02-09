<cfinclude template="/login/check_logged_in.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#request.a_Str_component_newsletter#" method="DeleteWaitingIssue" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="no" url="default.cfm">