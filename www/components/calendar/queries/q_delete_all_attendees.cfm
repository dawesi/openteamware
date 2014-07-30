<!--- //
	Module:		 Calendar
	Description: deletes all meetingmembers records for specified eventkey
// --->

<cfquery name="q_delete_all_attendees">
DELETE FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

