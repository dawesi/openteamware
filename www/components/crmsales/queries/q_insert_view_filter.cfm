<cfquery name="q_insert_view_filter" datasource="#request.a_str_db_tools#">
INSERT INTO
	crmfilterviews
	(
	viewname,
	description,
	dt_created,
	entrykey,
	userkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">
	)
;
</cfquery>