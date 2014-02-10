<!--- //

	Component:     Forms
	Description:   Insert a form request into database
				   Store use, form, request key to mycache.form_requests
	
	Parameters

// --->

<cfquery name="q_insert_form_request" datasource="#request.a_str_db_tools#">
INSERT INTO
	form_requests
	(
	requestkey,
	formkey,
	userkey,
	dt_created,
	data_used,
	action_type
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_form_properties.request_entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GetUTCTime(Now()))#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.a_struct_form_properties.action_type#">
	)
;
</cfquery>

