<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<cfparam name="url.to" default="">
<cfparam name="url.body" default="">
<cfparam name="url.subject" default="">
<cfoutput>
<meta http-equiv="Refresh" content="0;URL=/email/default.cfm?action=ComposeMail&to=#urlencodedformat(url.to)#&subject=#urlencodedformat(url.subject)#&body=#urlencodedformat(url.body)#">
</cfoutput>
	<title>Unbenannt</title>
</head>
<body>
</body>
</html>
