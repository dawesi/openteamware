<!--- //
	Module:		Calendar
	Description:Subscribe to a public virtual calendar
	

	
// --->

<cfquery name="q_insert_subscribe_public_virtual_calendar">
INSERT INTO
	virtualcalendarsubscriptions
	(
	entrykey,
	userkey,
	virtualcalendarkey,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#">
	)
;
</cfquery>

