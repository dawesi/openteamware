<!--- //

	Module:		
	Action:		DeleteHistoryItem
	Description:	
	

// --->

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_crmsales#" method="DeleteHistoryItem" returnvariable="a_struct_delete">
<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">
