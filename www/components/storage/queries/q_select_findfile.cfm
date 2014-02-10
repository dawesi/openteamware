<!--- //

	Module:		Storage
	Function.	FindFile
	Description: 
	

// --->

<cfquery name="q_select_findfile" datasource="#request.a_str_db_tools#">
SELECT
	'file' as filetype,
	storagefiles.entrykey,
	storagefiles.filename as name,
	storagefiles.description,
	storagefiles.categories,
	storagefiles.filesize,
	storagefiles.contenttype,
	storagefiles.userkey,
	storagefiles.locked,
	0 as filescount,
	0 as specialtype,
	storagefiles.dt_created,
	storagefiles.dt_lastmodified
FROM
	storagefiles
WHERE
	1=1
<cfif len(arguments.filename) gt 0 >
	AND storagefiles.filename like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"> 
</cfif>

<cfif len(arguments.directorykey) gt 0 >
	AND storagefiles.parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#"> 
</cfif>

<cfif len(arguments.entrykey) gt 0 >
	AND storagefiles.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"> 
</cfif>

<cfif a_bol_ignore_userkey_criteria>
	AND (storagefiles.parentdirectorykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sDirectory_keys_search_targets#" list="true">))
<cfelse>
	AND (storagefiles.userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">)
</cfif>
	
UNION
SELECT 
	'directory' as filetype,
	directories.entrykey,
	directories.directoryname as name,
	directories.description,
	directories.categories,
	0 as filesize,
	0 AS locked,
	'' as contenttype,
	directories.userkey,
	directories.filescount,
	0 as specialtype,
	directories.dt_created,
	directories.dt_lastmodified
FROM
	directories
WHERE
	1=1

<cfif len(arguments.filename) gt 0 >
	AND directories.directoryname like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filename#"> 
</cfif>

<cfif len(arguments.directorykey) gt 0 >
	AND directories.parentdirectorykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.directorykey#"> 
</cfif>

<cfif len(arguments.entrykey) gt 0 >
	AND directories.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"> 
</cfif>

<!--- select all the user's directories or just where he is the owner? --->
<cfif a_bol_ignore_userkey_criteria>
	AND (directories.entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sDirectory_keys_search_targets#" list="true">))
<cfelse>
	AND directories.userkey = <cfqueryparam value="#arguments.securitycontext.myuserkey#" cfsqltype="cf_sql_varchar">
</cfif>


ORDER BY
	name
;
</cfquery>


