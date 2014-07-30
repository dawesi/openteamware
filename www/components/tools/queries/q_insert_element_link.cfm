<cfquery name="q_insert_element_link">
INSERT INTO
	element_links
	(
	entrykey,
	source_entrykey,
	dt_created,
	dest_entrykey,
	createdbyuserkey,
	connection_type,
	comment,
	source_name,
	dest_name,
	source_servicekey,
	dest_servicekey
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.source_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dest_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.connection_type#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.source_displayname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dest_displayname#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.source_servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dest_servicekey#">
	)
;
</cfquery>