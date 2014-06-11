<!--- //

	Module:		Storage component
	Description: 
	

// --->


 <cfcomponent output=false>

	<!--- Constants --->
	<cfset a_str_search_url="http://81.223.48.145/cgi-bin/htsearch" />
	<cfset a_str_public_shares_uuid = "0A881FE5-C09F-24AD-0C47EBB2D0834098" />
	<cfset a_str_shared_files_uuid = "0A881FE5-C09F-24AD-0C47EBB2D0834099" />
	<cfset a_str_workdir_uuid = "0A881FE5-C09F-24AD-0C47EBB2D0834101" />
	<cfset a_str_storage_servicekey = "5222ECD3-06C4-3804-E92ED804C82B68A2" />
	<cfset a_int_storage_max_traffic = 9000000 />
	<cfset a_int_storage_max_quota = 1000 * 200 * 1024 * 5 />

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cfset a_str_storage_servicekey = '5222ECD3-06C4-3804-E92ED804C82B68A2' />
	
	<cffunction access="public" name="IsValidStorageName" output="false" returntype="boolean"
			hint="Is the given name valid in our system?">
		<cfargument name="name" type="string" required="true"
			hint="name of file or dir">
			
		<cfreturn (FindNoCase('/', arguments.name) IS 0) AND (Len(Trim(arguments.name)) GT 0) />
	</cffunction>

	<cffunction access="private" name="CheckAccess" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="access_type" type="string" required="true" hint="e.g. R = read">
		<cfargument name="object_type" type="string" required="true"
			hint="file or dir">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of object">
			
		<cfset var a_struct_security = 0 />
		
		<!--- shared directories --->
		<cfif arguments.entrykey IS '0A881FE5-C09F-24AD-0C47EBB2D0834099'>
			<cfreturn true />
		</cfif>
		
		<!--- workgroup directories --->
		<cfif arguments.entrykey IS '0A881FE5-C09F-24AD-0C47EBB2D0834101'>
			<cfreturn true />
		</cfif>
		
		<cfinvoke component = "#application.components.cmp_security#"
		 	method = "GetPermissionsForObject"
		 	returnVariable = "a_struct_security"
			servicekey = #a_str_storage_servicekey#
		 	object_entrykey = #arguments.entrykey#
		 	object_type = #arguments.object_type#
		 	securitycontext = #arguments.securitycontext#></cfinvoke>
			
		<cfif arguments.access_type IS "r">
			<cfreturn a_struct_security.read />
		</cfif>
		
		<cfif access_type IS "w">
			<cfreturn a_struct_security.write />
		</cfif>
		
		<cfif access_type eq "d">
			<cfreturn a_struct_security.delete />
		</cfif>
		
		<!--- default = false ... --->
		<cfreturn false />		
	</cffunction>
	
	<cffunction access="public" name="GetRootDirKey" output="false" returntype="string">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var a_bool_success = false />
		<cfset var q_select_root_directorykey = 0 />
		<cfinclude template="queries/q_select_root_directorykey.cfm">
		
		<cfif q_select_root_directorykey.recordcount lte 0 >
			<!--- Create Root Directory --->
			<cfset a_bool_success=CreateDirectory(
				usersettings=arguments.usersettings,
				directoryname="/",
				description="root",
				parentdirectorykey="",
				securitycontext=arguments.securitycontext,
				entrykey=CreateUUID(),
				allowrootdir=true)>	
				
			<cfinclude template="queries/q_select_root_directorykey.cfm">
		</cfif>
		<cfreturn q_select_root_directorykey.entrykey>
	</cffunction>
	
	<cffunction access="public" name="GetRecentFileList" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="type" type="string" default="modified" required="no"
			hint="created,downloaded,lastmodified,locked">
		<cfargument name="maxrows" type="numeric" default="50" required="no"
			hint="max number of records to return">
		
		<cfset var stReturn = StructNew()>
		
		<cfset var a_tc = GetTickCount()>
		
		<cfinclude template="utils/inc_load_recent_files.cfm">
		
		<cfreturn stReturn>
	</cffunction>
	
	
	<cffunction access="public" name="AddFile" output="false" returntype="struct"
			hint="add a new file">
		<cfargument name="filename" type="string" required="true"
			hint="the filename">
		<cfargument name="filesize" type="numeric" required="true"
			hint="the size of the file">
		<cfargument name="location" type="string" required="true"
			hint="location where to load the file from">
		<cfargument name="description" type="string" default="" required="false">
		<cfargument name="contenttype" type="string" default="binary/unknown" required="false">
		<cfargument name="directorykey" type="string" required="true"
			hint="where to store the file?">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<!--- <cfargument name="entrykey" type="string" required="true"> --->
		<cfargument name="forceoverwrite" type="boolean" required="false" default="false">

		<cfset var stReturn = GenerateReturnStruct() />
		<!--- are we in root dir? --->
		<cfset var a_str_rootdirectorykey = GetRootDirKey(securitycontext=arguments.securitycontext, usersettings=arguments.usersettings) />
		<cfset var a_bool_isrootdir = (a_str_rootdirectorykey IS arguments.directorykey) />
		
		<cfset var a_bool_versioning = false />
		<cfset var a_str_filekey = CreateUUID() />
		<cfset var a_str_filekey_of_existing_file = '' />
		<cfset var a_struct_existing_file_info = StructNew() />
		<cfset var a_int_quota = 0 />
		<cfset var a_int_usage = 0 />
		<cfset var a_query_findfile = 0 />
		<cfset var a_bol_file_already_exists = false />
		<cfset var q_select_existing_file_information = 0 />
		<cfset var q_query_dir = 0 />
		<cfset var a_str_uuid = '' />
		<cfset var SelectFileVersions = StructNew() />
		
		<cfset var a_int_newversion = 1 />
		<cfset var a_str_dir1 = '' />
		<cfset var a_str_dir2 = '' />
		<cfset var a_str_destdir = '' />
		<cfset var a_str_destfile = '' />
		<cfset var update_filescount = StructNew() />

		<!--- check if filename is valid ... --->
		<cfif NOT IsValidStorageName(arguments.filename)>
			<cfreturn SetReturnStructErrorCode(stReturn, 8100) />
		</cfif>
		
		<!--- directorykey must be provided ... --->
		<cfif Len(arguments.directorykey) IS 0>
			<cfset arguments.directorykey = a_str_rootdirectorykey />
		</cfif>
		
		<!--- set new entrykey ... --->
		<cfset stReturn.entrykey = a_str_filekey />
		
		<!--- check permissions ... --->
		<cfif not a_bool_isrootdir>
		
			<cfif not checkaccess( securitycontext = arguments.securitycontext,
				usersettings = arguments.usersettings,
				access_type = 'w',
				object_type = 'dir',
				entrykey = arguments.directorykey)>
				
				<cfreturn SetReturnStructErrorCode(stReturn, 10100) />

			</cfif>
		</cfif>
		
		<!--- Check the Quota of the User --->
		<cfinclude template="queries/q_select_user_quota.cfm">
		<cfinclude template="queries/q_select_usage.cfm">
		
		<cfset a_int_quota = q_select_user_quota.maxsize />
		
		<cfif Val(a_int_quota) IS 0>
			<cfset a_int_quota = a_int_storage_max_quota />
		</cfif>
		
		<cfset a_int_usage = val(q_select_usage.bused) />

		<cfif int(a_int_quota) LTE int(arguments.filesize) + int(a_int_usage)>
			<cfreturn SetReturnStructErrorCode(stReturn, 112) />
		</cfif>
		
		<!--- Check for duplicate filename --->
		<cfset a_query_findfile = FindFile(filename=arguments.filename,
									directorykey=arguments.directorykey,
									securitycontext=arguments.securitycontext,
									usersettings=arguments.usersettings) />
									
		<cfset a_bol_file_already_exists = (a_query_findfile.recordcount GT 0) />
									
		<!--- a file already exists with this name ... --->
		<cfif a_bol_file_already_exists>
			<cfset a_str_filekey_of_existing_file = a_query_findfile.entrykey />
			
			<!--- Check for existing File --->
			<cfset a_struct_existing_file_info = GetFileInformation(entrykey = a_str_filekey_of_existing_file,
					securitycontext = arguments.securitycontext,
					usersettings = arguments.usersettings
					) />
					
			<!--- can the file be read? if not, throw an error ... --->
			<cfif NOT a_struct_existing_file_info.result>
				<cfreturn SetReturnStructErrorCode />
			</cfif>
			
			<cfset q_select_existing_file_information = a_struct_existing_file_info.q_select_file_info />
		</cfif>
					
		<!--- Check the directory for versioning --->
		<cfset q_query_dir = GetDirectoryInformation(directorykey = arguments.directorykey,
									securitycontext = arguments.securitycontext,
									usersettings = arguments.usersettings).q_select_directory />
									
		<!--- versioning enabled or not for this directory? ... --->
		<cfset a_bool_versioning = (Val(q_query_dir.versioning) IS 1) />
									
		<cfif a_bol_file_already_exists>
			<!--- valid entrykey was supplied 'reupload' --->
			
			<!--- use the UUID of the original file ... --->
			<cfset a_str_uuid = a_struct_existing_file_info.q_select_file_info.storagefilename />
			
			<cfif NOT a_bool_versioning>

				<cfif arguments.forceoverwrite>					
					<cffile action="delete" file="#q_select_existing_file_information.storagepath##request.a_str_dir_separator##q_select_existing_file_information.storagefilename#">
				<cfelse>
					<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
				</cfif>
			</cfif>
			
			<!--- Delete File Entry --->
			<cfinclude template="queries/q_delete_old_original_file_version.cfm">
			
 		<cfelse>
			<cfset a_str_uuid = CreateUUID() />
		</cfif>
		
		<!--- versioning is enabled and the file already exists ... --->
		<cfif a_bool_versioning AND a_bol_file_already_exists>
		
			<!--- File exists, put the old one into versions. Get Max Version --->
			<cfset SelectFileVersions.entrykey = a_struct_existing_file_info.q_select_file_info.entrykey />
			<cfinclude template="queries/q_select_file_max_version.cfm">
			
			<cfif q_select_file_max_version.recordcount GT 0 and q_select_file_max_version.maxversion NEQ ''>
				<cfset a_int_newversion=q_select_file_max_version.maxversion + 1 />
			<cfelse>
				<cfset a_int_newversion = 1 />
			</cfif>
			
			<!--- Rename File. --->
			<cffile action="rename"
				destination="#q_select_existing_file_information.storagepath##request.a_str_dir_separator##q_select_existing_file_information.storagefilename#.#a_int_newversion#" 
				source="#q_select_existing_file_information.storagepath##request.a_str_dir_separator##q_select_existing_file_information.storagefilename#">

			<!--- Save Version --->
			<cfinclude template="queries/q_insert_file_version.cfm">
		</cfif>

		<!--- Copy the File into the Repository --->
		<cfset a_str_dir1 = Left(a_str_uuid,2) />
		<cfset a_str_dir2 = Right(Left(a_str_uuid,4),2) />
		<cfset a_str_destdir = request.a_str_storage_datapath & request.a_str_dir_separator & a_str_dir1 & request.a_str_dir_separator & a_str_dir2 />
		<cfset a_str_destfile = a_str_destdir & request.a_str_dir_separator & a_str_uuid />

		<!--- Try to create the 2 Directories --->
		<cftry>
			<cfdirectory action="create"  directory="#request.a_str_storage_datapath##request.a_str_dir_separator##a_str_dir1#">
		<cfcatch>
		</cfcatch>
		</cftry>
		<cftry>
			<cfdirectory action="create"  directory="#a_str_destdir#">
		<cfcatch>
		</cfcatch>
		</cftry>
		
		<!--- Move the File into the created Directory --->
		<cffile action="move" source="#arguments.location#" destination="#a_str_destfile#">
		
		<!--- Insert the File into the Database --->
		<cfinclude template="queries/q_insert_file.cfm">
		
		<cfif a_bol_file_already_exists AND a_struct_existing_file_info.result>
			<cfset update_filescount.entrykey = q_select_existing_file_information.parentdirectorykey />
		<cfelse>
			<cfset update_filescount.entrykey = arguments.directorykey />
		</cfif>
		
		<!--- Update Count for parentdirectory --->
		<cfset UpdateFilesCount(update_filescount.entrykey) />		

		<!--- generate thumbnail? --->
		<cfif ListFindNoCase(arguments.contenttype, 'image', '/') GT 0>
			<!--- image! --->
			<cfinclude template="utils/inc_generate_and_save_thumbmail.cfm">
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>

	<cffunction access="public" name="CreateDirectory" output="false" returntype="struct">
		<cfargument name="directoryname" type="string" required="true">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="displaytype" type="numeric" default="0" required="false">
		<cfargument name="parentdirectorykey" type="string" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="categories" type="string" required="false" default="">
		<cfargument name="versioning" type="numeric" required="false" default="0">
		<cfargument name="allowrootdir" type="boolean" required="false" default="false">
		
		<cfset var stReturn = GenerateReturnStruct() />
		
		<cfset var a_bool_isrootdir=false />
		<cfset var q_select_root_directorykey = 0 />
		
		<cfset var a_query_finddirectory = 0 />
		
		<cfif Len(arguments.parentdirectorykey) eq  0>
			<cfset a_bool_isrootdir = true />
			<cfinclude template="queries/q_select_root_directorykey.cfm">
			<cfset arguments.parentdirectorykey=q_select_root_directorykey.entrykey />
		</cfif>
		
		<cfif not arguments.allowrootdir>
			<cfif not checkaccess( securitycontext = arguments.securitycontext,
				usersettings = arguments.usersettings,
				access_type = 'w',
				object_type = 'dir',
				entrykey = arguments.parentdirectorykey)>
				<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
			</cfif>
		</cfif>
		
		<!--- Check for Characters --->
		<cfif not allowrootdir and Find("/",arguments.directoryname) gt 0 >
			<cfreturn SetReturnStructErrorCode(stReturn, 8100) />
		</cfif>
		
		<!--- Check for duplicate Directory --->
		<cfset
		a_query_finddirectory=FindFile(
		filename=arguments.directoryname,
		directorykey=arguments.parentdirectorykey,
		securitycontext=arguments.securitycontext,
		usersettings=arguments.usersettings
		)
		>
		<cfif a_query_finddirectory.recordcount gt 0>
			<!--- Verzeichnis existiert --->
			<cfreturn SetReturnStructErrorCode(stReturn, 8101) />
		</cfif>
		<cfif a_bool_isrootdir>
			<!--- check for privileged Filenames.  --->
			<cfif directoryname eq getlangval('sto_ph_sharedfiles',client.langno)>
				<cfreturn SetReturnStructErrorCode(stReturn, 8102) />
			</cfif>
			<cfif directoryname eq getlangval('sto_ph_workgroupfiles',client.langno)>
				<cfreturn SetReturnStructErrorCode(stReturn, 8102) />
			</cfif>
		</cfif>
		<cfinclude template="queries/q_insert_directory.cfm">

		<cfset UpdateFilesCount(arguments.parentdirectorykey) />	

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="SimpleGetFileListOfDirectories" output="false" returntype="struct"
			hint="return a query with all files found in the given directorykeys">
		<cfargument name="directorykeys" type="string" required="true" hint="the directorykeys (list)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_simple_files_of_given_directories = 0 />
		
		<cfif Len(arguments.directorykeys) IS 0>
			<cfset arguments.directorykeys = 'doesnotexist' />
		</cfif>
		
		<cfinclude template="queries/q_select_simple_files_of_given_directories.cfm">
		
		<cfset stReturn.q_select_files = q_select_simple_files_of_given_directories />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>

	<cffunction access="public" name="ListFilesAndDirectories" output="false" returntype="struct">
		<cfargument name="directorykey" type="string" required="true" hint="the directorykey">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_bool_isrootdir = false />
		<cfset var q_select_subdirectories_workgroupshared = 0 />
		<cfset var q_select_subdirectories_publicshared = 0 />
		<cfset var a_str_displayed_wg_keys = '' />
		<cfset var q_select_subdirectories_files = 0 />
		<cfset var a_str_rootdirectorykey = GetRootDirKey(securitycontext=arguments.securitycontext, usersettings=arguments.usersettings) />
		
		<cfif len(arguments.directorykey) IS 0>
			<cfset arguments.directorykey = a_str_rootdirectorykey>
		</cfif>
		
		<!--- is root directory? --->
		<cfset a_bool_isrootdir = (a_str_rootdirectorykey IS arguments.directorykey) />
		
		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'r',
			object_type = 'dir',
			entrykey = arguments.directorykey)>
				
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<cfset stReturn.directorykey=arguments.directorykey />

		<cfif arguments.directorykey eq a_str_workdir_uuid>
			<cfset stReturn.files=querynew('name,contenttype,filetype,entrykey,description,specialtype,filescount,userkey,dt_lastmodified,parentdirectory,shared,filesize')>
			
			<cfset a_str_displayed_wg_keys = ''>
			
			<cfloop query="arguments.securitycontext.q_select_workgroup_permissions">
			
				<!--- add only unique groups ... one user might be member several times (due to inherited memberships) --->
				<cfif ListFindNoCase(a_str_displayed_wg_keys, arguments.securitycontext.q_select_workgroup_permissions.workgroup_key) IS 0>
					
					<cfset a_str_displayed_wg_keys = ListAppend(a_str_displayed_wg_keys, arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)>
					
					<cfscript>
						QueryAddRow(stReturn.files);
						QuerySetCell(stReturn.files,'name',arguments.securitycontext.q_select_workgroup_permissions.workgroup_name);
		
						QuerySetCell(stReturn.files,'filetype', 'directory');
						QuerySetCell(stReturn.files,'entrykey', arguments.securitycontext.q_select_workgroup_permissions.workgroup_key);
						QuerySetCell(stReturn.files,'filescount', 0);
						QuerySetCell(stReturn.files,'filesize', 0);
						QuerySetCell(stReturn.files,'specialtype', 1);
						QuerySetCell(stReturn.files,'description', arguments.securitycontext.q_select_workgroup_permissions.workgroup_name);
						QuerySetCell(stReturn.files,'userkey', arguments.securitycontext.q_select_workgroup_permissions.workgroup_key);
						QuerySetCell(stReturn.files,'shared', 0);
						QuerySetCell(stReturn.files,'dt_lastmodified', CreateOdbcDateTime(GetUTCTime(now())));
						QuerySetCell(stReturn.files,'parentdirectory', a_str_workdir_uuid);
					</cfscript>
				
				</cfif>
			</cfloop>
			
		<cfelseif arguments.directorykey eq a_str_shared_files_uuid>
			<!--- load files and sub directories linked with directories_shareddata --->
			<cfinclude template="queries/q_select_subdirectories_workgroupshared.cfm">
			<cfset stReturn.files=q_select_subdirectories_workgroupshared>
		<cfelseif arguments.directorykey eq a_str_public_shares_uuid>
			<!--- load files and sub directories linked with directories_shareddata --->
			<cfinclude template="queries/q_select_subdirectories_publicshared.cfm">
			<cfset stReturn.files=q_select_subdirectories_publicshared>
		<cfelse>
			<!--- load files and sub directories --->
			<cfinclude template="queries/q_select_subdirectories_files.cfm">
			
			<!--- Insert special Directories into Root Dir --->
			
			<cfif a_bool_isrootdir>
				<cfscript>
					QueryAddRow(q_select_subdirectories_files);
					QuerySetCell(q_Select_subdirectories_files,'name',Getlangval('sto_ph_sharedfiles',client.langno));

					QuerySetCell(q_Select_subdirectories_files,'filetype','directory');
					QuerySetCell(q_select_subdirectories_files,'entrykey',a_str_shared_files_uuid);
					QuerySetCell(q_select_subdirectories_files,'filescount',0);
					QuerySetCell(q_select_subdirectories_files,'description','#getlangval('sto_ph_sharedfiles',client.langno)#');
					QuerySetCell(q_select_subdirectories_files,'filesize',0);
					QuerySetCell(q_select_subdirectories_files,'shared',0);
					QuerySetCell(q_select_subdirectories_files,'contenttype','');
					QuerySetCell(q_select_subdirectories_files,'dt_lastmodified',CreateOdbcDateTime(GetUTCTime(now())));
					QuerySetCell(q_select_subdirectories_files,'specialtype',1);
				</cfscript>
				<cfif arguments.securitycontext.q_select_workgroup_permissions.recordcount gt 0>
					<cfscript>
						QueryAddRow(q_select_subdirectories_files);
						QuerySetCell(q_Select_subdirectories_files,'name','#getlangval('sto_ph_workgroupfiles',client.langno)#');
		
						QuerySetCell(q_Select_subdirectories_files,'filetype','directory');
						QuerySetCell(q_select_subdirectories_files,'entrykey',a_str_workdir_uuid);
						QuerySetCell(q_select_subdirectories_files,'filesize',0);
						QuerySetCell(q_select_subdirectories_files,'filescount',0);
						QuerySetCell(q_select_subdirectories_files,'description','#getlangval('sto_ph_workgroupfiles',client.langno)#');
						QuerySetCell(q_select_subdirectories_files,'contenttype','');
						QuerySetCell(q_select_subdirectories_files,'shared',0);
						QuerySetCell(q_select_subdirectories_files,'dt_lastmodified',CreateOdbcDateTime(GetUTCTime(now())));
						QuerySetCell(q_select_subdirectories_files,'specialtype',1);
					</cfscript>
				</cfif>
			</cfif>
			<cfquery name="q_select_subdirectories_files" dbtype="query">
				SELECT * FROM q_select_subdirectories_files order by specialtype desc, filetype,name
			</cfquery>
			<cfset stReturn.files=q_select_subdirectories_files>
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>

	<cffunction access="public" name="ListAllFiles" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var stReturn = StructNew() />
		<cfset var q_select_all_files = 0 />
		<!--- load all files --->
		<cfinclude template="queries/q_select_all_files.cfm">
		<cfset stReturn.files=q_select_subdirectories_files>
		<cfreturn stReturn>
	</cffunction>

	<cffunction access="public" name="ListAllUsers" output="false" returntype="query">
		<cfinclude template="queries/q_select_all_users.cfm">
		<cfreturn q_select_all_users>
	</cffunction>

	<cffunction access="public" name="ListAllPublicfolders" output="false" returntype="query">
		<cfargument name="userkey" type="string" required="yes" default="">
		<cfinclude template="queries/q_select_all_publicfolders.cfm">
		<cfreturn q_select_all_publicfolders>
	</cffunction>

	<cffunction access="public" name="FindPublicfolder" output="false" returntype="query">
		<cfargument name="parentdirectorykey" type="string" required="no" default="">
		<cfargument name="directoryname" type="string" required="yes" default="">
		<cfinclude template="queries/q_select_publicfolder.cfm">
		
		<cfreturn q_select_publicfolder>
	</cffunction>


	<cffunction access="public" name="Public_ListFilesAndDirectories" output="false" returntype="struct">
		<!--- the directory --->
		<cfargument name="directorykey" type="string" required="true">

		<cfset var stReturn = StructNew()>
		<cfset var q_select_subdirectories_files = 0 />

		<cfset stReturn.log = StructNew()>
		<cfset stReturn.parentdir = arguments.directorykey>

		<!--- load files and sub directories --->
		<cfinclude template="queries/q_select_subdirectories_files.cfm">
		<cfquery name="q_select_subdirectories_files" dbtype="query">
			SELECT * FROM q_select_subdirectories_files order by specialtype desc, filetype,name
		</cfquery>
		<cfset stReturn.files=q_select_subdirectories_files>

		<cfreturn stReturn>
	</cffunction>

	<cffunction access="public" name="FindFile" output="false" returntype="query"
			hint="search for a certain file">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="directorykey" type="string" required="no" default="">
		<cfargument name="filename" type="string" required="no" default="">
		<cfargument name="entrykey" type="string" required="false" default="">
		<cfargument name="includeshareddirectories" type="boolean" default="false"
			hint="search in shared directories as well?">
			
		<cfset var q_select_findfile = 0 />
		<!--- despite of other filters, look in these directories for the file ... --->
		<cfset var sDirectory_keys_search_targets = '' />
		<!--- ignore the userkey critiera? use this in order to search also shared directories ... --->
		<cfset var a_bol_ignore_userkey_criteria = false />
		<cfset var a_struct_get_full_directory_list = 0 />
		
		<!--- search in all folders available to the user ... --->
		<cfif arguments.includeshareddirectories>
			<cfset a_struct_get_full_directory_list = GetFullDirectoryStructureOfUser(securitycontext = arguments.securitycontext,
							usersettings = arguments.usersettings,
							includeshareddirectories = true) />
							
			<cfset a_bol_ignore_userkey_criteria = true />
			
			<cfset sDirectory_keys_search_targets = ValueList(a_struct_get_full_directory_list.q_select_directories.entrykey) />
		</cfif>
		
		<!--- load all files&directories --->
		<cfinclude template="queries/q_select_findfile.cfm">
		
		<cfreturn q_select_findfile />
	</cffunction>

	<cffunction access="public" name="PublicFindFile" output="false" returntype="query">
		<cfargument name="directorykey" type="string" required="no" default="">
		<cfargument name="filename" type="string" required="no" default="">
		<cfargument name="entrykey" type="string" required="false" default="">
		<!--- Defines if the File will be downloaded by the calling function (traffic accounting) --->
		<cfargument name="download" type="boolean" default="false">
		
		<cfset var UpdateTraffic = StructNew() />
		<cfset var q_select_publicfindfile = 0 />
		
		<!--- load all files&directories --->
		<cfinclude template="queries/q_select_publicfindfile.cfm">
		<cfset UpdateTraffic.userkey=q_select_publicfindfile.userkey>
		<cfif len(q_select_publicfindfile.filesize) lte 0 >
			<cfset q_select_publicfindfile.filesize=0>
			<cfset UpdateTraffic.kbused=0>
		<cfelse>
			<cfset UpdateTraffic.kbused=q_select_publicfindfile.filesize/1024>
		</cfif>
		<cfif arguments.download>
			<cfinclude template="queries/q_update_traffic.cfm">
			<cfif q_select_traffic.recordcount gt 0 >
				<cfif (q_select_traffic.kbused+UpdateTraffic.kbused) gt q_select_traffic.kblimit>
					<!---<cfthrow detail="Traffic Limit Reached" errorcode="99">--->
				</cfif>			
			</cfif>
		</cfif>
		<cfreturn q_select_publicfindfile>
	</cffunction>
	
	<cffunction access="public" name="GetDirectoryInformationStatistics" output="false" returntype="struct"
			hint="return some information about a certain directory">
		<cfargument name="directorykey" type="string" required="true" hint="entrykey of directory">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var stReturn = StructNew() />
		<cfset var a_bool_isrootdir = false />
		
		<cfif len(arguments.directorykey) IS 0>
			<cfset arguments.directorykey = GetRootDirKey(securitycontext = arguments.securitycontext, usersettings = arguments.usersettings)>
		</cfif>
		
		<!--- return the space needed of the files in this directory and the number of files ... --->
		
		<cfif not checkaccess(securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = "r",
			object_type = "dir",
			entrykey = arguments.directorykey)>
			<!--- no read permission? exit! --->
			<cfreturn stReturn>
		</cfif>
		
		<!--- get filesize and number of files --->
		<cfinclude template="queries/q_select_folder_statistics.cfm">
		
		<cfset stReturn.folder_size = val(q_select_folder_size.SUM_filesize)>
		<cfset stReturn.count_elements = val(q_select_objects_in_directory.count_elements)>
			
		<cfreturn stReturn>
	</cffunction>

	<cffunction access="public" name="GetDirectoryInformation" output="false" returntype="struct"
		hint="return information about directory">
		<cfargument name="directorykey" type="string" required="true" hint="entrykey of directory">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_bool_isrootdir = false />
		<cfset var q_select_directory = 0 />
		
		<cfset var a_bool_found = false />
		<cfset var SelectDirectoryRequest = StructNew() />
		<cfset var a_str_rootdirectorykey = GetRootDirKey(securitycontext=arguments.securitycontext, usersettings=arguments.usersettings) />
		<cfset var a_str_default_query_fields = 'shared_directorykey,publicshare_directorykey,directorykey,directoryname,description,parentdirectorykey,shared_workgroupkey,publicshare_directorykey,displaytype,specialtype,versioning,userkey' />

		<cfif len(arguments.directorykey) IS 0>
			<cfset arguments.directorykey = a_str_rootdirectorykey />
		</cfif>
		
		<cfset a_bool_isrootdir = (a_str_rootdirectorykey IS arguments.directorykey) />
		
		<cfif not checkaccess(securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = "r",
			object_type = "dir",
			entrykey = arguments.directorykey)>
						
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<cfset SelectDirectoryRequest.directorykey = arguments.directorykey />
		
		<cfswitch expression="#arguments.directorykey#">
			<cfcase value="a_str_shared_files_uuid">
				
				<cfset q_select_directory = QueryNew(a_str_default_query_fields) />
				<cfset QueryAddRow(q_select_directory) />
				<cfset QuerySetCell(q_select_directory, 'directorykey', a_str_shared_files_uuid) />
				<cfset QuerySetCell(q_select_directory, 'parentdirectorykey','') />
				<cfset QuerySetCell(q_select_directory, 'description',getlangval('sto_ph_sharedfiles',client.langno)) />
				<cfset QuerySetCell(q_select_directory, 'shared_workgroupkey','') />
				<cfset QuerySetCell(q_select_directory, 'publicshare_directorykey','') />
				<cfset QuerySetCell(q_select_directory, 'displaytype','') />
				<cfset QuerySetCell(q_select_directory, 'shared_directorykey','') />
				<cfset QuerySetCell(q_select_directory, 'publicshare_directorykey','') />
				<cfset QuerySetCell(q_select_directory, 'specialtype',1) />
				<cfset QuerySetCell(q_select_directory, 'versioning',0) />
				<cfset QuerySetCell(q_select_directory, 'directoryname',getlangval('sto_ph_sharedfiles',client.langno)) />
				
			</cfcase>
			<cfcase value="a_str_workdir_uuid">
				
				<cfset q_select_directory=QueryNew(a_str_default_query_fields)>
				<cfset QueryAddRow(q_select_directory)>
				<cfset QuerySetCell(q_select_directory,'directorykey',a_str_workdir_uuid)>
				<cfset QuerySetCell(q_select_directory,'parentdirectorykey','')>
				<cfset QuerySetCell(q_select_directory,'shared_workgroupkey','')>
				<cfset QuerySetCell(q_select_directory,'publicshare_directorykey','')>
				<cfset QuerySetCell(q_select_directory,'description',getlangval('sto_ph_workgroupfiles',client.langno))>
				<cfset QuerySetCell(q_select_directory,'displaytype','')>
				<cfset QuerySetCell(q_select_directory,'shared_directorykey','')>
				<cfset QuerySetCell(q_select_directory,'publicshare_directorykey','')>
				<cfset QuerySetCell(q_select_directory,'specialtype',1)>
				<cfset QuerySetCell(q_select_directory,'versioning',0)>
				<cfset QuerySetCell(q_select_directory,'directoryname',getlangval('sto_ph_workgroupfiles',client.langno))>
				
			</cfcase>
			<cfcase value="a_str_public_shares_uuid">
				
				<cfset q_select_directory = QueryNew(a_str_default_query_fields) />
				<cfset QueryAddRow(q_select_directory)>
				<cfset QuerySetCell(q_select_directory,'directorykey',a_str_public_shares_uuid)>
				<cfset QuerySetCell(q_select_directory,'parentdirectorykey','')>
				<cfset QuerySetCell(q_select_directory,'shared_workgroupkey','')>
				<cfset QuerySetCell(q_select_directory,'publicshare_directorykey','')>
				<cfset QuerySetCell(q_select_directory,'description',getlangval('sto_ph_publicfiles',client.langno))>
				<cfset QuerySetCell(q_select_directory,'displaytype','')>
				<cfset QuerySetCell(q_select_directory,'shared_directorykey','')>
				<cfset QuerySetCell(q_select_directory,'publicshare_directorykey','')>
				<cfset QuerySetCell(q_select_directory,'specialtype',1)>
				<cfset QuerySetCell(q_select_directory,'versioning',0)>
				<cfset QuerySetCell(q_select_directory,'directoryname',getlangval('sto_ph_publicfiles',client.langno))>
			</cfcase>
			<cfdefaultcase>
				
				<cfset a_bool_found = false />
				
				<cfloop query="arguments.securitycontext.q_select_workgroup_permissions">
				<cfif SelectDirectoryRequest.directorykey eq arguments.securitycontext.q_select_workgroup_permissions.workgroup_key>
					<cfset a_bool_found=true>
					<cfset q_select_directory=QueryNew(a_str_default_query_fields)>
					<cfset QueryAddRow(q_select_directory)>
					<cfset QuerySetCell(q_select_directory,'directorykey',arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)>
					<cfset QuerySetCell(q_select_directory,'parentdirectorykey',a_str_workdir_uuid)>
					<cfset QuerySetCell(q_select_directory,'shared_workgroupkey','')>
					<cfset QuerySetCell(q_select_directory,'description',arguments.securitycontext.q_select_workgroup_permissions.workgroup_name)>
					<cfset QuerySetCell(q_select_directory,'publicshare_directorykey','')>
					<cfset QuerySetCell(q_select_directory,'displaytype','')>
					<cfset QuerySetCell(q_select_directory,'shared_directorykey','')>
					<cfset QuerySetCell(q_select_directory,'publicshare_directorykey','')>
					<cfset QuerySetCell(q_select_directory,'specialtype',1)>
					<cfset QuerySetCell(q_select_directory,'versioning',0)>
					<cfset QuerySetCell(q_select_directory,'directoryname',arguments.securitycontext.q_select_workgroup_permissions.workgroup_name)>
				</cfif>
				
			</cfloop>
			
			<cfif not a_bool_found >
				<cfset SelectDirectoryRequest.directorykey = arguments.directorykey>
				<cfinclude template="queries/q_select_directory.cfm">
				
				<cfif a_bool_isrootdir>
					<cfset QuerySetCell(q_select_directory,'specialtype',1) />
				</cfif>
			</cfif>
				
			</cfdefaultcase>
		</cfswitch>
		
		<cfset stReturn.q_select_directory = q_select_directory />
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>


	<cffunction access="public" name="PublicGetDirectoryInformation" output="false" returntype="query">
		<!--- the directory --->
		<cfargument name="directorykey" type="string" required="true">
			
		<cfset var SelectDirectoryRequest = StructNew() />
		<cfset var q_select_directory = 0 />
			
		<cfset SelectDirectoryRequest.directorykey = arguments.directorykey>
		<cfset SelectDirectoryRequest.directorykey = arguments.directorykey>
		<cfinclude template="queries/q_select_directory.cfm">
		<cfreturn q_select_directory>
	</cffunction>


	<cffunction access="public" name="GetUpperDirectory" output="false" returntype="struct">
		<cfargument name="directorykey" type="string" required="true" hint="entrykey of directory">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		
		<cfset var stReturn=StructNew() />
		<cfset var SelectDirectoryRequest = StructNew() />
		<cfset var q_select_parent_directory = 0 />
		
		<cfset SelectDirectoryRequest.directorykey=arguments.directorykey>
		<cfinclude template="queries/q_select_parent_directory.cfm">
		
		<cfset stReturn.parentdirectorykey=q_select_parent_directory.parentdirectorykey>
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="ReturnParentDirectorykeyOfDirectory" returntype="string" output="false"
		hint="return the entrykey of the parent directory as string">
		<cfargument name="directorykey" type="string" required="yes">
		
		<cfset var SelectDirectoryRequest = StructNew() />
		<cfset var q_select_parent_directory = 0 />
		
		<cfset SelectDirectoryRequest.directorykey = arguments.directorykey>
		<cfinclude template="queries/q_select_parent_directory.cfm">
		
		<cfreturn q_select_parent_directory.parentdirectorykey>
	</cffunction>

	<cffunction access="public" name="GetParentDirectories" output="false" returntype="struct"
		hint="return information about parent directories">
		<cfargument name="directorykey" type="string" required="true" hint="the directory">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">

		<cfset var stReturn=StructNew() />
		<cfset var q_select_parent_directory = 0 />
		<cfset var SelectDirectoryRequest = StructNew() />
		<cfset var a_str_currentkey = '' />
		
		<cfset var a_bool_found = false />	 
		<cfset var q_directory_info = 0 />
		<cfset var a_str_rootdirkey = '' />
		<cfset var a_int_index = 0 />
		
		<cfset stReturn.depth=0>
		<cfset a_str_currentkey=arguments.directorykey>
		
		<cfset q_select_parent_directory = GetDirectoryInformation(directorykey = a_str_currentkey,
			securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings).q_select_directory />

		<cfloop index="a_int_index" from="1" to="99">
			<cfset stReturn.depth=stReturn.depth>
			<cfset SelectDirectoryRequest.directorykey=a_str_currentkey>
			<cfif SelectDirectoryRequest.directorykey eq a_str_shared_files_uuid>
				<cfinclude template="queries/q_select_root_directorykey.cfm">
				<cfset q_select_parent_directory=QueryNew('directorykey,directoryname,parentdirectorykey,userkey')>
				<cfset QueryAddRow(q_select_parent_directory)>
				<cfset QuerySetCell(q_select_parent_directory,'directorykey',a_str_shared_files_uuid)>
				<cfset QuerySetCell(q_select_parent_directory,'parentdirectorykey',q_select_root_directorykey.entrykey)>
				<cfset QuerySetCell(q_select_parent_directory,'directoryname','/')>
				<cfset QuerySetCell(q_select_parent_directory,'userkey',arguments.securitycontext.myuserkey)>
				
			<cfelseif SelectDirectoryRequest.directorykey eq a_str_workdir_uuid>
				<cfinclude template="queries/q_select_root_directorykey.cfm">
				<cfset q_select_parent_directory=QueryNew('directorykey,directoryname,parentdirectorykey,userkey')>
				<cfset QueryAddRow(q_select_parent_directory)>
				<cfset QuerySetCell(q_select_parent_directory,'directorykey',a_str_workdir_uuid)>
				<cfset QuerySetCell(q_select_parent_directory,'parentdirectorykey',q_select_root_directorykey.entrykey)>
				<cfset QuerySetCell(q_select_parent_directory,'directoryname','/')>
				<cfset QuerySetCell(q_select_parent_directory,'userkey',arguments.securitycontext.myuserkey)>

			<cfelseif SelectDirectoryRequest.directorykey eq a_str_public_shares_uuid>
				<cfinclude template="queries/q_select_root_directorykey.cfm">
				<cfset q_select_parent_directory=QueryNew('directorykey,directoryname,parentdirectorykey,userkey')>
				<cfset QueryAddRow(q_select_parent_directory)>
				<cfset QuerySetCell(q_select_parent_directory,'directorykey',a_str_public_shares_uuid)>
				<cfset QuerySetCell(q_select_parent_directory,'parentdirectorykey',q_select_root_directorykey.entrykey)>
				<cfset QuerySetCell(q_select_parent_directory,'directoryname','/')>
				<cfset QuerySetCell(q_select_parent_directory,'userkey',arguments.securitycontext.myuserkey)>

			<cfelse>
				<cfset a_bool_found=false>
				<cfloop query="arguments.securitycontext.q_select_workgroup_permissions">
					<cfif arguments.securitycontext.q_select_workgroup_permissions.workgroup_key eq SelectDirectoryRequest.directorykey>
						<cfset a_bool_found=true>
						<cfset q_select_parent_directory=QueryNew('directorykey,directoryname,parentdirectorykey,userkey')>
						<cfset QueryAddRow(q_select_parent_directory)>
						<cfset QuerySetCell(q_select_parent_directory,'directorykey',arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)>
						<cfset QuerySetCell(q_select_parent_directory,'parentdirectorykey',a_str_workdir_uuid)>
						<cfset QuerySetCell(q_select_parent_directory,'directoryname',getlangval('sto_ph_workgroupfiles',client.langno))>
						<cfset QuerySetCell(q_select_parent_directory,'userkey',arguments.securitycontext.myuserkey)>
					</cfif>
				</cfloop>
				<cfif (not a_bool_found) and q_select_parent_directory.userkey neq arguments.securitycontext.myuserkey>
					<cfset q_directory_info=GetDirectoryInformation(
						directorykey=a_str_currentkey,
						securitycontext=arguments.securitycontext,
						usersettings=arguments.usersettings
						).q_select_directory /
					>
					<cfif len(q_directory_info.shared_directorykey) gt 0 >
						<cfset a_bool_found=true>
						<cfset q_select_parent_directory=QueryNew('directorykey,directoryname,parentdirectorykey,userkey')>
						<cfset QueryAddRow(q_select_parent_directory)>
						<cfset QuerySetCell(q_select_parent_directory,'directorykey',a_str_currentkey)>
						<cfset QuerySetCell(q_select_parent_directory,'parentdirectorykey',a_str_shared_files_uuid)>
						<cfset QuerySetCell(q_select_parent_directory,'directoryname',getlangval('sto_ph_sharedfiles',client.langno))>
						<cfset QuerySetCell(q_select_parent_directory,'userkey',arguments.securitycontext.myuserkey)>
					</cfif>
				</cfif>
				<cfif not a_bool_found>
					<cfinclude template="queries/q_select_parent_directory.cfm">
				</cfif>
			</cfif>
