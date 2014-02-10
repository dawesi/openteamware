


<cfquery name="q_insert_shareddata_tasks" datasource="#request.a_Str_db_tools#">
INSERT INTO
	shareddata_email
	(
	folderdata,
	workgroupkey,
	createdbyuserkey,
	dt_created,
	entrykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUtcTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">
	)
;
</cfquery>