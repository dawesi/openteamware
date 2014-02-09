<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="Framework Error" type="html">
	<cfdump var="#cfcatch#">
</cfmail>

<h4>Eine Datei konnte nicht gefunden werden - der Administrator wurde benachrichtigt.</h4>