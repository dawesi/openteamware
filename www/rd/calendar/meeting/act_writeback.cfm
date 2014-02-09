<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Unbenannt</title>
</head>
<body>
<!--- zur�ckschreiben --->
<cfparam name="form.id" default="">
<cfparam name="form.frmComment" default="">

<cfquery name="q_select_event" datasource="myCalendar" dbtype="ODBC">
SELECT eventid,emailaddress FROM meeting_members where RandomKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id#">;
</cfquery>	

<cfif q_select_event.recordcount is 0>
	<!--- event does not exist any more --->
	Dieser Termin existiert leider nicht mehr und Sie k�nnen auch keine Zu- oder Absage mehr erteilen.
	<cfabort>
</cfif>

<cfquery name="q_Select_cal_event" datasource="myCalendar" dbtype="ODBC">
SELECT title,username FROM calendar
WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_event.eventid#">;
</cfquery>

<cfmail to=#q_Select_cal_event.username# from="KeineAntwortAdresse@openTeamWare.com" subject="Feedback zum Termin #q_Select_cal_event.title#">

Guten Tag!

Soeben ist ein benutzerdefiniertes Feedback zum Termin #q_Select_cal_event.title# eingetroffen:

Absender: #q_select_event.emailaddress#

Text: #form.frmComment#

Klicken Sie fuer weitere Details zu diesem Termin:

http://www.openTeamWare.com/rd/calendar/showentry.cfm?id=#q_select_event.eventid#

------------------------
Ein Service von openTeamWare
</cfmail>


<b>Ihr Feedback wurde �bermittelt!</b>
<br>
<br>
<br>
<b>Wollen Sie diesen Termin in Ihren eigenen Kalender auf openTeamWare aufnehmen?</b><br>
<br>
<a href="addevent.cfm?id=<cfoutput>#urlencodedformat(form.id)#</cfoutput>">Klicken Sie dazu bitte einfach hier</a>
</body>
</html>
