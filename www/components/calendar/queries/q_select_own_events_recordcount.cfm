<cfquery name="q_select_own_events_recordcount" datasource="#request.a_str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	calendar
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>