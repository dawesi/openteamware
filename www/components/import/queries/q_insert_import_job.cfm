<!--- //

	Module:        Import
	Description:   Insert new import job
	

// --->

<cfquery name="q_insert" datasource="#request.a_str_db_tools#">
INSERT INTO
	importjobs
	(
	userkey,
	servicekey,
	entrykey,
	dt_created,
	table_wddx,
	datatype
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.jobkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.datatype#">
	)
;
</cfquery>

