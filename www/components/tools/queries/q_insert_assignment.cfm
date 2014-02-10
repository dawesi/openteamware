
<cftry>

<cfquery name="q_insert_assignment" datasource="#request.a_str_db_tools#">
INSERT INTO
	assigned_items
	(
	servicekey,
	userkey,
	objectkey,
	dt_created,
	createdbyuserkey,
	comment
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">
	)
;
</cfquery>

<cfcatch type="any">
	<!--- duplicate --->
</cfcatch>
</cftry>