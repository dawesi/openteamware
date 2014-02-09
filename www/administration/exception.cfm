<html>
<head>
<title>Untitled Document</title>
</head>
<body>

<img src="/images/img_inboxcc_logo_top.png">
<br><br>
<h4>An error has occured / Ein Fehler ist aufgetreten.
<br>
<br>
The webmaster has been informed.
</h4>

<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="Error in the Administration interface" type="html">

<cfdump var="#error#" label="error">

<cfdump var="#url#" label="url">

<cfdump var="#form#" label="form">

<cfdump var="#session#" label="session">

</cfmail>

<cfif ListFindNoCase('127.0.0.1,85.124.239.104,62.99.232.51,85.126.159.98', cgi.REMOTE_ADDR) GT 0>
	<cfdump var="#error#" label="error">
</cfif>

</body>
</html>