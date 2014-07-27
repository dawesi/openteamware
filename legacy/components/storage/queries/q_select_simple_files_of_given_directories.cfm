<!--- //

	Module:		
	Action:		SimpleGetFileListOfDirectories
	Description:	
	

// --->

<cfquery name="q_select_simple_files_of_given_directories" datasource="#request.a_str_db_tools#">
SELECT
	'file' as filetype,
	storagefiles.entrykey,
	storagefiles.filename AS name,
	storagefiles.description,
	storagefiles.categories,
	storagefiles.filesize,
	storagefiles.contenttype,
	storagefiles.userkey,
	0 AS filescount,
	0 AS specialtype,
	storagefiles.dt_created,
	0 AS shared,
	storagefiles.parentdirectorykey,
	storagefiles.dt_lastmodified,
	storagefiles.locked 
FROM
	storagefiles
WHERE
	(storagefiles.parentdirectorykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykeys#" list="true">))
	AND NOT
	(storagefiles.parentdirectorykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_public_shares_uuid#,#a_str_shared_files_uuid#,#a_str_workdir_uuid#" list="true">))
ORDER BY
	filetype,name
;
</cfquery>
