<!--- //

	log the exception
	
	// --->
	
<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="syncml exception" type="html">
	<cfdump var="#error#">
	<cfdump var="#cgi#">
	<cfdump var="#url#">
</cfmail>

<!--- TODO log to default exception logger! --->

<cfheader statuscode="500" statustext="Internal server error">