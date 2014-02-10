<cfquery name="q_select_tasks" datasource="#request.a_str_db_tools#">
SELECT
	*
FROM
	tasks
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LoadDataRequest.userkey#">
;
</cfquery>