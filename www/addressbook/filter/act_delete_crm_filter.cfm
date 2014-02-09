<!--- //

	Module:		AddressBook
	Action:		DeleteCRMFilter
	Description:Delete a stored CRM filter
	

// --->

<cfparam name="url.entrykey" type="string">

<cfinvoke component="#application.components.cmp_crmsales#" method="ClearFilterCriterias" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="viewkey" value="#url.entrykey#">
		<cfinvokeargument name="delete_filter_too" value="true">
</cfinvoke>

<cflocation addtoken="false" url="#ReturnRedirectURL()#">