<!---
			<cfset tmp=ArrayAppend(stReturn.log,q_select_parent_directory)>
--->
			<cfset stReturn[q_select_parent_directory.parentdirectorykey]=StructNew()>
			<cfset stReturn[q_select_parent_directory.parentdirectorykey].subdirectorykey=			
			   SelectDirectoryRequest.directorykey>
			<cfset stReturn[q_select_parent_directory.parentdirectorykey].name=			
			   q_select_parent_directory.directoryname>
			<cfif  q_select_parent_directory.parentdirectorykey is ''>
				<cfbreak>
			</cfif>
			<cfset a_str_currentkey=q_select_parent_directory.parentdirectorykey>
		</cfloop>
		<!--- Insert Special Directories --->
		<cfset a_str_rootdirkey=a_str_currentkey>
		
		<cfreturn stReturn>
	</cffunction>
	
	<cffunction access="public" name="EditPublicShare" output="false" returntype="boolean">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings ... --->
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="password" type="string" required="no" default="">
		<cfargument name="action" type="string" required="no" default="add">

		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'w',
			object_type = 'dir',
			entrykey = arguments.entrykey)>
			<cfreturn false>
		</cfif>

		<cfif arguments.action eq "add">
			<cfinclude template="queries/q_insert_publicshare.cfm">
		<cfelseif arguments.action eq "update">
			<cfinclude template="queries/q_update_publicshare.cfm">
		<cfelse> 
			<cfinclude template="queries/q_delete_publicshare.cfm">
		</cfif>
		<cfreturn true>
	</cffunction>
	
	
	<cffunction access="public" name="EditWorkgroupShare" output="false" returntype="boolean">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings ... --->
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="workgroupkey" type="string" required="true">
		<cfargument name="action" type="string" required="false" default="add">
		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'w',
			object_type = 'dir',
			entrykey = arguments.entrykey)>
			<cfreturn false>
		</cfif>
		<cfif arguments.action eq "delete">
			<cfinclude template="queries/q_delete_workgroupshare.cfm">
		<cfelse>
			<cfinclude template="queries/q_insert_workgroupshare.cfm">
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="EditDirectory" output="false" returntype="struct"
			hint="edit dir proeprties">
		<cfargument name="directoryname" type="string" required="true">
		<cfargument name="description" type="string" required="false" default="">
		<cfargument name="displaytype" type="numeric" default="0" required="false">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings ... --->
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="categories" type="string" required="false" default="">
		<cfargument name="versioning" type="numeric" required="false" default="0">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_bool_isrootdir=false>
		<cfset var SelectDirectoryRequest = StructNew() />

		<cfset SelectDirectoryRequest.directorykey=arguments.entrykey>
		<cfinclude template="queries/q_select_directory.cfm">
		<cfif len(q_select_directory.shared_directorykey) gt 0  or 
			len(q_select_directory.publicshare_directorykey) gt 0 >
			<!--- Override Directory name for shared Directories --->
			<cfset arguments.directoryname=q_select_directory.directoryname>
		</cfif>
		<cfinclude template="queries/q_select_root_directorykey.cfm">
		<cfset a_bool_isrootdir=false>
		<cfif  q_select_directory.parentdirectorykey eq q_select_root_directorykey.entrykey>
			<cfset a_bool_isrootdir=true>
		</cfif>
		<cfif arguments.entrykey eq q_select_root_directorykey.entrykey>
			<!--- Override Name for Root Directory --->
			<cfset arguments.directoryname='/'>
		<cfelse>
		
			<cfif NOT IsValidStorageName(arguments.directoryname)>
				<cfreturn SetReturnStructErrorCode(stReturn, 8100) />
			</cfif>
			
		</cfif>
		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'w',
			object_type = 'dir',
			entrykey = arguments.entrykey)>
			<cfreturn false>
		</cfif>

		<cfif a_bool_isrootdir>
			<!--- check for privileged Filenames.  --->
			<cfif directoryname eq getlangval('sto_ph_sharedfiles',client.langno)>
				<cfreturn false>
			</cfif>
			<cfif directoryname eq getlangval('sto_ph_workgroupfiles',client.langno)>
				<cfreturn false>
			</cfif>
		</cfif>


		<cfinclude template="queries/q_update_directory.cfm">

		<cfreturn SetReturnStructSuccessCode(stReturn) />
		
	</cffunction>
	
	<cffunction access="public" name="DeleteFile" output="false" returntype="struct"
			hint="delete a file">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the file to delete">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var update_filescount = StructNew() />
		<cfset var sFilename_delete = '' />
		<cfset var q_query_file = 0 />
		

		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'd',
			object_type = 'file',
			entrykey = arguments.entrykey)>
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<!--- Check for existing File --->
		<cfset q_query_file = GetFileInformation(entrykey=arguments.entrykey,
									securitycontext=arguments.securitycontext,
									usersettings=arguments.usersettings
									).q_select_file_info />
									
		<!--- Delete the real file --->
		<cfset sFilename_delete = q_query_file.storagepath & request.a_str_dir_separator & q_query_file.storagefilename />
		<cfif FileExists(sFilename_delete)>
			<cffile action="delete" file="#sFilename_delete#">
		</cfif>
		
		<cfinclude template="queries/q_delete_file.cfm">
		
		<cfset UpdateFilesCount(q_query_file.parentdirectorykey) />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>

	<cffunction access="public" name="Deleteoldversions" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">

		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'd',
			object_type = 'file',
			entrykey = arguments.entrykey)>
			<cfreturn false>
		</cfif>


		<cfinclude template="queries/q_delete_oldversions.cfm">
		
		<cfreturn true>
	</cffunction>

	<cffunction access="public" name="DeleteDirectory" output="false" returntype="boolean">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">

		<cfset var SelectDirectoryRequest = StructNew() />
		<cfset 0 />
		
		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'd',
			object_type = 'dir',
			entrykey = arguments.entrykey)>
			<cfreturn false>
		</cfif>

		<cfset SelectDirectoryRequest.directorykey=arguments.entrykey>
		<cfinclude template="queries/q_select_directory.cfm">
		<!--- only delete empty directories (depending on the directory record itself) --->
		<cfif q_select_directory.filescount lte 0 >
			<cfinclude template="queries/q_delete_directory.cfm">

			<cfset UpdateFilesCount(q_select_directory.parentdirectorykey) />
			
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>
	
	<cffunction name="GeneratePathInformation" output="false" returntype="query">
		<cfargument name="directorykey" type="string" required="true">
		
		<cfset var q_select_path = 0 />
		
		<cfset q_select_path = QueryNew('directorykey,directoryname,description,parentdirectorykey')>
		
		<cfmodule template="utils/mod_add_parent_directory.cfm" directorykey=#arguments.directorykey# query=#q_select_path#>
		
		<cfreturn q_select_path>
		
	</cffunction>
	
	<cffunction name="CheckPublicAccessToDirectory" output="false" returntype="boolean">
		<cfargument name="directorykey" type="string" required="true">

		<cfreturn false>
	</cffunction>

	<!--- return the total number of own records ... --->
	<cffunction access="public" name="GetOwnRecordsRecordcount" output="false" returntype="numeric">
		<cfargument name="userkey" type="string" required="true">

		<cfinclude template="queries/q_select_own_files_recordcount.cfm">

		<cfreturn VAL(q_select_own_files_recordcount.count_id)>
	</cffunction>

	<cffunction access="public" name="GetFileInformation" output="false" returntype="struct"
			hint="Return information about a file">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="version" type="numeric" default="0">
		<cfargument name="download" type="boolean" default="false"
			hint="Defines if the File will be downloaded by the calling function (traffic accounting) ">
		<cfargument name="LoadSecurityPermissions" default="false" type="boolean"
			hint="return security permissions as well">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_file = 0 />
		<cfset var SelectFileVersion = StructNew() />
		<cfset var UpdateTraffic = StructNew() />
		<cfset var a_struct_security = StructNew() />
		<cfset var SelectFileRequest = StructNew() />

		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'r',
			object_type = 'file',
			entrykey = arguments.entrykey)>
				
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfif arguments.LoadSecurityPermissions>
			
			<cfinvoke component = "#application.components.cmp_security#"
			 	method = "GetPermissionsForObject"
			 	returnVariable = "a_struct_security"
				servicekey = #a_str_storage_servicekey#
			 	object_entrykey = #arguments.entrykey#
			 	object_type = 'file'
			 	securitycontext = #arguments.securitycontext#>
			</cfinvoke>
			
			<cfset stReturn.a_struct_security_permissions = a_struct_security />
		</cfif>

		<!--- select recent or old version ... --->
		<cfif arguments.version LTE 0>
			<cfset SelectFileRequest.entrykey = arguments.entrykey />
			<cfinclude template="queries/q_select_file.cfm" />
		<cfelse>
			<cfset SelectFileVersion.entrykey = arguments.entrykey />
			<cfset SelectFileVersion.version = arguments.version />
			<cfinclude template="queries/q_select_file_version.cfm">
		</cfif>
		
		<cfif arguments.download>
			<cfset UpdateTraffic.kbused = q_select_file.filesize / 1024 />
			<cfset UpdateTraffic.userkey = q_select_file.userkey />
			
			<cfinclude template="queries/q_update_traffic.cfm">
			
			<cfif q_select_traffic.recordcount GT 0 >
				<cfif (q_select_traffic.kbused + UpdateTraffic.kbused) GT q_select_traffic.kblimit>
					
					<!--- traffic limit reached ... --->
					<cfreturn SetReturnStructErrorCode(stReturn, 8150) />
				</cfif>			
			</cfif>
		</cfif>
		
		<cfset stReturn.q_select_file_info = q_select_file />
		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<cffunction access="public" name="UpdateFileInformation" output="false" returntype="struct"
			hint="update file information (and possibly .html content)">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of file">
		<cfargument name="filename" type="string" required="true"
			hint="the filename">
		<cfargument name="description" type="string" required="false" default="" hint="description">
		<cfargument name="categories" type="string" required="false" default=""
			hint="categories of file">
		<cfargument name="contenttype" type="string" required="false" default="unknown/binary"
			hint="content type">
		<cfargument name="filecontent" type="string" required="no" default=""
			hint="filecontent (if not empty AND only if HTML file) ... utf-8 encoded">

		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_struct_sql = StructNew() />
		<cfset var sFilename = '' />
		<cfset var a_struct_add_file = 0 />
		<cfset var a_struct_lock = 0 />
		<cfset var stReturn_sql = 0 />
		
		<cfinvoke component="#application.components.cmp_locks#" method="CreateExclusiveLock" returnvariable="a_struct_lock">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="servicekey" value="#a_str_storage_servicekey#">
			<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
		</cfinvoke>
		
		<cfif NOT a_struct_lock.result>
			<cfreturn a_struct_lock />
		</cfif>

		<!--- valid name? --->
		<cfif NOT IsValidStorageName(arguments.filename)>
			<cfreturn SetReturnStructErrorCode(stReturn, 8100) />
		</cfif>

		<cfif NOT checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'w',
			object_type = 'file',
			entrykey = arguments.entrykey)>
			
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<!--- standard update function ... --->
		<cfset a_struct_sql.entrykey = arguments.entrykey />
		<cfset a_struct_sql = AddToStructIfNotEmpty(a_struct_sql, 'filename', arguments.filename) />
		<cfset a_struct_sql = AddToStructIfNotEmpty(a_struct_sql, 'contenttype', arguments.contenttype) />
		<cfset a_struct_sql = AddToStructIfNotEmpty(a_struct_sql, 'description', arguments.description) />
		<cfset a_struct_sql = AddToStructIfNotEmpty(a_struct_sql, 'categories', arguments.categories) />
		
		<cfinvoke component="#application.components.cmp_sql#" method="InsertUpdateRecord" returnvariable="stReturn_sql">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="database" value="#request.a_str_db_tools#">
			<cfinvokeargument name="table" value="storagefiles">
			<cfinvokeargument name="data" value="#a_struct_sql#">
			<cfinvokeargument name="action" value="UPDATE">
			<cfinvokeargument name="primary_field" value="entrykey">
		</cfinvoke>
		
		<cfif NOT stReturn_sql.result>
			<cfreturn stReturn_sql />
		</cfif>
		
		<cfif (arguments.contenttype IS 'text/html') AND (Len(arguments.filecontent) GT 0)>
			<!--- update file content ... --->
			
			<!--- save tmp file ... --->
			<cfset sFilename = request.a_Str_temp_directory & createuuid() & '.html' />
			<cffile action="write" addnewline="no" charset="utf-8" file="#sFilename#" output="#arguments.filecontent#">
			
			<cfset a_struct_add_file = AddFile(filename = arguments.filename,
						location = sFilename,
						description = arguments.description,
						contenttype = "text/html",
						directorykey = GetDirectoryKeyOfFile(filekey = arguments.entrykey),
						securitycontext = arguments.securitycontext,
						usersettings = arguments.usersettings,
						entrykey = CreateUUID(),
						filesize = fileSize(sFilename),
						forceoverwrite = true) />
								
		</cfif>
		
		<cfinvoke component="#application.components.cmp_locks#" method="RemoveExclusiveLock" returnvariable="a_struct_lock">
			<cfinvokeargument name="securitycontext" value="#arguments.securitycontext#">
			<cfinvokeargument name="usersettings" value="#arguments.usersettings#">
			<cfinvokeargument name="servicekey" value="#a_str_storage_servicekey#">
			<cfinvokeargument name="objectkey" value="#arguments.entrykey#">
		</cfinvoke>

		<cfreturn SetReturnStructSuccessCode(stReturn) />

	</cffunction>

	<cffunction access="public" name="GetVersionInformation" output="false" returntype="query">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		<!--- user settings ... --->
		<cfargument name="usersettings" type="struct" required="true">

		<cfargument name="entrykey" type="string" required="true">

		<cfset var SelectFileVersions = StructNew() />
		<cfset var q_select_file_versions = false />
		<cfif not checkaccess( securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'r',
			object_type = 'file',
			entrykey = arguments.entrykey)>
			<cfreturn false>
		</cfif>


		<cfset SelectFileVersions.entrykey=arguments.entrykey>
		<cfinclude template="queries/q_select_file_versions.cfm">
		<cfreturn q_select_file_versions>

	</cffunction>

	<cffunction access="public" name="Search" output="true" returntype="struct"
			hint="search storage for files">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="searchstring" type="string" required="true">
		<cfargument name="page" type="numeric" default="0">
		<cfargument name="fulltext" type="boolean" default="false" required="false">
		<cfargument name="types" type="string" default="file,directory" required="false"
			hint="what to look for ...">
		<cfargument name="includeshareddirectories" type="boolean" default="false"
			hint="search in all available directories to the user? if false, just in his own ...">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var a_query_items = QueryNew('entrykey,excerpt') />
		<cfset var a_query_findfile = 0 />
		
		<cfset var xnResults = 0 />
		<cfset var CFHTTP = 0 />
		<cfset var a_str_xml = '' />
		<cfset var a_xml_doc = 0 />
		<cfset var a_int_to = 0 />
		<cfset var entrykey = '' />
		<cfset var xnItem = 0 />
		<cfset var temp = false />
		<cfset var entrykeyidx = '' />
		<cfset var a_int_index_ii = 0 />
		
		<!--- <cfif arguments.fulltext>
			<!--- Retreive Search Result --->
			<cfhttp 
				method="get"
				url="#request.a_str_search_url#?restrict=#URLEncodedFormat(securitycontext.myuserkey)#&words=#URLEncodedFormat(arguments.searchstring)#&page=#arguments.page+1#&matchesperpage=#arguments.matchesperpage#">
			</cfhttp>
			<!--- create a structure from an xml file ... anzahl der ebenen beachten!! --->
			<cfset a_str_xml = cfhttp.fileContent>
			<cfif NOT IsXMLDoc(a_str_xml)>
				<!--- kein xml file --->
			</cfif>
	
			<!--- xml parsen + object erstellen --->
			<cfset a_xml_doc = XmlParse(a_str_xml)>
	
			<CFSET xnResults = a_xml_doc.XmlRoot>
	
			<!--- array holding the items ... --->
			<cfset stReturn=StructNew()>
			<cfset a_int_to = ArrayLen(xnResults.XmlChildren)>
			<cfset a_query_items = QueryNew ('entrykey,excerpt')>
			<cfloop index="a_int_index_ii" from="1" to="#a_int_to#">
				<cfset xnItem = xnResults.XmlChildren[a_int_index_ii]>
				<cfif xnItem.XmlName is 'MATCH'>
					<cfset temp=QueryAddRow(a_query_items)>
					<cfset entrykey=Replace(xnItem.URL.XmlText,"/v","")>
					<cfset entrykey=Replace(entrykey,"/f","")>
					<cfset entrykeyidx=REFind("[^/]*$",entrykey)>
					<cfset entrykey=Right(entrykey,len(entrykey)-entrykeyidx+1)>
					<cfset temp=QuerySetCell(a_query_items,'entrykey',entrykey)>
					<cfset temp=QuerySetCell(a_query_items,'excerpt',xnItem.EXCERPT.XmlText)>
				</cfif>
			</cfloop>
	
			<cfset stReturn.foundrecords=xnResults.MATCHES.xmlText>
		</cfif> --->
		
		<cfset a_query_findfile = FindFile(securitycontext=arguments.securitycontext,
			usersettings=arguments.usersettings,
			filename = '%'&arguments.searchstring&'%',
			includeshareddirectories = arguments.includeshareddirectories) />
			
		<cfset stReturn.query = a_query_findfile />

		<cfset stReturn.expanded_query = QueryNew('filetype,entrykey,name,description,categories,filesize,contenttype,userkey,filescount,specialtype,dt_created,dt_lastmodified,shared,locked') />

		<cfloop query="stReturn.query">
			
			<cfset QueryAddRow(stReturn.expanded_query) />
			
			<cfset a_query_findfile=FindFile(securitycontext=arguments.securitycontext,
				usersettings=arguments.usersettings,
				entrykey=stReturn.query.entrykey,
				includeshareddirectories = arguments.includeshareddirectories) />
				
			<cfif a_query_findfile.recordcount IS 1>
				<cfset QuerySetCell(stReturn.expanded_query,"filetype",a_query_findfile.filetype)>
				<cfset QuerySetCell(stReturn.expanded_query,"locked",a_query_findfile.locked)>
				<cfset QuerySetCell(stReturn.expanded_query,"specialtype",a_query_findfile.specialtype)>
				<cfset QuerySetCell(stReturn.expanded_query,"filescount",a_query_findfile.filescount)>
				<cfset QuerySetCell(stReturn.expanded_query,"entrykey",a_query_findfile.entrykey)>
				<cfset QuerySetCell(stReturn.expanded_query,"name",a_query_findfile.name)>
				<cfset QuerySetCell(stReturn.expanded_query,"description",a_query_findfile.description)>
				<cfset QuerySetCell(stReturn.expanded_query,"categories",a_query_findfile.categories)>
				<cfset QuerySetCell(stReturn.expanded_query,"filesize",a_query_findfile.filesize)>
				<cfset QuerySetCell(stReturn.expanded_query,"contenttype",a_query_findfile.contenttype)>
				<cfset QuerySetCell(stReturn.expanded_query,"userkey",a_query_findfile.userkey)>
				<cfset QuerySetCell(stReturn.expanded_query,"dt_created",a_query_findfile.dt_created)>
				<cfset QuerySetCell(stReturn.expanded_query,"dt_lastmodified",a_query_findfile.dt_lastmodified)>
				<cfset QuerySetCell(stReturn.expanded_query,"shared",0)>
			</cfif>
		</cfloop>
		
		<cfset stReturn.foundrecords=stReturn.expanded_query.recordcount />
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="private" name="GetFullDirectoryStructureOfUser_AddSpecialDirectory" output="false" returntype="query"
			hint="Add a virtual, non existing table item to the list">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="query" type="query" required="true">
		<cfargument name="directoryname" type="string" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="parentdirectorykey" type="string" required="false" default="">
		<cfargument name="currentlevel" type="numeric" default="0" required="false">
		
		<cfset var q_select_new_item = QueryNew('currentlevel,entrykey,directoryname,parentdirectorykey,description,filescount,dt_created,dt_lastmodified,userkey', 'BigInt,VarChar,VarChar,VarChar,VarChar,BigInt,date,date,VarChar') />
		<cfset QueryAddRow(q_select_new_item, 1) />

		<cfset QuerySetCell(q_select_new_item, 'directoryname', arguments.directoryname, 1) />
		<cfset QuerySetCell(q_select_new_item, 'entrykey', arguments.entrykey, 1) />
		<cfset QuerySetCell(q_select_new_item, 'parentdirectorykey', arguments.parentdirectorykey, 1) />
		<cfset QuerySetCell(q_select_new_item, 'currentlevel', arguments.currentlevel, 1) />
		<cfset QuerySetCell(q_select_new_item, 'filescount', 0, 1) />
		<cfset QuerySetCell(q_select_new_item, 'dt_created', '2000-01-01 00:00:00.0', 1) />
		<cfset QuerySetCell(q_select_new_item, 'dt_lastmodified', '2000-01-01 00:00:00.0', 1) />
		<cfset QuerySetCell(q_select_new_item, 'userkey', arguments.securitycontext.myuserkey, 1) />
		
		<!--- add and return --->
		<cfset arguments.query = AddDirectoryToReturnStructure(query = arguments.query, query_to_add = q_select_new_item) />
		<cfreturn arguments.query />		
	</cffunction>
	
	<!--- new version --->
	<cffunction access="public" name="GetFullDirectoryStructureOfUser" output="false" returntype="struct">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="maxdepth" type="numeric" required="no" default="5">
		<cfargument name="includeshareddirectories" type="boolean" default="false"
			hint="list shared directories as well">
			
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_root_directorykey = 0 />
		<cfset var a_str_cache_item = 'cache_full_dir_scan_' & Hash(arguments.securitycontext.myuserkey & arguments.maxdepth & arguments.includeshareddirectories) />
		<cfset var q_select_directories = QueryNew('currentlevel,entrykey,directoryname,parentdirectorykey,description,filescount,dt_created,dt_lastmodified,userkey', 'Integer,VarChar,VarChar,VarChar,VarChar,Integer,date,date,VarChar') />
		
		<!--- scan already done ... result is cached for the request --->
		<cfif StructKeyExists(request, a_str_cache_item)>
			<cfset stReturn.q_select_directories = request[a_str_cache_item] />
			<cfreturn stReturn />
		</cfif>
		
		<cfinclude template="queries/q_select_root_directorykey.cfm"> 
	
		<!--- add all sub directories of the user --->
		
		<!--- add virtual directory --->
		<cfset q_select_directories = GetFullDirectoryStructureOfUser_AddSpecialDirectory(query = q_select_directories,
										directoryname = 'root',
										entrykey = q_select_root_directorykey.entrykey,
										securitycontext = arguments.securitycontext) />
		
		<!--- add real directories --->
		<cfset q_select_directories = AddSubDirectories(query = q_select_directories,
										currentparentdirectorykeys = q_select_root_directorykey.entrykey,
										currentlevel = 1,
										securitycontext = arguments.securitycontext) />
										
		<!--- include shared files / default workgroup directories --->
		<cfif arguments.securitycontext.Q_SELECT_WORKGROUP_PERMISSIONS.recordcount GT 0>
			
			<!--- include basic workgroup directories --->
			<cfset q_select_directories = GetFullDirectoryStructureOfUser_AddSpecialDirectory(query = q_select_directories,
										directoryname = 'Workgroup directories',
										entrykey = a_str_workdir_uuid,
										securitycontext = arguments.securitycontext) />
										
			<!--- add workgroup directories --->
			<cfloop query="arguments.securitycontext.q_select_workgroup_permissions">
				
				<cfset q_select_directories = GetFullDirectoryStructureOfUser_AddSpecialDirectory(query = q_select_directories,
										directoryname = arguments.securitycontext.q_select_workgroup_permissions.workgroup_name,
										entrykey = arguments.securitycontext.q_select_workgroup_permissions.workgroup_key,
										parentdirectorykey = a_str_workdir_uuid,
										currentlevel = 1,
										securitycontext = arguments.securitycontext) />
										
				<cfset q_select_directories = AddSubDirectories(query = q_select_directories,
											currentparentdirectorykeys = arguments.securitycontext.q_select_workgroup_permissions.workgroup_key,
											currentlevel = 2,
											securitycontext = arguments.securitycontext) />
										
			</cfloop>
			
			<!--- go on with shared files --->
			<cfset q_select_directories = GetFullDirectoryStructureOfUser_AddSpecialDirectory(query = q_select_directories,
										directoryname = 'Shared directories',
										entrykey = a_str_shared_files_uuid,
										securitycontext = arguments.securitycontext) />
			
			<cfset q_select_directories = AddSubDirectories(query = q_select_directories,
											currentparentdirectorykeys = a_str_shared_files_uuid,
											currentlevel = 1,
											securitycontext = arguments.securitycontext) />
		</cfif>
		
		<cfquery name="q_select_directories" dbtype="query">
		SELECT
			*
		FROM
			q_select_directories
		ORDER BY
			currentlevel DESC,
			parentdirectorykey,directoryname
		;
		</cfquery>
		
		<!--- simple caching for this one request --->
		<cfset request[a_str_cache_item] = q_select_directories />
		
		<cfset stReturn.q_select_directories = q_select_directories />
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="private" name="AddSubDirectories" output="false" returntype="query"
			hint="return the sub directories of this directory">
		<cfargument name="query" type="query" required="true" hint="Query holding all found directories">
		<cfargument name="currentparentdirectorykeys" type="string" required="true">
		<cfargument name="currentlevel" type="numeric" required="true">
		<cfargument name="securitycontext" type="struct" required="true">
		
		<cfset var q_select_sub_directories = 0 />
		
		<!--- check if we have a special folder type ... --->
		<cfif arguments.currentparentdirectorykeys IS a_str_shared_files_uuid>
			
			<!--- add sub directories of shared directories ... --->
			<cfquery name="q_select_sub_directories" datasource="#request.a_str_db_tools#">
			SELECT 
				directories.entrykey,
				directories.directoryname,
				'#a_str_shared_files_uuid#' AS parentdirectorykey,
				#arguments.currentlevel# AS currentlevel,
				directories.description,
				directories.userkey,
				directories.filescount,
				directories.dt_created,
				directories.dt_lastmodified
			FROM
				directories,
				directories_shareddata
			WHERE
				(directories_shareddata.directorykey = directories.entrykey)
				AND 
				directories_shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(arguments.securitycontext.Q_SELECT_WORKGROUP_PERMISSIONS.workgroup_key)#" list="true">)
			;
			</cfquery>
			
		<cfelse>
			
			<!--- do it the ordenary way ... --->
			<cfquery name="q_select_sub_directories" datasource="#request.a_str_db_tools#">
			SELECT
				entrykey,directoryname,parentdirectorykey,description,filescount,dt_created,dt_lastmodified,userkey,
				#arguments.currentlevel# AS currentlevel
			FROM
				directories
			WHERE
				parentdirectorykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentparentdirectorykeys#" list="yes">)
			ORDER BY
				directoryname
			;
			</cfquery>
		
		</cfif>
		
		
		
		<cfif q_select_sub_directories.recordcount GT 0>
			
			<!--- add rows ... --->
			<cfset arguments.query = AddDirectoryToReturnStructure(query = arguments.query, query_to_add = q_select_sub_directories) />
					
			<cfset arguments.query = AddSubDirectories(query = arguments.query,
										currentparentdirectorykeys = ValueList(q_select_sub_directories.entrykey),
										currentlevel = (arguments.currentlevel + 1),
										securitycontext = arguments.securitycontext) />
		</cfif>
		
		<cfreturn arguments.query />
		
	</cffunction>

	<cffunction access="private" name="AddDirectoryToReturnStructure" output="false" returntype="query">
		<cfargument name="query" type="query" required="true" hint="Query holding all found directories">
		<cfargument name="query_to_add" type="query" required="true" hint="query holding the data to add to the main query">
		
		<cfset 0 />
		<cfset var a_int_current_recordcount = arguments.query.recordcount />
		<cfset var ii = 0 />
		<cfset var a_str_col_name = '' />
		<cfset var a_str_columns = arguments.query.columnlist />
		
		<!--- add rows and set data --->
		<cfset QueryAddRow(arguments.query, arguments.query_to_add.recordcount) />
		
		<cfloop from="1" to="#arguments.query_to_add.recordcount#" index="ii">
			<cfloop list="#a_str_columns#" index="a_str_col_name">
				<cfset arguments.query[a_str_col_name][a_int_current_recordcount + ii] = arguments.query_to_add[a_str_col_name][ii] />
			</cfloop>
		</cfloop>
		
		<cfreturn arguments.query />
		
	</cffunction>

	<cffunction access="public" name="GetDirectoryStructure" output="false" returntype="struct"
			hint="return the structure of directories">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="maxdepth" type="numeric" required="no" default="5">
		<cfargument name="includeshareddirectories" type="boolean" default="false"
			hint="list shared directories as well">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var q_select_root_directorykey = 0 />
		<cfset var temp = false />
		
		<cfset var a_int_counter = 0 />
		<cfset var select_directories = StructNew() />
		<cfset var a_struct_list_shared_directories = StructNew() />
		
		<cfinclude template="queries/q_select_root_directorykey.cfm"> 
		
		<cfset arguments.directorykey = q_select_root_directorykey.entrykey />
		<cfset stReturn.directories = StructNew() />
		<cfset stReturn.rootdirectorykey=arguments.directorykey />
		<cfset stReturn.directories[arguments.directorykey] = StructNew() />
		<!--- TODO hp: translate ... --->
		<cfset stReturn.directories[arguments.directorykey].name = 'Basisverzeichnis' />
		<cfset stReturn.directories[arguments.directorykey].parentdirectorykey = 'null'>
		<cfset stReturn.directories[arguments.directorykey].subdirectories = ArrayNew(1)>
		<cfset stReturn.directories[arguments.directorykey].filescount = 0>
		
		<cfset select_directories.a_arr_directorykeys = ArrayNew(1)>
		<cfset temp=ArrayAppend(select_directories.a_arr_directorykeys,q_select_root_directorykey.entrykey)>
		
		<cfloop index="a_int_counter" from="0" to="#arguments.maxdepth#">
			
			<cfif ArrayLen(select_directories.a_arr_directorykeys) GT 0>
				
				<cfinclude template="queries/q_select_multiple_sub_directories.cfm">
				<cfset select_directories.a_arr_directorykeys = ArrayNew(1) />
				
				<cfloop query="q_select_multiple_sub_directories">
					<cfset ArrayAppend(select_directories.a_arr_directorykeys, entrykey)>
					<cfset stReturn.directories[entrykey] = StructNew()>
					<cfset stReturn.directories[entrykey].name = q_select_multiple_sub_directories.directoryname>
					<cfset stReturn.directories[entrykey].parentdirectorykey = q_select_multiple_sub_directories.parentdirectorykey>
					<cfset stReturn.directories[entrykey].subdirectories = ArrayNew(1)>
					<cfset stReturn.directories[entrykey].filescount = filescount>
					<cfset ArrayAppend(stReturn.directories[parentdirectorykey].subdirectories,q_select_multiple_sub_directories.entrykey)>
				</cfloop>
			<cfelse>
				<cfset a_int_counter = arguments.maxdepth + 50>
			</cfif>
			
		</cfloop>
		
		<cfif arguments.includeshareddirectories>
			<!--- include shared directories as well ... --->
			<cfset a_struct_list_shared_directories = ListFilesAndDirectories(directorykey = a_str_shared_files_uuid, securitycontext = arguments.securitycontext, usersettings = arguments.usersettings) />
			
			<cfset ArrayAppend(select_directories.a_arr_directorykeys, a_str_shared_files_uuid) />
			<cfset stReturn.directories[a_str_shared_files_uuid] = StructNew() />
			<cfset stReturn.directories[a_str_shared_files_uuid].name = 'Shared directories' />
			<cfset stReturn.directories[a_str_shared_files_uuid].parentdirectorykey = 'null' />
			<cfset stReturn.directories[a_str_shared_files_uuid].subdirectories = ArrayNew(1) />
			<cfset stReturn.directories[a_str_shared_files_uuid].filescount = a_struct_list_shared_directories.files.recordcount />
			<!--- <cfset ArrayAppend(stReturn.directories[a_str_shared_files_uuid].subdirectories, q_select_multiple_sub_directories.entrykey)> --->
		</cfif>
		
		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="MoveFile" output="false" returntype="struct"
			hint="move a file from directory a to b">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="destination_directorykey" type="string" required="true">
		
		<cfset var stReturn = GenerateReturnStruct() />
		<cfset var SelectFileRequest = StructNew() />
		<cfset var q_select_file = 0 />
		
		<cfif not checkaccess(securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'w',
			object_type = 'file',
			entrykey = arguments.entrykey)>
				
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>
		
		<cfif not checkaccess(securitycontext = arguments.securitycontext,
			usersettings = arguments.usersettings,
			access_type = 'w',
			object_type = 'dir',
			entrykey = arguments.destination_directorykey)>
				
			<cfreturn SetReturnStructErrorCode(stReturn, 10100) />
		</cfif>

		<cfset SelectFileRequest.entrykey=arguments.entrykey />
		<cfinclude template="queries/q_select_file.cfm">
		<cfinclude template="queries/q_update_parentdirectory.cfm">

		<cfset UpdateFilesCount(arguments.destination_directorykey) />
		<cfset UpdateFilesCount(q_select_file.parentdirectorykey) />

		<cfreturn SetReturnStructSuccessCode(stReturn) />
	</cffunction>
	
	<cffunction access="public" name="UpdateFilesCount" returntype="boolean" output="false"
			hint="updates filescount property of a directory">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the directory">
		
		<cfset var a_int_filecount = 0 />
		
		<cfinclude template="queries/q_update_filescount.cfm">

		<cfreturn true />
	</cffunction>

	<cffunction access="public" name="path2uuid" output="true" returntype="any">
		<cfargument name="securitycontext" type="struct" required="true">
		<cfargument name="usersettings" type="struct" required="true">
		<cfargument name="path" type="string" required="true">
		
		<cfset var a_int_idx1 = 0>
		<cfset var a_int_idx2 = 1>
		<cfset var lc = 0>
		<cfset var a_str_value = '' />
		<cfset var temp = '' />
		<cfset var stReturn=StructNew()>
		<cfset var a_arr_path_arguments = ArrayNew(1)>
		<cfset var a_arr_uuids = ArrayNew(1)>
		<cfset var a_str_rootdirectorykey = '' />
		
		<cfset var current_directorykey = '' />
		<cfset var a_int_start = 0 />
		<cfset var a_query_folder = 0 />
		<cfset var a_int_index = 0 />
		
		<cfloop condition="lc le 100">
		
		  <cfset a_int_idx1 = Find("/",arguments.path,a_int_idx2)>
		  
		  <cfif a_int_idx1 gt 0>
		  
			<cfset a_int_idx2=Find("/",arguments.path,a_int_idx1+1)>
			<cfif a_int_idx2 eq 0>
			  <cfset a_int_idx2 = len(arguments.path)+1>
			  <cfset lc=100>
			</cfif>
			<cfset a_str_value=mid(arguments.path,a_int_idx1+1,a_int_idx2-a_int_idx1-1)>
		  
			<cfset temp=ArrayAppend(a_arr_path_arguments,a_str_value)>
			<cfset lc=lc+1>
		  <cfelse>
			<cfset lc=101>
		  </cfif>
		</cfloop>
		
