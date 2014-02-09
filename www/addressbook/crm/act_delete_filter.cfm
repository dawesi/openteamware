<!--- //

	Module:		Address Book
	Description:Delete a filter definition
	
// --->
<cfinclude template="../../login/check_logged_in.cfm">

<cfinvoke component="#application.components.cmp_crmsales#" method="ClearFilterCriterias" returnvariable="a_bol_return">
		<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
		<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
		<cfinvokeargument name="viewkey" value="#url.entrykey#">
		<cfinvokeargument name="delete_filter_too" value="true">
</cfinvoke>	

<cflocation addtoken="no" url="#ReturnRedirectURL()#">

