<!--- //

	Module:		Admin/God
	Description:Logout
	
// --->

<cflock scope="session" timeout="3" type="exclusive">
	<cfset tmp = StructDelete(session, 'stSecurityContext') />
	<cfset tmp = StructDelete(session, 'stUserSettings') />
</cflock>

<cflocation addtoken="false" url="index.cfm">

