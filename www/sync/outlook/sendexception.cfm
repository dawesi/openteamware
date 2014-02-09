

<!--- //

	send a report
	
	// --->
	
<!--- set an error header --->
<cfheader statuscode="500" statustext="Server Error">
	
<cfmail from="webmaster@openTeamWare.com" to="#request.appsettings.properties.NotifyEmail#" subject="OutlookSync Exception" type="html">
<html>
	<head>
	</head>
<body>
<h4>error</h4>
<cfdump var="#error#">
<hr>
<h4>request</h4>
<cfdump var="#request#">
<h4>cgi</h4>
<cfdump var="#cgi#">
</body>
</html>
</cfmail>

