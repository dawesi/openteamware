<cfwddx action="cfml2wddx" input="#session#" output="a_str_wddx_session" usetimezoneinfo="yes">
<cfwddx action="cfml2wddx" input="#form#" output="a_str_wddx_form" usetimezoneinfo="yes">

<cfset inet = CreateObject("java", "java.net.InetAddress")>
<cfset a_str_hostname = inet.getLocalHost()>

<cfquery name="q_insert_log" datasource="#request.a_str_db_log#">
INSERT INTO
	outlooksync_app
	(
	ip,
	entrykey,
	dt_created,
	script_name,
	query_string,
	form,
	session,
	userkey,
	hostname
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_request_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.SCRIPT_NAME#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">,
	
	'#a_str_wddx_form#',
	'#a_str_wddx_session#',
	
	<cfif StructKeyExists(session, 'stSecurityContext')>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.stSecurityContext.myuserkey#">
	<cfelse>
		''
	</cfif>
	,<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_hostname#">
	)
;
</cfquery>