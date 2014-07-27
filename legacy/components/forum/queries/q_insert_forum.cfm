<!---

	insert forum ... --->
	
<cfquery name="q_insert_forum" datasource="#request.a_str_db_tools#">
INSERT INTO
	foren
	(
	forumname,
	description,
	dt_created,
	createdbyuserkey,
	entrykey,
	companykey,
	companynews_forum,
	admin_post_only
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Checkzerostring(arguments.name)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(arguments.description)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companynews_forum#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.admin_post_only#">
	)
;
</cfquery>