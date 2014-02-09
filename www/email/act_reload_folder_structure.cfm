<!--- //

	Module:		E-Mail
	Description:Reload folder structure
	

// --->
<cfinclude template="/login/check_logged_in.cfm">

<cfinvoke component="#request.a_str_component_mailspeed#" method="AddAllFoldersOfUserToWatch" returnvariable="a_bol_Return">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">


