<cfquery name="q_select_tasks">
SELECT
	*
FROM
	tasks
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadDataRequest.userkey#">
;
</cfquery>