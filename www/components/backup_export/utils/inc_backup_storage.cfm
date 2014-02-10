<!---
<cfsdfubisdufb/>


tar cfzvh verwenden

zuerst f�r alle files mit ln -s einen symbolischen link anlegen!!!

<cfabort>
--->
<cfsetting requesttimeout="20000">

<cfset a_str_cmd_make_links = ''>

<!--- // storage // --->

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetDirectoryStructure"   
	returnVariable = "a_struct_dirs"   
	securitycontext="#variables.stSecurityContext#"
	usersettings="#variables.stUserSettings#"
	 >
</cfinvoke>

<cfset a_str_backup_dir = a_str_backup_directory & request.a_str_dir_separator & 'storage'>

<!--- create the storage directory --->
<cfdirectory action="create" directory="#a_str_backup_dir#">

	<cfset a_arr_dirs=ArrayNew(1)>
	<cfset a_struct_hint=Structnew()>
	
	<cfset sDirectorykey = a_struct_dirs.rootdirectorykey>
	<cfset a_struct_hint.directorykey = sDirectorykey>
	
	<cfset a_struct_hint.counter = 0>
	
	<cfset tmp = ArrayAppend(a_arr_dirs,a_struct_hint)>
	
	<cfloop  condition="arraylen(a_arr_dirs) gt 0 ">
	
		<cfset a_current_hint = a_arr_dirs[arraylen(a_arr_dirs)]>
		<cfset sDirectorykey = a_current_hint.directorykey>
		
		<!--- create directory --->
		<cfset sDirectory_name = a_struct_dirs.directories[sDirectorykey].name>
		
		<cfset a_str_current_storage_dir = a_str_backup_dir & request.a_str_dir_separator & sDirectory_name & '_' & createUUID() & request.a_Str_dir_separator>

		<cfset tmp = LogMessage('storage: current directory: ' & a_str_current_storage_dir)>
		
		<cfdirectory action="create" directory="#a_str_current_storage_dir#">
		
		<cfif a_current_hint.counter lte 0>
		
				<cfinvoke   
					component = "#application.components.cmp_storage#"   
					method = "ListFilesAndDirectories"   
					returnVariable = "a_struct_files_of_current_dir"   
					directorykey = "#sDirectorykey#"
					securitycontext="#variables.stSecurityContext#"
					usersettings="#variables.stUserSettings#">
				</cfinvoke>  
				
				<cfquery name="q_select_files" dbtype="query">
				SELECT
					filesize,name,entrykey
				FROM
					a_struct_files_of_current_dir.files
				WHERE
					filetype = 'file'
				;
				</cfquery>
				
				
				<cfloop query="q_select_files">
					<!--- save each file ... (.name) --->
					<cfinvoke   
						component = "#application.components.cmp_storage#"   
						method = "GetFileInformation"   
						returnVariable = "a_struct_file_info"   
						entrykey = "#q_select_files.entrykey#"
						securitycontext="#variables.stSecurityContext#"
						usersettings="#variables.stUserSettings#"
						download=false
						 >
					</cfinvoke>
					
					<cfset q_query_file = a_struct_file_info.q_select_file_info />
					
					<cfset sFilename_storage_clear = rereplacenocase(q_query_file.storagefilename, "[^A-Za-z,.,-,_,+, ,0-9]*", "", "ALL") />
					
					<cfif Len( sFilename_storage_clear ) IS 0>
						<cfset sFilename_storage_clear = CREATEUUID() />
					</cfif>
					
					<!--- copy file ... --->		
					<cfset a_str_storage_filename = q_query_file.storagepath & request.a_str_dir_separator & sFilename_storage_clear />
					
					<cfif FileExists(a_str_storage_filename)>
						<!--- make a symbolic link for the backup ... --->
						<cfset a_str_cmd_make_links = a_str_cmd_make_links & 'ln -s ' & a_str_storage_filename & ' ' & a_str_current_storage_dir & htmleditformat(q_query_file.filename) & chr(10)>
					</cfif>
					
				</cfloop>
				

		</cfif>
		<cfif ArrayLen(a_struct_dirs.directories[sDirectorykey].subdirectories) gt a_current_hint.counter >
			<cfset a_current_hint.counter = a_current_hint.counter + 1 >
			<cfset a_struct_hint = StructNew () >
			<cfset sDirectorykey = a_struct_dirs.directories[sDirectorykey].subdirectories[a_current_hint.counter]>
			<cfset a_struct_hint.directorykey = sDirectorykey>
			<cfset a_struct_hint.counter = 0 >
			<cfset tmp=ArrayAppend(a_arr_dirs,a_struct_hint)>
		<cfelse>
			<cfset tmp=ArrayDeleteAt (a_arr_dirs,ArrayLen(a_arr_dirs))>
		</cfif>
	</cfloop>

<!---<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="a_str_cmd_make_links">
#a_str_cmd_make_links#
</cfmail>--->