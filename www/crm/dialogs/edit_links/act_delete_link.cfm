<!--- //

	delete a link
	
	// --->
	
<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_tools#" method="DeleteElementLink" returnvariable="ab">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">