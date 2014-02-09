<cfquery name="q_insert_code" datasource="#request.a_str_db_users#">
INSERT INTO
	activatecodes
	(
	companykey,
	code,
	dt_created,
	createdbyuserkey,
	entrykey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_code#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">
	)
;
</cfquery>