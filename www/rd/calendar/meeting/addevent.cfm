<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Unbenannt</title>
</head>
<body>

<!--- add this event to the local calendar --->

<cfparam name="url.id" default="0">

<!--- daten zum event laden ---->
<cfquery name="q_select" debug datasource="myCalendar" dbtype="ODBC">
SELECT userid,title,location,date_Start,date_end,description FROM calendar
WHERE ID = (SELECT eventid FROM meeting_members WHERE RandomKey = '#url.id#');
</cfquery>

<cfif q_select.recordcount is 0>
<b>Event nicht gefunden</b><cfabort>
</cfif>

<cfquery name="q_select_utcdiff" datasource="inboxccusers" dbtype="ODBC">
SELECT utcdiff FROM users WHERE userid = #q_select.userid#;
</cfquery>

<cfset AStartDate = DateAdd("h", -q_select_utcdiff.utcdiff, q_select.date_start)>
<cfset AEndDate = DateAdd("h", -q_select_utcdiff.utcdiff, q_select.date_end)>

<cflocation addtoken="No" url="../../../calendar/default.cfm?action=NewEvent&title=#urlencodedformat(q_select.title)#&description=#urlencodedformat(q_select.description)#&Date=#urlencodedformat(dateformat(AStartDate, "mm/dd/yyyy"))#&StartHour=#hour(AStartDate)#&StartMinutes=#minute(AStartDate)#&FullDateTimeend=#urlencodedformat(dateformat(AEndDate, "mm/dd/yyyy")&" "&timeformat(AEndDate, "HH:mm"))#">

</body>
</html>
