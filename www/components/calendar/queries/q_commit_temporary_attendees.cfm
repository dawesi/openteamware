<!--- //
	Module:            calendar
	Description:       Delete all non temporary attendees (of specified event), and update the 'temporary' flag to 0 
                       for attendees of specified event (publish/comit) assigned attendees
// --->

<cfquery name="q_commit_temporary_attendees">
DELETE FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
    AND
    temporary = 0
;
</cfquery>

<cfquery name="q_commit_temporary_attendees">
UPDATE 
	meetingmembers
SET
    temporary = 0
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
	AND
	temporary = 1
;
</cfquery>