<!---
		<cfset stReturn.log=ArrayNew(1)>
--->
		
		
		<cfset a_str_rootdirectorykey=GetRootDirKey(securitycontext=arguments.securitycontext, usersettings=arguments.usersettings)>
		
		<cfset current_directorykey=a_str_rootdirectorykey>
		
		<cfset tmp=ArrayAppend(a_arr_uuids,current_directorykey)>

		<cfset a_int_start=1>		
		<cfif arraylen(a_arr_path_arguments) gt 1>
			<cfif a_arr_path_arguments[1] eq getlangval('sto_ph_sharedfiles',client.langno)>
				<cfset tmp=ArrayAppend(a_arr_uuids,a_str_shared_files_uuid)>
				<cfset a_int_start=2>
			</cfif>
			<cfif a_arr_path_arguments[1] eq getlangval('sto_ph_workgroupfiles',client.langno)>
				<cfset tmp=ArrayAppend(a_arr_uuids,a_str_workdir_uuid)>
				<cfset a_int_start=2>
				<cfif arraylen(a_arr_path_arguments) gt 1>
					<cfloop query="arguments.securitycontext.q_select_workgroup_permissions">
						<cfif arguments.securitycontext.q_select_workgroup_permissions.workgroup_name eq a_arr_path_arguments[2]>
							<cfset tmp=ArrayAppend(a_arr_uuids,arguments.securitycontext.q_select_workgroup_permissions.workgroup_key)>
						</cfif>
					</cfloop>
					
					<cfset a_int_start=3>
				</cfif>
			</cfif>
		</cfif>
		
		<cfloop index="a_int_index" from="#a_int_start#" to="#arraylen(a_arr_path_arguments)#">
			<cfif  len(a_arr_path_arguments[a_int_index]) gt 0>
				
				<cfset a_query_folder=FindFile(component = application.components.cmp_storage,
					directorykey=current_directorykey,
					filename=a_arr_path_arguments[a_int_index],
					securitycontext = arguments.securitycontext,
					usersettings=arguments.usersettings)>
				
				<cfset current_directorykey=a_query_folder.entrykey>
