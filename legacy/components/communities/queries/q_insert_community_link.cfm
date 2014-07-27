<cfquery name="q_insert_community_link" datasource="#request.a_str_db_tools#">
INSERT INTO
	community_links
	(
	communitykey,
	servicekey,
	objectkey,
	dt_created,
	entrykey,
	object_title,
	object_description
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.communitykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object_title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.object_description#">
	)
;
</cfquery>