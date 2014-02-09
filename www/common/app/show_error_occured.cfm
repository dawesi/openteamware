<!--- //

	Module:		Framework
	Description:An error occured - display message ...
	
// --->


<cfset inet = CreateObject("java", "java.net.InetAddress") />
<cfset inet = inet.getLocalHost() />

<cfsetting enablecfoutputonly="no">

<html>
<head>
<LINK REL=stylesheet HREF="/standard.css" TYPE="text/css"> 
	<title>Fehler | Error </title>
</head>
<body style="padding:15px;">
<br/>

<!--- log exception ... --->
<cfset tmp = application.components.cmp_log.LogException(error = arguments.exception,
				session = session,
				message = arguments.exception.RootCause.message,
				url = url,
				form = form,
				cgi = cgi) />
				

<!--- send notify to which address? --->
<cftry>
	<cfset a_int_notify = request.appsettings.properties.EmailReportsEnabled />
	<cfset a_str_notify_email_adr = request.appsettings.properties.NotifyEmail />
	<cfcatch type="any">
		<cfset a_int_notify = 1 />
		<cfset a_str_notify_email_adr = request.appsettings.properties.NotifyEmail />
	</cfcatch>
</cftry>

<cfif a_int_notify IS 1>
<!--- <cfmail to="#a_str_notify_email_adr#" from="feedback@openTeamWare.com" subject="Fehler auf #inet#" type="html">
	<html>
		<head></head>
		<body>
			<h4>host: #inet#</h4>
			<h4>error</h4>
			<cfdump var="#arguments#">
			<h4>request</h4>
			<cfdump var="#request#">
			<h4>cgi</h4>
			<cfdump var="#cgi#">
		</body>
	</html>
</cfmail> --->
</cfif>


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
</body>
</html>




			