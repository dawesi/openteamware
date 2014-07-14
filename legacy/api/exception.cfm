

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="exception on webservices.openTeamware.com" type="html">
	<cfdump var="#error#">
</cfmail>