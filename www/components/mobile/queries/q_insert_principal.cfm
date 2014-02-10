<cfquery name="q_insert_principal" datasource="#request.a_str_db_syncml#">
INSERT INTO
	sync4j_principal
	(
	username,
	device,
	id
	)
VALUES
	(
	<!--- new: virtual username ... --->
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_virtual_username#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deviceid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_princial_id#">
	)
;
</cfquery>