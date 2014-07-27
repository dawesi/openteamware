<!--- //
	Module:		 Calendar
	Description: Selects newly added meeting members (which has sendinvitation flag) and also old meeting members
                 that have newly checked sendinvitation flag.
// --->

<cfquery name="q_select_meeting_members_to_notify" datasource="#request.a_str_db_tools#">
SELECT 
    new.*
FROM 
    meetingmembers new
WHERE 
    new.temporary = 1
    AND 
    new.eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
    AND 
    new.sendinvitation = 1
    AND 
    (
        new.entrykey NOT IN 
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
        OR
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
	                AND 
	                old.sendinvitation = 0
	        )
    )
;
</cfquery>

