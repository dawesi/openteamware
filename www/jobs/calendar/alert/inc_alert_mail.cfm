

<cftry>
<cfmail to="#q_select_open_alerts.remind_email_adr#" subject="Terminerinnerung an #htmleditformat(q_select_open_alerts.eventtitle)#" from="openTeamWare (automatische Nachricht) <KeineAntwortAdresse@openTeamWare.com>">
<cfmailparam name="X-Message-Type" value="openTeamWare-Notification">
<cfmailparam name="X-Message-Notification-Service" value="Calendar">
<cfmailparam name="X-Message-Notification-Entrykey" value="#htmleditformat(q_select_open_alerts.eventkey)#">
<cfmailparam name="X-Message-Notification-Parameters" value="">
--- Terminerinnerung ---

Der Termin #htmleditformat(q_select_open_alerts.eventtitle)# startet am #DateFormat(q_select_open_alerts.eventstart, 'ddd, dd.mm.yy')# um #TimeFormat(q_select_open_alerts.eventstart, 'HH:mm')#!

Klicken Sie bitte hier um weitere Details zu diesem Eintrag abzurufen:

https://www.openTeamWare.com/rd/c/e/?#urlencodedformat(q_select_open_alerts.eventkey)#

Ihr openTeamWare Team
</cfmail>

<cfcatch type="any"></cfcatch>
</cftry>