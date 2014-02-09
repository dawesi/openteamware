<!--- //

	Module:		Admintool
	Description:Delete a Single Sign On Binding
	
// --->

<cfinvoke component="#application.components.cmp_security#" method="DeleteSwitchUserRelation" returnvariable="ab">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="userkey" value="#url.userkey#">
	<cfinvokeargument name="otheruserkey" value="#url.otheruserkey#">
</cfinvoke>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">