<!---
				<cfset tmp=ArrayAppend(stReturn.log,a_query_folder)>
--->
				<cfset tmp=ArrayAppend(a_arr_uuids,current_directorykey)>
			</cfif>
		</cfloop>
		
		<cfset stReturn.uuids=a_arr_uuids>
		<cfreturn stReturn>
	</cffunction>


	<cffunction access="public" name="GetOwnerUserkey" output="false" returntype="string">
		<!--- the directory --->
		<cfargument name="entrykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_ownerkey.cfm">
					
		<cfreturn q_select_ownerkey.userkey>
	</cffunction>

	<cffunction access="public" name="GetTrafficInfo" output="false" returntype="query">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		
		<cfinclude template="queries/q_select_traffic.cfm">
			
		<cfreturn q_select_traffic>
	</cffunction>

	<cffunction access="public" name="GetUsageInfo" output="false" returntype="struct">
		<!--- securitycontext --->
		<cfargument name="securitycontext" type="struct" required="true">
		
		<cfset var q_select_usage = 0 />
		<cfset var q_select_user_quota = 0 />
		<cfset var q_struct_usage = StructNew() />
		
		<cfinclude template="queries/q_select_usage.cfm">
		<cfinclude template="queries/q_select_user_quota.cfm">
		
		<cfif q_select_usage.recordcount gt 0 >
			<cfset q_struct_usage.bused=val(q_select_usage.bused)>
		<cfelse>
			<cfset q_struct_usage.bused=0>
		</cfif>	
		<cfset q_struct_usage.maxsize=val(q_select_user_quota.maxsize)>
		<cfreturn q_struct_usage>
	</cffunction>

	<cffunction access="public" name="ResetTraffic" output="false">
		
		<cfinclude template="queries/q_update_resettraffic.cfm">
			
	</cffunction>
	
	<cffunction access="public" name="GetDirectoryKeyOfFile" output="false" returntype="string">
		<cfargument name="filekey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_directorykey_of_file.cfm">
		
		<cfreturn q_select_directorykey_of_file.parentdirectorykey>
	</cffunction>

	
</cfcomponent>

