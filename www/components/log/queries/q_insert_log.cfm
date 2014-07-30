<cfquery name="q_insert_log">
INSERT INTO
	performedactions
	(
	userkey,
	objectkey,
	servicekey,
	actionname,
	sectionkey,
	entrykey,
	dt_done,
	failed,
	additionalinformation
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.performedaction#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sectionkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GETUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.failed#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.additionalinformation#">
	)
;
</cfquery>