<!--- //

	Module:		Storage
	Action:		Fileinfo
	Description: 
	

// --->


<cfparam name="url.parentdirectorykey" default="" type="string">
<cfparam name="url.entrykey" default="" type="string">
<cfparam name="url.version" default="-1" type="numeric">

<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetFileInformation"   
	returnVariable = "a_struct_file_info"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	version = "#url.version#"
	LoadSecurityPermissions = true>
</cfinvoke>	 

<cfif NOT a_struct_file_info.result>
	Permission denied.
	<cfexit method="exittemplate">
</cfif>

<cfset q_query_file = a_struct_file_info.q_select_file_info />

<cfset tmp = SetHeaderTopInfoString(GetLangVal('sto_ph_file_info')) />

<cfif q_query_file.recordcount IS 0>
	File not found.
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="#application.components.cmp_followups#" method="DisplayShortFollowupInfos" returnvariable="stReturn">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="objectkeys" value="#url.entrykey#">				
</cfinvoke>

<cfif stReturn.result>
	<cfoutput>#stReturn.content#</cfoutput>
</cfif>

<cfinvoke component="#application.components.cmp_locks#" method="ExclusiveLockExistsForObject" returnvariable="a_struct_lock">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="objectkey" value="#url.entrykey#">				
</cfinvoke>

<cfsavecontent variable="a_str_content">
<cfoutput>
	
	<table class="table_details">
		<tr>
			<td class="field_name">
				#getlangval('sto_wd_filename')#
			</td>
			<td>
				<b>#htmleditformat(q_query_file.filename)#</b>
			</td>
		</tr>
		<cfif a_struct_lock.lock_exists>
			<tr>
				<td class="field_name">#GetLangVal('cm_ph_locks')#</td>
				<td>
					#application.components.cmp_locks.GenerateLockDefaultInformationString(entrykey = a_struct_lock.entrykey)#
				</td>
			</tr>
		</cfif>
		<tr>
			<td class="field_name">
				#getlangval('sto_wd_directory')#
			</td>
			<td>
				<cfset q_select_dir = application.components.cmp_storage.GetDirectoryInformation(directorykey = q_query_file.parentdirectorykey, securitycontext = request.stSecurityContext, usersettings = request.stUserSettings).q_select_directory />
				<a href="index.cfm?action=ShowFiles&directorykey=#q_query_file.parentdirectorykey#">#htmleditformat(q_select_dir.directoryname)#</a>
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#getlangval('sto_wd_description')#
			</td>
			<td>
				#htmleditformat(checkzerostring(q_query_file.description))#
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#getlangval('sto_wd_contenttype')#
			</td>
			<td>
				#htmleditformat(q_query_file.contenttype)#
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#getlangval('sto_wd_filesize')#
			</td>
			<td>
				#byteconvert(q_query_file.filesize)#
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#GetLangVal('cm_wd_owner')#
			</td>
			<td>
				<a href="/workgroups/?action=ShowUser&entrykey=#q_query_file.userkey#">#application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_query_file.userkey)#</a>
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#GetLangVal('cm_wd_created')#
			</td>
			<td>
				#FormatDateTimeAccordingToUserSettings(q_query_file.dt_created)#
			</td>
		</tr>
		<tr>
			<td class="field_name">
				#GetLangVal('cm_wd_permissions')#
			</td>
			<td>
				<cfloop list="#StructKeyList(a_struct_file_info.a_struct_security_permissions)#" index="a_str_permission">
					<cfif a_struct_file_info.a_struct_security_permissions[a_str_permission]>
						#GetLangVal('cm_wd_action_' & a_str_permission)#
					</cfif>
				</cfloop>
			</td>
		</tr>
		<!--- <tr>
			<td class="field_name">
				#GetLangVal('cm_wd_action')#
			</td>
			<td valign="top">
				<a href="index.cfm?action=MailFile&entrykey=#q_query_file.entrykey#&currentdir=#q_query_file.parentdirectorykey#"><img src="/images/si/email.png" class="si_img" /> #GetLangVal('sto_ph_forward_by_email')# ...</a>
				<br />
				
			</td>
		</tr> --->
	</table>
</cfoutput>


</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
<cfoutput>
	<input type="button" onclick="window.open('index.cfm?action=ShowFile&entrykey=#url.entrykey#');" class="btn" value="#GetLangVal('sto_ph_start_download_of_file')#" />
	<input type="button" onclick="GotoLocHref('index.cfm?action=EditFile&entrykey=#q_query_file.entrykey#&currentdir=#q_query_file.parentdirectorykey#');" class="btn" value="#GetLangVal('cm_wd_edit')#" />
	<input type="button" onclick="GotoLocHref('index.cfm?action=DeleteFile&frm_entrykey=#q_query_file.entrykey#&frm_parentdirectorykey=#q_query_file.parentdirectorykey#&currentdir=#url.directorykey#');" class="btn" value="#GetLangVal('cm_wd_delete')#" />
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_information'), a_str_buttons, a_str_content)#</cfoutput>
	
<cfinvoke   
	component = "#application.components.cmp_storage#"   
	method = "GetVersionInformation"   
	returnVariable = "q_query_versions"   
	entrykey = "#url.entrykey#"
	securitycontext="#request.stSecurityContext#"
	usersettings="#request.stUserSettings#"
	 >
</cfinvoke>


<cfif q_query_versions.recordcount gt 0>
	<cfoutput>
	<br><br>
	
	<b>#getlangval('sto_wd_versions')#:</b>
	
		<table border="1" bordercolor="##EEEEEE" style="border-collapse:collapse; " cellpadding="6" cellspacing="0">
			<tr class="mischeader">
				<td>
					<a href="index.cfm?action=ShowFile&entrykey=#url.entrykey#">#getlangval('sto_wd_current')#</a></td>
				<td>
				</td>
				<td>
					<a href="index.cfm?action=EditFile&entrykey=#url.entrykey#">#si_img('pencil')#</a>
					&nbsp;
					<a href="index.cfm?action=FileInfo&entrykey=#url.entrykey#"><img align="absmiddle"  widtd="12" height="12" alt="info" src="/images/info.jpg" border="0"></a>
					&nbsp;
					<a href="index.cfm?action=MailFile&entrykey=#url.entrykey#"><img align="absmiddle"  widtd="15" height="11" alt="mail" src="/images/btn_folder_inbx2.gif" border="0"></a>
				</td>
			</tr>
	</cfoutput>
	<cfoutput query="q_query_versions">
			<tr>
				<td align="center">
					<a href="index.cfm?action=ShowFile&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#">#version#</a></td>
				<td>
					vom #LsDateFormat(GetUTCTime(q_query_versions.dt_created), 'ddd, dd.mm.yy')# #TimeFormat(GetUTCTime(q_query_versions.dt_created), 'HH:mm')#</td>
				<td>
					<a href="index.cfm?action=EditFile&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#">#si_img('pencil')#</a>
					&nbsp;
					<a href="index.cfm?action=FileInfo&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#"><img align="absmiddle"  src="/images/info.jpg" widtd="12" height="12" alt="info" border="0"></a>
					&nbsp;
					<a href="index.cfm?action=MailFile&entrykey=#q_query_versions.entrykey#&version=#q_query_versions.version#"><img align="absmiddle"  src="/images/btn_folder_inbx2.gif" widtd="15" height="11" alt="mail" border="0"></a>
				</td>
			</tr>
		
	</cfoutput>
	</table>
</cfif>



