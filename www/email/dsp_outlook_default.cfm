<!--- //

	Module:		Email
	Description:Outlook
	

// --->

<cfif NOT request.stSecurityContext.A_STRUCT_IMAP_ACCESS_DATA.enabled>
	<cfexit method="exittemplate">
</cfif>

<cfinclude template="utils/inc_load_imap_access_data.cfm">

<cfset variables.a_use_cached_folder_structure = true />
<cfset variables.a_bol_load_imap_folders_no_order = true />
<cfinclude template="utils/inc_load_folders.cfm">

<cfset a_struct_folders = StructNew()>

<cfloop query="request.q_select_folders">
	<cfif Val(request.q_select_folders.unreadmessagescount) GT 0>
		<cfset a_struct_folders[request.q_select_folders.fullfoldername] = request.q_select_folders.unreadmessagescount>
	</cfif>
</cfloop>

<cfif StructCount(a_struct_folders) GT 0>
<tr>
	<td colspan="2">
		<!--- TODO hp: add to translation ... --->
		In den folgenden Ordnern liegen ungelesene Nachrichten vor:<img src="/images/space_1_1.gif" class="si_img" />
	</td>
</tr>
</cfif>
<cfif StructKeyExists(a_struct_folders, 'INBOX')>

	<cfset a_str_text = GetLangVal('email_ph_mails_with_unread_mails')>
	<cfset a_str_text = ReplaceNoCase(a_str_text, '%RECORDCOUNT%', a_struct_folders.INBOX)>
		
	<tr>
		<td style="width:66%;">
			<a style="font-weight:bold;" href="/email/?action=showmailbox&mailbox=INBOX"><cfoutput>#si_img('folder_star')# #a_str_text#</cfoutput></a>
		</td>
		<td style="width:33%;">&nbsp;
						
		</td>
	</tr>
</cfif>

<cfset a_str_folderlist = StructKeyList(a_struct_folders, '|')>
	
<cfloop list="#a_str_folderlist#" index="a_str_foldername" delimiters="|">
	<cfset a_str_display_foldername = ReplaceNoCase(a_str_foldername, 'INBOX.', '')>
	
	<cfif a_str_display_foldername NEQ 'INBOX'>
		<cfoutput>
		<tr>
			<td style="width:66%;">
				<a href="/email/?action=showmailbox&mailbox=#urlencodedformat(a_str_foldername)#">#si_img('folder_star')# #htmleditformat(a_str_display_foldername)#</a> (#a_struct_folders[a_str_foldername]#)
			</td>
			<td style="width:33%;">
				
			</td>
		</tr>
		</cfoutput>
	</cfif>
</cfloop>

<!--- no new messages available ... --->
<cfif Listlen(a_str_folderlist, '|') IS 0 OR NOT StructKeyExists(a_struct_folders, 'INBOX')>
	<tr>
		<td class="addinfotext" colspan="2">
			<cfif Listlen(a_str_folderlist, '|') IS 0>
			<cfoutput>#GetLangVal('email_ph_start_no_new_messages')#</cfoutput><img src="/images/space_1_1.gif" class="si_img" />
			<br /> 
			</cfif>
			<a href="##" onclick="GotoLocHref('/email/default.cfm?action=ShowMailbox&Mailbox=INBOX');return false;"><cfoutput>#si_img('folder')# #GetLangVal('email_ph_goto_inbox')#</cfoutput></a>
		</td>
	</tr>
</cfif>