<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body onLoad="document.formverifymessage.submit();">
<form action="http://127.0.0.1:17600/cgi-bin/message.verify.status" method="get" name="formverifymessage">
<input type="hidden" name="userkey" value="<cfoutput>#request.stSecurityContext.myuserkey#</cfoutput>">
<input type="hidden" name="jobkey" value="<cfoutput>#url.jobkey#</cfoutput>">
</form>

</body>
</html>
