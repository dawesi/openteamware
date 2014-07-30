<<!--- //

	Component:	Follow Ups
	Function:	CreateFollowup
	Description:Insert a followup job
	

// --->
	
<cfquery name="q_insert_follow_up">
INSERT INTO
	followups
	(
	entrykey,
	servicekey,
	objectkey,
	objecttitle,
	userkey,
	createdbyuserkey,
	subject,
	comment,
	dt_created,
	dt_due,
	alert_email,
	followuptype,
	priority,
	categories
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objecttitle#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(Now()))#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(arguments.dt_due)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.alert_email#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#">
	)
;
</cfquery>

