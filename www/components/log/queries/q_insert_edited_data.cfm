<cfwddx action="cfml2wddx" input="#a_struct_new_data#" output="a_str_xml_new_data">
<cfwddx action="cfml2wddx" input="#a_struct_old_data#" output="a_str_xml_old_data">

<cfquery name="q_insert_edited_data" datasource="#request.a_str_db_log#">
INSERT INTO
	editeddata
	(
	userkey,
	datakey,
	dt_edited,
	servicekey,
	wddxdata,
	title,
	editedfields,
	old_data_wddx,
	new_data_wddx
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.datakey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(GETUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.servicekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_xml_package#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.title#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_fields_changed#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_xml_old_data#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_xml_new_data#">
	)
;
</cfquery>