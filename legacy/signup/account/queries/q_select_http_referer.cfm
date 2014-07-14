<cfquery name="q_select_http_referer" datasource="#request.a_str_db_log#" maxrows="1">
SELECT
	referer
FROM
	refererdata
WHERE
	urltoken = <cfqueryparam cfsqltype="cf_sql_varchar" value="#client.URLToken#">
;
</cfquery>