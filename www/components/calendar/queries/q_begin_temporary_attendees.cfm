<!--- //
	Module:            calendar
	Description:       Deletes all temporary meeting members (of specified calendar) and creates temporary clones 
                       of non temporary meetingmembers.
// --->
<cfquery name="q_begin_temporary_attendees">
DELETE FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
    AND
    temporary = 1
;
</cfquery>
<cfquery name="q_begin_temporary_attendees">
INSERT INTO
	meetingmembers
	(
    eventkey,
    parameter,
    status,
    type,
    dt_created,
    dt_answered,
    comment,
    createdbyuserkey,
    entrykey,
    sendinvitation
	)
SELECT 
    eventkey,
    parameter,
    status,
    type,
    dt_created,
    dt_answered,
    comment,
    createdbyuserkey,
    entrykey,
    sendinvitation
FROM meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
	AND
	temporary = 0
;
</cfquery>

