<cftry>

<cfquery name="q_insert_onchange_alert" datasource="#request.a_str_db_tools#">
INSERT INTO
	alert_on_change_postings
	(
	userkey,
	threadkey,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.threadkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
	)
;
</cfquery>

<cfcatch type="any">
</cfcatch>
</cftry>