<!--- //

	Module:		E-Mail
	Action:		DeleteMbox
	Description: 
	

	
	
	delete a mailbox..
	
	a) check if we've a specially protected mailbox
	
	b) check if there are still messages in the folder
	
	c) check if filters point to this folder
	
	d) ask for confirmation
	
// --->

<cfparam name="url.mailbox" type="string" default="">

<cfset url.mailbox = urldecode(url.mailbox)>

<!--- load filter ... --->
<cfinclude template="queries/q_select_filter.cfm">
	
<br />
<cfset tmp = SetHeaderTopInfoString(GetLangVal('mail_ph_delete_folder'))>

<cfquery name="q_check_msg_count" dbtype="query">
SELECT messagescount FROM request.q_select_folders
WHERE fullfoldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mailbox#">;
</cfquery>

<cfif q_check_msg_count.recordcount is 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="#GetLangVal('mail_ph_error_folder_not_found')#">	
	<cfexit method="exittemplate">
</cfif>

<cfif q_check_msg_count.messagescount gt 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="#GetLangVal('mail_ph_error_stillmessagesinfolder')#">
	<cfexit method="exittemplate">
</cfif>

<cfif ListFindNoCase("INBOX,INBOX.Trash,INBOX.Junkmail,INBOX.Sent,INBOX.Drafts", url.mailbox) gt 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="#GetLangVal('mail_ph_error_folder_cannot_be_deleted')#">
	<cfexit method="exittemplate">
</cfif>

<!--- get foldername without "INBOX." --->
<cfset a_str_foldername_without_dot_inbox = Mid(url.mailbox, len("INBOX.")+1, len(url.mailbox))>

<!--- check for filters ... --->
<cfquery name="q_select_filter_exists" dbtype="query">
SELECT COUNT(id) AS count_id FROM q_select_filter
WHERE parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_foldername_without_dot_inbox#">;
</cfquery>

<cfif q_select_filter_exists.count_id gt 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="Dieser Ordner wird von einem Filter verwendet und kann daher nicht geloescht werden.">
	<cfexit method="exittemplate">
</cfif>

<!--- ask for confirmation --->
<cfif NOT StructKeyExists(url, 'confirmed')>

<cfset a_str_msg_confirm = GetLangVal('mail_ph_delete_folder_confirm_question')>
<cfset a_str_msg_confirm = ReplaceNoCase(a_str_msg_confirm, '%FOLDERNAME%', url.mailbox)>

<img src="/images/si/help.png" class="si_img" /> <cfoutput>#a_str_msg_confirm#</cfoutput>
<br />
<br />
<a href="index.cfm?action=deletemailbox&mailbox=<cfoutput>#urlencodedformat(url.mailbox)#</cfoutput>&confirmed=1"><cfoutput>#GetLangVal('cm_ph_confirm_delete_sure_yes')#</cfoutput></a>&nbsp;&nbsp;&nbsp;<a href="index.cfm"><cfoutput>#GetLangVal('cm_ph_confirm_delete_sure_no')#</cfoutput></a>
<cfelse>
<!--- delete now ... --->

	<cfinvoke component="/components/email/cmp_tools" method="deletefolder" returnvariable="a_bol_return">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
	</cfinvoke>
	
	<cflock scope="session" timeout="3" type="exclusive">
		<cfset session.a_int_loadfolders_hitcount = 5>
	</cflock>

<cfoutput>#GetLangVal('mail_ph_delete_folder_confirmation')#</cfoutput>
<br />
<br />
<br />
<a href="index.cfm"><cfoutput>#GetLangVal('cm_ph_link_goto_overview')#</cfoutput></a>
</cfif>


