<!--- //

	Module:		Log
	Function:	LogException
	Description: 
	

// --->

<cfwddx action="cfml2wddx" output="a_str_wddx_error" input="#arguments.error#">
<cfwddx action="cfml2wddx" output="a_str_wddx_url" input="#arguments.url#">
<cfwddx action="cfml2wddx" output="a_str_wddx_cgi" input="#arguments.cgi#">
<cfwddx action="cfml2wddx" output="a_str_wddx_session" input="#arguments.session#">
<cfwddx action="cfml2wddx" output="a_str_wddx_arguments" input="#arguments.args#">
<cfwddx action="cfml2wddx" output="a_str_wddx_form" input="#arguments.form#">

<cfquery name="q_insert_exception_log" datasource="#request.a_str_db_log#">
INSERT INTO
	exceptionlog
(
	entrykey,
	dt_created,
	Message,
	data_wddx_error,
	data_wddx_url,
	data_wddx_form,
	data_wddx_cgi,
	data_wddx_session,
	data_wddx_arguments,
	ip,
	hostname
)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left( arguments.message, 500)#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx_error#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx_url#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx_form#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx_cgi#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx_session#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx_arguments#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#inet#">
	)
;
</cfquery>

