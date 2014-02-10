
<cfquery name="q_insert_secret" datasource="#request.a_str_db_mailusers#">
INSERT INTO
	usersecret
	(
	id,
	secret
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailaddress#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_secret#">
	)
;	
</cfquery>