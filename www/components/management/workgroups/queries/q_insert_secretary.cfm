

<cfquery name="q_insert_secretary" datasource="#request.a_str_db_users#">
INSERT INTO
	secretarydefinitions
	(
	entrykey,
	userkey,
	secretarykey,
	createdbyuserkey,
	dt_created,
	companykey,
	permission
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.secretarykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.permission#">
	)
;
</cfquery>