<!--- //
	Module:		 Calendar
	Description: Select meeting members that are not newly added (created) and should be notified (about the changes).
// --->

<cfquery name="q_select_old_meeting_members_to_notify" datasource="#request.a_str_db_tools#">
SELECT 
    new. *
FROM 
    meetingmembers new
WHERE 
    new.temporary = 1
    AND 
    new.eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
    AND 
    new.sendinvitation = 1
    AND
    new.entrykey IN 
        (
            SELECT 
                old.entrykey
            FROM
                meetingmembers old
            WHERE 
                old.eventkey = new.eventkey
                AND 
                old.temporary = 0
        )
;
</cfquery>

