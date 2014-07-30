<cfquery name="q_insert_crm_report">
INSERT INTO
	crm_reports
	(
	entrykey,
	userkey,
	dt_created,
	reportname,
	description,
	tablekey,
	crmfilterkey,
	dt_start,
	dt_end,
	date_field,
	displayfields,
	specials,
	interval,
	filter
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reportname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tablekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.crmfilterkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(arguments.dt_start)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(arguments.dt_end)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.date_field#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.displayfields#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.interval#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">
	)
;
</cfquery>