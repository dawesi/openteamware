<cfinclude template="../login/check_logged_in.cfm">


<!--- hier findet nur die freischaltung statt ... --->

<cfparam name="url.requestkey" type="string" default="">
<cfparam name="url.username" type="string" default="">
<cfparam name="url.applicationkey" type="string" default="">

<cfif CompareNoCase(url.username, request.stSecurityContext.myusername) NEQ 0>
	<h4>invalid username - plesae logout and login with <cfoutput>#url.username#</cfoutput></h4>
	<br><br>
	<a href="/logout.cfm">Logout now <cfoutput>#request.stSecurityContext.myusername#</cfoutput></a>
	<cfabort>
</cfif>

<!--- check if app is valid or excluded --->

<!--- load application data by component --->
<cfquery name="q_select_app_details" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	webservices_applications
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.applicationkey#">
;
</cfquery>

<html>
<head>
<title>openTeamWare</title>
<cfinclude template="../style_sheet.cfm">
</head>

<body style="padding:40px;text-align:center;">
<font style="text-transform:uppercase;font-size:12px; ">
<img src="/images/img_inboxcc_logo_top.png" align="absmiddle"><br>
<br>
&nbsp;&nbsp;<b>Anwendung freischalten f&uuml;r DirectAccess</b>
</font>
<!---<cfdump var="#q_select_app_details#" expand="no">--->
<br><br>
<table border="0" cellspacing="0" cellpadding="10">
	<tr>
		<td  class="b_all mischeader">
			<b>Anwendungsinformationen</b>
			<br>
			<cfoutput query="q_select_app_details">
				Name: #q_select_app_details.appname#
				<br>
				Beschreibung: #q_select_app_details.description#
				<br>
				Hersteller: #q_select_app_details.producer#
				<br>
				Kontakt: #q_select_app_details.contact#
			</cfoutput>
		</td>
	</tr>
  <tr>
  	<form action="act_enable_access.cfm?<cfoutput>#cgi.QUERY_STRING#</cfoutput>" method="post">
    <td class="bb bl br">
		Ja, diese Applikation soll direkt auf meine Daten zugreifen und sie auch editeren koennen.
		<br>
		<input type="submit" value="Zugriff erlauben" style="font-weight:bold;padding:4px;">
		<br><br>
		Sie k&ouml;nnen die Einstellung sp&auml;ter in den Einstellungen jederzeit aendern.
	</td>
	</tr>
	<tr>
	<td class="bb bl br">
		<a href="act_decline.cfm?<cfoutput>#cgi.QUERY_STRING#</cfoutput>">Nein, ich moechte nicht dass diese Anwendung direkt auf meine Daten zugreifen darf.</a>
	</td>
	
	</form>
  </tr>
</table>





</body>
</html>
