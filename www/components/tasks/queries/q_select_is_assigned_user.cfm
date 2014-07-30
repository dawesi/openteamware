<cfquery name="q_select_is_assigned_user" >
SELECT
	COUNT(id) AS count_id
FROM
	tasks_assigned_users
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	AND
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taskkey#">
;
</cfquery>