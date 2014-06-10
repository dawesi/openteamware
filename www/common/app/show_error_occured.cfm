<!--- //

	Module:		Framework
	Description:An error occured - display message ...
	
// --->


<cfset inet = CreateObject("java", "java.net.InetAddress") />
<cfset inet = inet.getLocalHost() />

<cfsetting enablecfoutputonly="no">

<html>
<head>
	<LINK REL=stylesheet HREF="/assets/css/default.css" type="text/css" media="all" /> 
	<title>Fehler | Error </title>
</head>
<body style="padding:15px;">
<br/>

<!--- log exception ... --->
<cfset application.components.cmp_log.LogException(error = arguments.exception,
				session = session,
				message = arguments.exception.RootCause.message,
				url = url,
				form = form,
				cgi = cgi) />
				

<h2><img src="/images/si/error.png" /> Wichtige Systemmeldung</h2>
<h4>Ein Fehler ist aufgetreten - der Webmaster wurde soeben benachrichtigt!</h4>
<h4>An error occured - the webmaster has been notified!</h4>
<br />
<br />
Die Fehlermeldung wurden an den Webmaster &uuml;bermittelt - wir versuchen so schnell als m&ouml;glich eine L&ouml;sung zu finden! Wenden Sie sich bei weiteren Fragen bitte an feedback@openTeamWare.com!
<br />
<br />
Vielen Dank!
<br /><br />
<br />
<a href="/" target="_top"><b>Zur Startseite</b></a> | <a href="javascript:history.go(-1);">zur&uuml;ck</a>

<cfif cgi.REMOTE_ADDR IS '127.0.0.1'>
<cfdump var="#arguments#">
</cfif>

</body>
</html>
