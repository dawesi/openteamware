<!--- //

	Module:		CRMSales
	Function:	GetStorageDirectoryKeyOfContact
	Description:find out the default base directory for this user 
	

// --->
<cfset a_struct_binding = GetCRMSalesBinding(companykey = arguments.securitycontext.mycompanykey)>

<cfif Len(a_struct_binding.USERKEY_DATA) IS 0>
	<cfexit method="exittemplate">
</cfif>


<!--- get sec context and usersettings of user holding the files for all contacts --->
<cfset stSecurityContext_display_files = application.components.cmp_security.GetSecurityContextStructure(userkey = a_struct_binding.USERKEY_DATA)>
<cfset stUserSettings_display_files = application.components.cmp_user.GetUsersettings(userkey = a_struct_binding.USERKEY_DATA)>

<!--- check now if directory for the certain user exists --->
<cfset a_str_contactkey = arguments.contactkey>

<!--- get entrykey of root directory --->
<cfset a_str_root_directory = application.components.cmp_storage.GetRootDirKey(securitycontext = variables.stSecurityContext_display_files, usersettings = variables.stUserSettings_display_files)>
	
<cfset q_select_directory_entrykey = application.components.cmp_storage.FindFile(filename = a_str_contactkey,
	directorykey = a_str_root_directory,
	securitycontext = variables.stSecurityContext_display_files,
	usersettings = variables.stUserSettings_display_files)>
	

<cfset a_str_current_directory_entrykey = q_select_directory_entrykey.entrykey>



