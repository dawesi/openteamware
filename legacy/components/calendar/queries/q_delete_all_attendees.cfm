<!--- //
	Module:		 Calendar
	Description: deletes all meetingmembers records for specified eventkey
// --->

<cfquery name="q_delete_all_attendees" datasource="#request.a_str_db_tools#">
DELETE FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>

