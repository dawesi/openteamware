<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<cfinclude template="../style_sheet.cfm">
<cfinclude template="../login/check_logged_in.cfm">
	<title>ACHTUNG</title>
</head>
<body>



<cfif IsDefined("url.confirmed") is false>
Mit dieser Funktion k&ouml;nnen Sie die bisher zwischengespeicherten<br>
Informationen &uuml;ber Ihre Outlook-Daten verwerfen und alles bei einer<br>
neuen Synchronisierung neu &uuml;bertragen lassen.

<br>
<br>
Nutzen Sie diese Funktion ausschlie&szlig;lich wenn Sie dazu aufgefordert wurden!
<br>
<br>
<br>
<a href="show_reset_outlook.cfm?confirmed=1">Aktion jetzt ausf&uuml;hren</a>

<cfelse>

<cfquery name="q_select_outlook_ids" datasource="myAddressbook" dbtype="ODBC">
DELETE FROM adrb_outlook_id WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>

Aktion wurde erfolgreich ausgef&uuml;hrt

</cfif>

</body>
</html>
