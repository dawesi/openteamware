<cfquery name="q_select_open_invitations">
SELECT
	calendar.title,
	meetingmembers.parameter,
	meetingmembers.status,
	meetingmembers.type,
	calendar.entrykey,
	calendar.date_start
FROM
	calendar
LEFT JOIN meetingmembers
	ON
	(meetingmembers.eventkey  = calendar.entrykey)
WHERE
	calendar.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	AND
	meetingmembers.status = 0
	AND
	meetingmembers.type IN (0,1,2)
    AND
    meetingmembers.sendinvitation = 1
	AND
    temporary = 0
    AND
	calendar.date_start > NOW()
;
</cfquery>