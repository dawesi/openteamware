<!--- //

	Module:		Calendar
	Description:Send reminder to persons assigned to appointments
	

	
	
	select meeting members of the events that starts tomorrow and which are of types inboxCC members, contacts 
    or simple email addresses and should be notified (and are not temporary and have not cancelled by invited person)
	
// --->

<cfset a_int_day = DateFormat(DateAdd("d", 1, Now()), 'yyyymmdd') />

<cfquery name="q_select_meeting_members_to_remind" datasource="#request.a_str_db_tools#">
SELECT
    meetingmembers.eventkey as eventkey,
    meetingmembers.type as type,
    meetingmembers.parameter as parameter,
    calendar.userkey as userkey
FROM
    meetingmembers
LEFT JOIN
    calendar ON (calendar.entrykey = meetingmembers.eventkey)
WHERE
    (meetingmembers.type IN (0, 1, 2))
    AND
    (meetingmembers.sendinvitation = 1)
    AND
    (meetingmembers.temporary = 0)
	AND NOT
	(status = -1)
    AND
    (DATE_FORMAT(calendar.date_start, '%Y%m%d') = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_day#">)
</cfquery>

<cfdump var="#q_select_meeting_members_to_remind#"/>

<cfloop query="q_select_meeting_members_to_remind">
	
	<cfinvoke component="#application.components.cmp_calendar#" method="SendAppointmentReminder" returnvariable="a_bol_return">
		<cfinvokeargument name="eventkey" value="#q_select_meeting_members_to_remind.eventkey#">
		<cfinvokeargument name="type" value="#q_select_meeting_members_to_remind.type#">
		<cfinvokeargument name="parameter" value="#q_select_meeting_members_to_remind.parameter#">
		<cfinvokeargument name="userkey" value="#q_select_meeting_members_to_remind.userkey#">
	</cfinvoke>
	
</cfloop>