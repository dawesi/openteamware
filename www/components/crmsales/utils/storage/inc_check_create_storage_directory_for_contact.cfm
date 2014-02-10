<!--- //

	Module:		CRMSales
	Function:	CheckAndCreateDirectoryForContactInStorage
	Description:check if a directory exists in the storage for a certain user 
	

// --->


<cfif Len(a_struct_binding.USERKEY_DATA) IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- get sec context and usersettings of user holding the files for all contacts --->
<cfset stSecurityContext_display_files = application.components.cmp_security.GetSecurityContextStructure(userkey = a_struct_binding.USERKEY_DATA)>
<cfset stUserSettings_display_files = application.components.cmp_user.GetUsersettings(userkey = a_struct_binding.USERKEY_DATA) />

<!--- check now if directory for the certain user exists --->

<!--- get entrykey of root directory --->
<cfset a_str_root_directory = application.components.cmp_storage.GetRootDirKey(securitycontext = variables.stSecurityContext_display_files, usersettings = variables.stUserSettings_display_files) />

<!--- check if directory /contactkey exists --->
<cfset q_select_directory_exists = application.components.cmp_storage.FindFile(filename = a_str_contactkey,
	directorykey = a_str_root_directory,
	securitycontext = variables.stSecurityContext_display_files,
	usersettings = variables.stUserSettings_display_files) />
	
<cfif q_select_directory_exists.recordcount IS 0>
	<!--- create base directory for this user --->
	<cfset tmp = application.components.cmp_storage.CreateDirectory(securitycontext = variables.stSecurityContext_display_files,
												usersettings = variables.stUserSettings_display_files,
												directoryname = a_str_contactkey,
												parentdirectorykey = a_str_root_directory,
												entrykey = CreateUUID()) />
</cfif>


