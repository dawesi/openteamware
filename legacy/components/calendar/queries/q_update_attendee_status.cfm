<!--- //

	Module:		Calendar
	Function:	SetAttendeeStatus
	Description: 
	

// --->

<cfquery name="q_update_attendee_status" datasource="#request.a_str_db_tools#">
UPDATE
	meetingmembers
SET
	status = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.status#">,
	dt_answered  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,
	comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
	AND
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameter#">
	AND
	type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
;
</cfquery>

