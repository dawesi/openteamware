<!--- //
	Module:		 Calendar
	Description: check if the user is assigned to specified event (by selecting amount of meetingmebmer with parameter = userkey)
// --->

<cfquery name="q_select_is_attendee_of_event">
SELECT
	COUNT(id) AS count_id
FROM
	meetingmembers
WHERE
	eventkey  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
	AND
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
    AND
    temporary = 0
;
</cfquery>


