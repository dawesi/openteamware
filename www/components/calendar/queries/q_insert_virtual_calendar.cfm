<!--- //
	Module:		Calendar
	Description:Inserts new virtual calendar into database
	

	
// --->

<cfquery name="q_insert_virtual_calendar">
INSERT INTO
	virtualcalendars
	(
	entrykey,
	createdbyuserkey,
	userkey,
	companykey,
	dt_created,
	title,
	description,
	public,
<!---	language, --->
	colour
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.description#">,
	false,
<!---	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.database_values.language)#">, --->
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.colour#">
	)
;
</cfquery>

