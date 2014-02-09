<html>
<head>
<style>
	td,body,p,td,input,textarea{font-family:Verdana;font-size:11px;}
</style>
	<title>Termin</title>
</head>
<body>

<!--- zurückschreiben --->
<cfparam name="url.id" default="">

<cfquery name="q_select_event" datasource="myCalendar" dbtype="ODBC">
SELECT eventid FROM meeting_members where RandomKey = '#url.id#';
</cfquery>	

<cfif q_select_event.recordcount is 0>
	<!--- event does not exist any more --->
	Dieser Termin existiert leider nicht mehr und Sie können auch keine Zu- oder Absage mehr erteilen.
	<cfabort>
</cfif>

<cfquery name="q_Select_cal_event" datasource="myCalendar" dbtype="ODBC">
SELECT title,username FROM calendar
WHERE id = '#q_select_event.eventid#';
</cfquery>

<h4>Benutzerdefiniertes Feedback zum Termin <cfoutput>#q_Select_cal_event.title#</cfoutput></h4>
<form action="act_writeback.cfm" method="post">
<input type="Hidden" name="id" value="<cfoutput>#url.id#</cfoutput>">

<table border="0" cellspacing="0" cellpadding="2">
<tr>
	<td>Termin:</td>
	<td><cfoutput>#q_Select_cal_event.title#</cfoutput></td>
</tr>
<tr>
	<td valign="top">Ihr Text:</td>
	<td><textarea cols="30" rows="10" name="frmComment"></textarea></td>
</tr>
<tr>
	<td></td>
	<td><input type="Submit" name="frmSubmit" value="Absenden"></td>
</tr>
</table>
</form>

</body>
</html>