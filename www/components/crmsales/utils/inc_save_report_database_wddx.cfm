<cfwddx action="cfml2wddx" input="#stReturn#" output="a_str_wddx" usetimezoneinfo="no">

<!---<cffile action="write" addnewline="no" charset="utf-8" file="/tmp/wddx.xml" output="#a_str_wddx#">--->

<cfquery name="q_insert_report_output" datasource="#request.a_str_Db_databases#">
INSERT INTO
	crm_reports_output
	(
	entrykey,
	reportkey,
	dt_created,
	wddx,
	userkey,
	includefields
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reportkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.includefields#">
	)
;
</cfquery>