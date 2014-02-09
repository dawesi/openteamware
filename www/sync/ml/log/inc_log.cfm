<!--- //

	log request
	
	// --->
	
	
<cfset inet = CreateObject("java", "java.net.InetAddress")>

<cfset a_str_hostname = inet.getLocalHost()>

<cfset a_struct_headers = GetHttpRequestData().headers>
<cfset a_str_headers = ''>

<cfloop list="#StructKeyList(a_struct_headers)#" delimiters="," index="a_str_item">
	<cfset a_str_headers = a_str_headers & chr(13) & chr(10) & a_str_item & '=' & a_struct_headers[a_str_item]>
</cfloop>

<cfset a_str_headers = trim(a_str_headers)>
	
<cfquery name="q_insert_log" datasource="#request.a_str_db_log#">
INSERT INTO
	 syncml_log
	 (
	 dt_created,
	 ip,
	 request_headers,
	 request_body,
	 query_string,
	 path_info,
	 username,
	 entrykey,
	 request_method,
	 hostname
	 )
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	'#a_str_headers#',
	'#GetHttpRequestData().content#',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.PATH_INFO#">,
	'',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_str_log_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REQUEST_METHOD#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_hostname#">
	)
;
</cfquery>