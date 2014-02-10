
<cfquery name="q_insert_assigned_user" datasource="#request.a_str_db_tools#">
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