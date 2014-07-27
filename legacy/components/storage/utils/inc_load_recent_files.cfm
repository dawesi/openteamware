<!--- //

	Module:		Storage
	Action:		DisplayLatelyAddedFilesList
	Description:get recently added/modified/downloaded files
	

// --->
	
<cfset a_struct_files = GetDirectoryStructure(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings) />

<cfset stReturn.q_select_recent_files = querynew('abc')>

<cfset stReturn.tc = GetTickCount() - a_tc>

<cfset a_str_directories = StructKeyList(a_struct_files.directories) />

<cfif Len(a_str_directories) IS 0>
	<cfset a_str_directories = 'abc' />
</cfif>

<cfquery maxrows="50" name="q_select_recent_files" datasource="#request.a_str_db_tools#">
SELECT
	storagefiles.entrykey,
	storagefiles.filename AS name,
	storagefiles.description,
	storagefiles.createdbyuserkey,
	storagefiles.userkey,
	storagefiles.lasteditedbyuserkey,
	storagefiles.filesize,
	storagefiles.contenttype,
	storagefiles.storagefilename,
	storagefiles.storagepath,
	storagefiles.dt_created,
	storagefiles.locked,
	storagefiles.dt_lastmodified,
	storagefiles.parentdirectorykey,
	'file' AS filetype
FROM
	storagefiles
WHERE
	(userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#">)
	<!--- AND
	(parentdirectorykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_directories#" list="yes">)) --->

	<cfif arguments.type IS 'locked'>
	AND
	(locked = 1)
	</cfif>

ORDER BY
	<cfswitch expression="#arguments.type#">
		<cfcase value="created">
		dt_created DESC
		</cfcase>
		<cfdefaultcase>
		dt_lastmodified DESC
		</cfdefaultcase>
	</cfswitch>
	
;
</cfquery>

<cfset stReturn.q_select_recent_files = q_select_recent_files>


