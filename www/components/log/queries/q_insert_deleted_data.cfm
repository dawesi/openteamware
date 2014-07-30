

<cfquery name="q_insert_deleted_data">
INSERT INTO
	deleteddata
	(
	userkey,
	datakey,
	dt_deleted,
	servicekey,
	wddxdata,
	title
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.datakey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GETUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_xml_package#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">
	)
;
</cfquery>