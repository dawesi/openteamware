<cfquery name="q_insert_smartpush_alert" datasource="#request.a_str_db_tools#">
INSERT INTO
	smartpush_alerts
	(
	entrykey,
	userkey,
	subject,
	dt_created,
	itemtype,
	shortbody,
	sender,
	delivered
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(a_str_subject)#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="email">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_from#">,
	0
	)
;
</cfquery>