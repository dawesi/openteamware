<!--- edited

	origin of alias address is 1 --->

<cfquery name="q_insert_alias" datasource="#request.a_str_db_users#">
INSERT INTO
	emailaliases
	(
	dt_created,
	destinationaddress,
	aliasaddress,
	createdbyuserkey,
	companykey,
	userkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(Now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.destinationaddress#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.aliasaddress#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	)
;
</cfquery>