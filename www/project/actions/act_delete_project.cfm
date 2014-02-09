<!--- //

	Module:		Projects
	Action:		DoDeleteProject
	Description:Delete a whole project
	

// --->

<cfparam name="url.entrykey" type="string">

<cfinvoke component="#application.components.cmp_projects#" method="DeleteProject" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">

