<!--- //

	Module:		Admin/God
	Description:Logout
	
// --->

<cflock scope="session" timeout="3" type="exclusive">
	<cfset StructDelete(session, 'stSecurityContext') />
	<cfset StructDelete(session, 'stUserSettings') />
</cflock>

<cflocation addtoken="false" url="index.cfm">

