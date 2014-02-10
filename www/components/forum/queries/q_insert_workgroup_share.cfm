
<cfquery name="q_insert_forum" datasource="#request.a_str_db_tools#">
INSERT INTO
	foren_shareddata
	(
	forumkey,
	workgroupkey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.forumkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
	)
;
</cfquery>