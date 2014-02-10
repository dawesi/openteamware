<!--- //

	Module:		Storage
	Function:	ListFilesAndDirectories
	Description: 
	

// --->

<cfquery name="q_select_subdirectories_files" datasource="#request.a_str_db_tools#">
SELECT 
	'directory' AS filetype,
	entrykey,
	directoryname AS name,
	description,
	categories,
	0 AS filesize,
	'' AS contenttype,
	userkey,
	filescount,
	0 AS specialtype,
	dt_created,
	0 AS shared,
	parentdirectorykey,
	dt_lastmodified,
	0 AS locked
FROM
	directories
WHERE
	parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#">
UNION
SELECT
	'file' as filetype,
	entrykey,
	filename AS name,
	description,
	categories,
	filesize,
	contenttype,
	userkey,
	0 AS filescount,
	0 AS specialtype,
	dt_created,
	0 AS shared,
	parentdirectorykey,
	dt_lastmodified,locked 
FROM
	storagefiles
WHERE
	parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#">
ORDER BY
	filetype,name
;
</cfquery>

<cfif isdefined("arguments.securitycontext.myuserkey")>

	<cfquery name="q_select_own_directories" dbtype="query">
	SELECT
		entrykey
	FROM
		q_select_subdirectories_files
	WHERE
		userkey = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.securitycontext.myuserkey#">
	;
	</cfquery>

	<cfset a_str_own_directories = ValueList(q_select_own_directories.entrykey) />

	<cfif Len(a_str_own_directories) GT 0>

		<cfquery name="q_select_shared_directories_of_user" datasource="#request.a_str_db_tools#">
		SELECT
			directorykey
		FROM
			directories_shareddata
		WHERE
			directorykey IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#a_str_own_directories#" list="Yes">)
		UNION
		SELECT 
			directorykey
		FROM 
			publicshares
		WHERE
			directorykey IN (<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#a_str_own_directories#" list="Yes">)
		;
		</cfquery>

		<cfset a_struct_directorykeys=StructNew()>

		<cfloop index="sDirectorykey" list="#valuelist(q_select_shared_directories_of_user.directorykey)#">
			<cfset a_struct_directorykeys[sDirectorykey] = 1 />
		</cfloop>

		<cfloop query="q_select_subdirectories_files">

			<cfif StructKeyExists(a_struct_directorykeys,q_select_subdirectories_files.entrykey)>

				<cfset tmp=QuerySetCell(q_select_subdirectories_files,'shared', 1, q_select_subdirectories_files.currentrow) />

			</cfif>

		</cfloop>

	</cfif>

</cfif>


