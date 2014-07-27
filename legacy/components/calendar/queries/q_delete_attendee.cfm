<!--- //
	Module:		 Calendar
	Description: deletes temporary meetingmember record(s) of specified type and/or 'parameter' (if specified) for specified eventkey
// --->

<cfquery name="q_delete_attendee" datasource="#request.a_str_db_tools#">
DELETE FROM
	meetingmembers
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
	AND
	type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
	AND
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameter#">
    AND
    temporary = 1
;
</cfquery>


