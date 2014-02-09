<cfif ListFindNoCase('/toolbox/cmp_toolbox.cfc,/session/cmp_session.cfc', cgi.SCRIPT_NAME) GT 0>
	<cfexit method="exittemplate">
</cfif>


<cfquery name="q_insert_log" datasource="#request.a_str_db_log#">
INSERT INTO
	webservices_log
	(
	entrykey,
	ip,
	script_name,
	query_string,
	dt_created,
	applicationkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_request_uuid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.SCRIPT_NAME#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_app_key#">
	)
;
</cfquery>