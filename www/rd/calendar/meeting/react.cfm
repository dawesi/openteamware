<!--- // zustimmung zumailen // --->
<!--- // id ... uuid ... // --->
<cfparam name="url.id" default="0">
<cfparam name="url.status" default="0">
<cfparam name="url.eventid" default="0">
<cfparam name="url.email" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<cfinclude template="../../../style_sheet.cfm">
	<title>Kalender</title>
</head>
<body>

<cfinclude template="../../../content/static/common/header_top.html">

<!--- 2 possibilities ...

	a) id is the auto-generated id that points to an entry in the meeting_members table
	b) just eventid and email address ... compose an email --->


<cfquery name="q_select_event">
SELECT eventid,emailaddress FROM meeting_members
WHERE RandomKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">;
</cfquery>

<cfif q_select_event.recordcount is 0>
	<!--- event does not exist any more --->
	Dieser Termin existiert leider nicht mehr und Sie k�nnen auch keine Zu- oder Absage mehr erteilen.
	<cfabort>
</cfif>

<cfquery name="q_select_cal_event">
SELECT username,title FROM calendar
WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_event.eventid#">;
</cfquery>

<cfquery name="q_update">
UPDATE meeting_members
SET status = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.status)#">,
dt_react = current_timestamp
WHERE Randomkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.id#">
</cfquery>

<cfif url.status is 1>
	<cfset ASubject = "Zusage">
<cfelse>
	<cfset ASubject = "Absage">
</cfif>

<cfmail
	to="#q_select_cal_event.username#"
	from="KeineAntwortAdresse@openTeamWare.com"
	subject="#ASubject# zum Termin #q_select_cal_event.title# von #q_select_event.emailaddress# eingetroffen">

Guten Tag!

Soeben ist eine #ASubject# von #q_select_event.emailaddress# zum Termin
#q_select_cal_event.title# eingetroffen.

Klicken Sie fuer weitere Details zu diesem Termin:

http://www.openTeamWare.com/rd/calendar/showentry.cfm?id=#q_select_event.eventid#

------------------------
Ein Service von openTeamWare
</cfmail>


<!---<cfmodule template="mod_update_inviste_status.cfm"
	id = #url.id#
	status = 1>--->

<blockquote>
Danke fuer Ihre Reaktion - Sie wurde dem Termin-Eintragenden mitgeteilt!
<br>
<br>
<br>
<b>Wollen Sie diesen Termin in Ihren eigenen Kalender auf openTeamWare.com aufnehmen?</b><br>
<br>
<a target="_top" href="addevent.cfm?id=<cfoutput>#urlencodedformat(url.id)#</cfoutput>">Klicken Sie dazu bitte einfach hier</a>
<br>
<br><br>

<b>Sie haben noch kein kostenloses openTeamWare.com Konto?</b><br>
<br>
<a target="_top" href="/signup/">Dann holen Sie sich jetzt hier eines</a>!
</blockquote>
</body>
</html>
