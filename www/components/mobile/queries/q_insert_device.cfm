<cfquery name="q_insert_device" datasource="#request.a_str_db_syncml#">
INSERT INTO
	sync4j_device
	(
	id,
	description,
	type,
	server_password,
	id_caps,
	convert_date,
	manufactor_model,
	charset
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
	'sync4j',
	2,
	'N',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.manufactor_model#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.encoding#">
	)
;	
</cfquery>