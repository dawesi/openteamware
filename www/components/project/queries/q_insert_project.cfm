<cfquery name="q_insert_project" datasource="#request.a_str_db_crm#">
INSERT INTO
	projects	
	(
	userkey,
	title,
	description,
	percentdone,
	dt_created,
	priority,
	parentprojectkey,
	entrykey,
	categories
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.percentdone)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentprojectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categories#">
	)	
;
</cfquery>