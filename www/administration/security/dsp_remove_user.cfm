<!--- //

	remove an user from a security role
	
	// --->
	
<cfparam name="url.rolekey" type="string" default="">
<cfparam name="url.userkey" type="string" default="">

<cfinvoke component="#application.components.cmp_security#" method="ApplyRoleToUser" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#url.userkey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="rolekey" value="">
</cfinvoke>

<cflocation addtoken="no" url="#ReturnRedirectURL()#">