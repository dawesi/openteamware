<cfquery name="q_select_events" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	calendar
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadDataRequest.userkey#">
;
</cfquery>