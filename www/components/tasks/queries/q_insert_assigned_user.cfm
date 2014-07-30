
<cfquery name="q_insert_assigned_user">
INSERT INTO
	tasks_assigned_users
(
	taskkey,
	userkey
)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.taskkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">
	)
;
</cfquery>