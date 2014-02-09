<!--- //

	add activity
	
	// --->
	
<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<!--- load crm binding ... --->

<!--- load comment/notice field --->

<!--- insert data --->
	
<cfmail from="Feedback@openTeamWare.com" to="#request.appsettings.properties.NotifyEmail#" subject="addnotice" type="html">
<cfdump var="#form#">
</cfmail>