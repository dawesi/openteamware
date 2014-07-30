<cfquery name="q_insert_consumergoods_history">
INSERT INTO
	consumergoodshistory
	(
	companykey,
	userkey,
	dt_created,
	points
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.mycompanykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.points#">
	)
;
</cfquery>