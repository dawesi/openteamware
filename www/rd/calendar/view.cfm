<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<cfparam name="url.Date" default="">
<cfparam name="url.View" default="">

<!--- die toolbar liefert (leider noch) ein datum im format dd.mm.yyyy --->
<cfset tmp = GetLocale()>
<cfset SetLocale("German (Austrian)")>
<cfset Adate = LSParseDateTime(url.date)>

<cfset ADate = DateFormat(ADate, "m/dd/yyyy")>

<cfset SetLocale(tmp)>

<cfoutput>
<meta http-equiv="Refresh" content="0;URL=/calendar/default.cfm?action=ViewDay&date=#urlencodedformat(Adate)#">
</cfoutput>
	<title>Unbenannt</title>
</head>
<body>
</body>
</html>
