

<cfquery name="q_insert_reminder">
INSERT INTO
	cal_remind
	(
	entrykey,
	eventstart,
	userkey,
	eventkey,
	dt_remind,
	status,
	type,
	remind_email_adr,
	eventtitle
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.eventstart)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(arguments.dt_remind)#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.eventtitle#">
	)
;
</cfquery>