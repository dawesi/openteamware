<!--- //

	Module:		Framework
	Description:Startpage

// --->

<cfif StructKeyExists(request, 'stSecurityContext')>
  <!--- user is logged in ... forward ... --->
  <cflocation addtoken="no" url="crm/" />

<cfelse>
	<!--- forward to homepage ... --->
	<cflocation addtoken="no" url="/login/">
</cfif>