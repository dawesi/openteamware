

<cfquery name="q_insert_forwarding" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	forwarding
	(
	id,
	destination,
	leavecopy
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.source)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.destination)#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.leavecopy#">
	)
;
</cfquery>