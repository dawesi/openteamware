<cfquery name="q_select_events">
SELECT
	*
FROM
	calendar
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadDataRequest.userkey#">
;
</cfquery>