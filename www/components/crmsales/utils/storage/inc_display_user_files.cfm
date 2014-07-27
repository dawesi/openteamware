<!--- //

	Module:	SERVICE
	Description: 
	

// --->
<!--- //

	display files attached to user
	
	// --->


<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stSecurityContext_display_files = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#a_struct_binding.USERKEY_DATA#">
</cfinvoke>

<cfset variables.stUserSettings_display_files = a_struct_settings>

<!--- check now if directory for the certain user exists --->

<cfset a_str_contactkey = arguments.contactkey>

<!--- get entrykey of root directory --->
<cfset a_str_root_directory = application.components.cmp_storage.GetRootDirKey(securitycontext = variables.stSecurityContext_display_files, usersettings = variables.stUserSettings_display_files)>

<!--- check if directory /contactkey exists --->
<cfset q_select_directory_exists = application.components.cmp_storage.FindFile(filename = a_str_contactkey,
	directorykey = a_str_root_directory,
	securitycontext = variables.stSecurityContext_display_files,
	usersettings = variables.stUserSettings_display_files)>
	
<cfif q_select_directory_exists.recordcount IS 0>
	<!--- create base directory for this user --->
	<cfset application.components.cmp_storage.CreateDirectory(securitycontext = variables.stSecurityContext_display_files,
												usersettings = variables.stUserSettings_display_files,
												directoryname = a_Str_contactkey,
												parentdirectorykey = a_str_root_directory,
												entrykey = CreateUUID())>
</cfif>


<!--- has the user specified a directory or should we use the root directory? --->
<cfif Len(arguments.directorykey) GT 0>
	<!--- directorykey is given ... --->
	<cfset a_str_current_directory_entrykey = arguments.directorykey>
	
	<cfset a_str_subdir = true>
<cfelse>
	<!--- find out the default base directory for this user ... --->
	
	<cfset q_select_directory_entrykey = application.components.cmp_storage.FindFile(filename = a_str_contactkey,
		directorykey = a_str_root_directory,
		securitycontext = variables.stSecurityContext_display_files,
		usersettings = variables.stUserSettings_display_files)>
	
	<cfset a_str_current_directory_entrykey = q_select_directory_entrykey.entrykey>
	
	<cfset a_str_subdir = false>
</cfif>

<!--- now, list files ... --->
<cfset q_select_files_and_directories = application.components.cmp_storage.ListFilesAndDirectories(securitycontext = variables.stSecurityContext_display_files,
												usersettings = variables.stUserSettings_display_files,
												directorykey = a_str_current_directory_entrykey)>
												
<cfset q_select_files_and_directories = q_select_files_and_directories.files>

<!--- no data found and not in manage mode ... exit --->
<cfif q_select_files_and_directories.recordcount IS 0>
	<cfset sReturn = '' />
	<cfexit method="exittemplate">
</cfif> 

<cfsavecontent variable="as">
	
	<table class="table table-hover">
	
		<!--- <cfif arguments.managemode>
		<tr>
			<td colspan="3">
				
				<cfif a_str_subdir>
					<cfoutput>
					<a href="javascript:DisplayFilesAttachedToContact('#jsstringformat(a_str_contactkey)#', '#jsstringformat('')#', '#jsstringformat(arguments.divname)#');">&laquo; goto parent directory ...</a>
					</cfoutput>
					&nbsp;
				</cfif>
				
				<b><cfoutput>#GetLangVal('cm_wd_add')#</cfoutput></b>: <a href="javascript:OpenUploadPopup('<cfoutput>#jsstringformat(a_str_contactkey)#</cfoutput>', '<cfoutput>#jsstringformat(a_str_current_directory_entrykey)#</cfoutput>');"><cfoutput>#GetLangVal('cm_wd_file')#</cfoutput></a>
				|
				<a href="javascript:CreateNewDirectoryDialog('<cfoutput>#jsstringformat(a_str_contactkey)#</cfoutput>', '<cfoutput>#jsstringformat(a_str_current_directory_entrykey)#</cfoutput>');"><cfoutput>#GetLangVal('cm_wd_folder')#</cfoutput></a>
			</td>
		</tr>
		</cfif> --->
		
		<cfif q_select_files_and_directories.recordcount GT 0>
		<tr class="tbl_overview_header">
			<td width="50%">
				<cfoutput>#GetLangVal('cm_wd_name')#</cfoutput>
			</td>
			<td width="25%">
				<cfoutput>#GetLangVal('cm_wd_Description')#</cfoutput>
			</td>
			<td width="25%">
				<cfoutput>#GetLangVal('cm_wd_modified')#</cfoutput>
			</td>
			<!---<td class="addinfotext"><cfoutput>#GetLangVal('cm_wd_size')#</cfoutput></td>--->
			<!---<td class="addinfotext">&nbsp;</td>--->
		</tr>
		</cfif>
		
	  <cfoutput query="q_select_files_and_directories">
	  <tr>
		<td style="width:50%;">
			<cfif q_select_files_and_directories.filetype IS 'directory'>
				<img src="/images/si/folder.png" class="si_img" />
			<cfelse>				
				<!---
				<img src="/storage/images/icon_txt.gif" align="absmiddle" border="0" vspace="2" hspace="2">
				--->
			</cfif>
			<cfif q_select_files_and_directories.filetype IS 'directory'>
				<a href="javascript:DisplayFilesAttachedToContact('#jsstringformat(a_str_contactkey)#', '#jsstringformat(q_select_files_and_directories.entrykey)#', '#jsstringformat(arguments.divname)#');">#htmleditformat(q_select_files_and_directories.name)#</a> (#q_select_files_and_directories.filescount#)
			<cfelse>				
				<a target="_blank" href="/addressbook/crm/show_load_contact_data_file.cfm?entrykey=#q_select_files_and_directories.entrykey#&contactkey=#a_Str_contactkey#&directorykey=">#application.components.cmp_tools.GetImagePathForContentType(q_select_files_and_directories.contenttype)# #htmleditformat(q_select_files_and_directories.name)#</a> (#ByteConvert(q_select_files_and_directories.filesize)#)
			</cfif>
		</td>
		<td>
			#htmleditformat(q_select_files_and_directories.description)#
			
			<cfif Len(q_select_files_and_directories.categories) GT 0>
				<br>
				#htmleditformat(q_select_files_and_directories.categories)#
			</cfif>
		</td>
		<td>
			#LsDateFormat(q_select_files_and_directories.dt_lastmodified, arguments.usersettings.default_dateformat)#
			
			<!--- <cfif arguments.managemode>
				&nbsp;&nbsp;
				<a onClick="return confirm('#GetLangValJS('cm_ph_are_you_sure')#');" href="javascript:DeleteAssignedFile('#jsstringformat(a_str_contactkey)#', '#jsstringformat(a_str_current_directory_entrykey)#', '#q_select_files_and_directories.entrykey#');"><img src="/images/email/img_trash_19x16.gif" align="absmiddle" border="0" alt="#GetLangVal('cm_wd_delete')#"></a>
			</cfif> --->
		</td>
	  </tr>
	  </cfoutput>
	</table>
	
		
	
</cfsavecontent>

<cfset sReturn = as />


