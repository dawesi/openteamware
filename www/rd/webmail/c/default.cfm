<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<!--- confirm --->
<cfparam name="url.email" type="string" default="">
<cfparam name="url.code" type="string" default="">

<cfoutput>
<meta http-equiv="Refresh" content="0;URL=/settings/default.cfm?action=confirmexternalemailaddress&email=#urlencodedformat(url.email)#&code=#urlencodedformat(url.code)#">
</cfoutput>
	<title>Unbenannt</title>
</head>
<body>
</body>
</html>
