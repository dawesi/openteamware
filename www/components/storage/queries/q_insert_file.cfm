<!---

modul name:      Storage
description: Create a File



--->

<cfquery name="q_insert_file" datasource="#request.a_str_db_tools#">
INSERT INTO
	storagefiles
	(
	entrykey,
	parentdirectorykey,
	filename,
	description,
	createdbyuserkey,
	userkey,
	lasteditedbyuserkey,
	dt_created,
	dt_lastmodified,
	categories,
	contenttype,
	filesize,
	storagepath,
	storagefilename,
	storageunit
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_filekey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,
	'',
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contenttype#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filesize#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_destdir#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_uuid#">,
	0
	)
;
</cfquery>

<!---
	$Log: q_insert_file.cfm,v $
	Revision 1.4  2007-06-22 17:13:46  hansjp
	cleanup

	--->