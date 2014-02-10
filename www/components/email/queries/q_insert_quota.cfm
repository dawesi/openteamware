

<cfquery name="q_insert_quota" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	quota
	(
	id,
	maxsize,
	cursize
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.maxsize#">,
	0
	)
;
</cfquery>