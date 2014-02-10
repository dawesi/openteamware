<cfquery name="q_insert_filtersearch_criteria" datasource="#request.a_str_db_tools#">
INSERT INTO
	crmfiltersearchsettings
	(
	entrykey,
	dt_created,
	servicekey,
	userkey,
	viewkey,
	area,
	displayname,
	internalfieldname,
	internaldatatype,
	connector,
	operator,
	comparevalue
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.viewkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.area#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.displayname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.internalfieldname#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.internaldatatype#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.connector#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operator#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.comparevalue)#">
	)
;
</cfquery>