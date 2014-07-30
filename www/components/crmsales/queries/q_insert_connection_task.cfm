<cfquery name="q_insert_connection_task">
INSERT INTO
	tasks_assigned_to_contacts
	(
	dt_created,
	taskkey,
	contactkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#">
	)
;
</cfquery>