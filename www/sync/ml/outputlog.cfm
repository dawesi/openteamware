<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body>

<cfparam name="url.username" type="string" default="">
<cfparam name="url.request_method" type="string" default="">

<cfquery name="q_select_users" datasource="#request.a_str_db_log#">
SELECT
	DISTINCT(username)
FROM
	syncml_log
;
</cfquery>

<b>Filter by user</b><br>
<cfoutput query="q_select_users">
	<a href="?username=#q_select_users.username#">#q_select_users.username#</a>&nbsp;&nbsp;
</cfoutput>
<br><br>
<b>Request method</b><br>
<cfoutput>
<a href="?username=#url.username#&request_method=">ALL</a>
&nbsp;&nbsp;
<a href="?username=#url.username#&request_method=PROPPATCH">PROPPATCH</a>
&nbsp;&nbsp;
<a href="?username=#url.username#&request_method=SEARCH">SEARCH</a>
&nbsp;&nbsp;
<a href="?username=#url.username#&request_method=DELETE">DELETE</a>
</cfoutput>
<br><br>
<cfquery name="q_select_log" datasource="#request.a_str_db_log#">
SELECT
	dt_created,
	request_body,
	response_body,
	response_headers,
	request_headers,
	path_info,
	request_method,
	username
FROM
	 syncml_log
WHERE
	(1=1)
<cfif Len(url.username) GT 0>
	AND
	(username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.username#">)
</cfif>
<cfif Len(url.request_method) GT 0>
	AND
	(request_method = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.request_method#">)
</cfif>
ORDER BY
	dt_created DESC
;
</cfquery>

<cfdump var="#q_select_log#">

</body>
</html>