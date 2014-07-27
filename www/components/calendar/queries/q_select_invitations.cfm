<cfquery name="q_select_invitations" datasource="#request.a_str_db_tools#">
SELECT
	calendar.title,meetingmembers.parameter,meetingmembers.status,meetingmembers.type,
	calendar.entrykey,
	<!--- add utc --->	
	DATE_ADD(calendar.date_start, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS date_start,	
	DATE_ADD(calendar.date_end, INTERVAL -#val(arguments.usersettings.utcdiffonly)#-daylightsavinghoursoncreate HOUR) AS date_end		
FROM
	meetingmembers
LEFT JOIN calendar
	ON
	(calendar.entrykey = meetingmembers.eventkey)
WHERE
	calendar.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
	AND
	meetingmembers.status = 0
	AND
	meetingmembers.type IN (0,1,2)
    AND
    meetingmembers.sendinvitation = 1
	AND
    temporary = 0
	AND
	calendar.date_start > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
;
</cfquery>