<cfquery name="q_select_own_tasks_recordcount">
SELECT
	COUNT(id) AS count_id
FROM
	tasks
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>