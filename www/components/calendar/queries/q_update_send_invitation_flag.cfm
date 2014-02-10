<!--- //
	Module:		 Calendar
	Description: update the sendinvitation flag of the meetingmember
	

	
// --->

<cfquery name="q_update_send_invitation_flag" datasource="#request.a_str_db_tools#">
UPDATE
	meetingmembers
SET
	sendinvitation = <cfqueryparam cfsqltype="cf_sql_integer" value="#sendinvitationnr#">
WHERE
	eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">
	AND
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameter#">
	AND
	type = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
    AND
    temporary = 1
;
</cfquery>



