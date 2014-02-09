
<!--- insert install name ... --->

<cfquery name="q_insert_update_install_name" datasource="#request.a_str_db_tools#">
DELETE FROM
	install_names
WHERE
	(program_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.computerid#">)
	AND
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">)
;
</cfquery>


<cfquery name="q_insert_install_name" datasource="#request.a_str_db_tools#">
INSERT INTO
	install_names
	(
	userkey,
	program_id,
	install_name,
	dt_lastmodified,
	sessionkey,
	ip,
	version
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.computerid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.install_name#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#client.CFID##client.CFToken#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.version#">
	)
;
</cfquery>
