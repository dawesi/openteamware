

<cfquery name="q_insert_clickstream">
INSERT INTO
	clickstream
	(
	userkey,dt_click,href,pagename,servicekey
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertClickstreamRequest.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(InsertClickstreamRequest.href, 1, 255)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(InsertClickstreamRequest.pagename, 1, 255)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertClickStreamRequest.servicekey#">
	)
;
</cfquery>