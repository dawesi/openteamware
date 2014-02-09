<cfquery name="q_insert_lookup_job" datasource="#request.a_Str_db_tools#">
INSERT INTO
	lookupuidjobs
	(
	username,
	folder,
	messageid,
	reference_ids,
	status
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_account#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_open_alerts.foldername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_messageid#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Mid(a_str_references, 1, 250)#">,
	0	
	)
;
</cfquery>
<h4>lookup job inserted.</h4>