<cfquery name="q_insert_speedmail_folder_data" datasource="#request.a_str_db_email#">
INSERT INTO
	folders
	(
	account,
	foldername,
	path,
	syncstatus,
	userid,
	listlen_foldername
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(arguments.username)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.foldername#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_speedmail_userdata.maildir#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.userid#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#ListLen(arguments.foldername, '.')#">
	)
;
</cfquery>