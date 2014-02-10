<cfquery name="q_select_own_tasks_recordcount" datasource="#request.a_Str_db_tools#">
SELECT
	COUNT(id) AS count_id
FROM
	tasks
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
;
</cfquery>