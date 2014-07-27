<!---

created:         2004-02-01
author:      $Author: hansjp $
header:      
changed:     $Date: 2007-07-31 14:20:11 $
modul name:      Storage
description: Create a new Version of a File

--->

<cfquery name="q_insert_file_version" datasource="#request.a_str_db_tools#">
INSERT INTO
	versions
	(
	entrykey,
	filekey,
	dt_created,
	description,
	createdbyuserkey,
	version,
	compressed,
	oldproperties,
	filename,
	filesize,
	contenttype
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_uuid#">,
	'',
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDateTime(GetUTCTime(now()))#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_query_file.description#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">,

	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_newversion#">,

	<cfqueryparam cfsqltype="cf_sql_integer" value="0">,

	'',

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_query_file.filename#">,

	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_query_file.filesize#">,

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_query_file.contenttype#">

	)

;

</cfquery>

