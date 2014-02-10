<cfwddx action="cfml2wddx" input="#q_select_raw_posting#" output="a_str_wddx">

<cfquery name="q_insert_edited_posting" datasource="#request.a_str_db_tools#">
INSERT INTO
	postings_oldversion 
	(
	userkey,
	wddx,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_wddx#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createODBCDateTime(Now())#">
	)
;
</cfquery>