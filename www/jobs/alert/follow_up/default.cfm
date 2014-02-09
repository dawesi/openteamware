<!--- dt_due = today --->
<cfset a_int_day = DateFormat(Now(), 'yyyymmdd')>

<cfquery name="q_select" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	followups
WHERE
	done = 0
	AND
	alert_email_done = 0
	AND
	alert_email = 1
	AND
	dt_due < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
	
	<!---DATE_FORMAT(dt_due, '%Y%m%d') < <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_day#">--->
;
</cfquery>

<cfoutput>#q_select.recordcount#</cfoutput>

<cfif q_select.recordcount IS 0>
	<cfabort>
</cfif>

<cfset variables.a_cmp_fup = CreateObject('component', request.a_str_component_followups)>

<cfloop query="q_select">

<cftry>
<cfmail from="KeineAntwortAdresse@openTeamWare.com" to="#application.components.cmp_user.GetUsernamebyentrykey(q_select.userkey)#" subject="Erinnerung: #q_select.objecttitle# / Nachverfolgung">
Guten Tag!

Dies ist eine Erinnerung an einen Nachverfolgungsauftrag.

Titel: #q_select.objecttitle#
Kommentar: #q_select.comment#
Typ: <cfswitch expression="#q_select.followuptype#">
				<cfcase value="0">Nachverfolgung</cfcase>
				<cfcase value="1">E-Mail</cfcase>
				
				<cfcase value="2">Anruf</cfcase>
				<cfcase value="3">Brief schreiben</cfcase>
</cfswitch>
Faellig: #DateFormat(q_select.dt_due, 'dd.mm.yy')# #TimeFormat(q_select.dt_due, 'HH:mm')#

Link zum Eintrag:
https://www.openTeamWare.com/crm/?action=activities
</cfmail>


<cfcatch type="any">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
<!--- update --->

<cfquery name="q_update_status" datasource="#request.a_str_db_tools#">
UPDATE
	followups
SET
	alert_email_done = 1
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select.entrykey#">
;
</cfquery>

</cfloop>