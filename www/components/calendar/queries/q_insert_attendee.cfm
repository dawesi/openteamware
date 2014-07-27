<!--- //

	Module:		Calendar
	Description:insert a new attendee
	

// --->
<cfquery name="q_insert_attendee" datasource="#request.a_str_db_tools#">
INSERT INTO
	meetingmembers
	(
	entrykey,
	eventkey,
	parameter,
	status,
	type,
	dt_created,
	dt_answered,
	createdbyuserkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameter#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	NULL,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	)
;
</cfquery>


