<cfquery name="q_insert_shareddata_storage">
INSERT INTO
	directories_shareddata
	(
	directorykey,
	workgroupkey,
	createdbyuserkey,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUtcTime(now()))#">
	)
;
</cfquery>