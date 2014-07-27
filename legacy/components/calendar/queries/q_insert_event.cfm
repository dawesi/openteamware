<!--- //
	Module:		 Calendar
	Description: Creates new record in the calendar table
// --->

<cfquery name="q_insert_event" datasource="#request.a_str_db_tools#">
INSERT INTO
	calendar
	(
	createdbyuserkey,
	userkey,
	createdbysecretarykey,
	entrykey,
	title,
	categories,
	virtualcalendarkey,
	date_start,
	date_end,
	dt_created,
	dt_lastmodified,
	priority,
	privateevent,
	description,
	type,
	location,
	repeat_type,
	repeat_weekdays,
	repeat_weekday,
	repeat_day,
	repeat_month,
	repeat_start,
	
	<cfif IsDefined("arguments.repeat_until") AND isDate(arguments.repeat_until)>
		repeat_until,
	</cfif>
	
	repeat_day_1,
	repeat_day_2,
	repeat_day_3,
	repeat_day_4,
	repeat_day_5,
	repeat_day_6,
	repeat_day_7,
	meetingmemberscount,
	daylightsavinghoursoncreate,
	color,
    showtimeas
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfif Len(arguments.userkey) GT 0>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfelse>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	</cfif>
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.secretarykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.virtualcalendarkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.date_start)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.date_end)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.privateevent#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.location#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.repeat_weekdays#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_weekday#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_month#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.date_start)#">,

	<cfif IsDefined("arguments.repeat_until") AND isDate(arguments.repeat_until)>
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.repeat_until)#">,
	</cfif>	
	
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_1#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_2#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_3#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_4#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_5#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_6#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.repeat_day_7#">,
    (select count(id) from meetingmembers where eventkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"> and temporary = 1),
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.usersettings.DAYLIGHTSAVINGHOURSONLY#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.color#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.showtimeas#">
	)
;	
</cfquery>

<cfinclude template="q_commit_temporary_attendees.cfm">

