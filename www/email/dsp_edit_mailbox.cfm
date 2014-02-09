<!--- //

	Module:		E-Mail
	Action:		editmailbox
	Description: 
	

	
	
	a) edit a mailbox
	
	a) check if we've got a special folder (INBOX, ...)
	
	b) check if a folder with the same name already exists
	
// --->
<cfparam name="url.mailbox" type="string" default="">
<cfparam name="url.error" type="string" default="">

<cfinclude template="queries/q_select_filter.cfm">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_rename')) />

<cfquery name="q_check_msg_count" dbtype="query">
SELECT
	messagescount
FROM
	request.q_select_folders
WHERE
	fullfoldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.mailbox#">
;
</cfquery>

<cfif q_check_msg_count.recordcount is 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="#GetLangVal('mail_ph_error_folder_not_found')#">	
	<cfexit method="exittemplate">
</cfif>

<cfif ListFindNoCase("INBOX,INBOX.Trash,INBOX.Junkmail,INBOX.Sent,INBOX.Drafts", url.mailbox) gt 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="#GetLangVal('email_ph_rename_folder_error_not_allowed')#">
	<cfexit method="exittemplate">
</cfif>

<cfset a_str_foldername_without_dot_inbox = Mid(url.mailbox, len("INBOX.")+1, len(url.mailbox))>

<!--- check for filters ... --->
<cfquery name="q_select_filter_exists" dbtype="query">
SELECT
	COUNT(id) AS count_id
FROM
	q_select_filter
WHERE
	parameter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_foldername_without_dot_inbox#">
;
</cfquery>

<cfif q_select_filter_exists.count_id gt 0>
	<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="Dieser Ordner wird von einem Filter verwendet und kann daher nicht editiert werden.">
	<cfexit method="exittemplate">
</cfif>

<cfif cgi.REQUEST_METHOD neq "POST">
	<!--- rename form ... --->
	
	<cfif len(url.error) gt 0>
		<!--- we've an error ... load the error message ... --->
		
		<cfset a_str_error_msg = "mail_ph_editfolder_error_"&url.error>
		<cfset a_str_error_msg = GetLangVal(a_str_error_msg)>
		
		<cfmodule template="../common/snippets/mod_alert_box.cfm"
		message="#a_str_error_msg#">		

	</cfif>
	
	
		
		<form action="default.cfm?action=editmailbox&mailbox=<cfoutput>#urlencodedformat(url.mailbox)#</cfoutput>" method="post" style="margin:0px;">
		<table class="table_details table_edit_form">
		  <tr class="mischeader">
			<td colspan="2">
				<cfoutput>#GetLangVal('email_ph_rename_folder')#</cfoutput> (<cfoutput>#htmleditformat(a_str_foldername_without_dot_inbox)#</cfoutput>)
			</td>
		  </tr>
		  <tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('mail_wd_foldername')#</cfoutput>
			</td>
			<td>
				<cfoutput>#htmleditformat(a_str_foldername_without_dot_inbox)#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td class="field_name">
				<cfoutput>#GetLangVal('email_ph_rename_folder_new_name')#</cfoutput>
			</td>
			<td>
				<input type="text" name="frmnewname" value="" size="25" maxlength="100" />
			</td>
		  </tr>
		  <tr style="display:none;">
			<td class="field_name"></td>
			<td>
				<input type="checkbox" name="frm_private_folder" class="noborder" value="1"> Ordner enthaelt nur private Nachrichten
			</td>
		  </tr>
		  <tr>
			<td class="field_name"></td>
			<td>
				<input type="submit" name="frmsubmit" value="Umbenennen" class="btn" />
		
				<input onClick="location.href='default.cfm';" type="button" class="btn3" value="<cfoutput>#GetLangVal('cm_wd_cancel')#</cfoutput>" />
			</td>
		  </tr>
		</table>
		</form>
		

<cfelse>
	<!--- rename ... --->
	
	<cfif len(trim(form.frmnewname)) is 0>
		<!--- zero? --->
		<cflocation addtoken="no" url="default.cfm?action=editmailbox&mailbox=#urlencodedformat(url.mailbox)#&error=noinput">	
	</cfif>

	<cfif FindNoCase(".", form.frmnewname) gt 0>
		<!--- point? --->
		<cflocation addtoken="no" url="default.cfm?action=editmailbox&mailbox=#urlencodedformat(url.mailbox)#&error=pointinname">	
	</cfif>

	<!--- a) check if such a folder already exists --->
	<cfquery name="q_select_folder_exists" dbtype="query">
	SELECT foldername FROM request.q_select_folders
	WHERE fullfoldername = <cfqueryparam cfsqltype="cf_sql_varchar" value="INBOX.#form.frmnewname#">;
	</cfquery>

	<cfif q_select_folder_exists.recordcount gt 0>
		<!--- exists ... --->
		<cflocation addtoken="no" url="default.cfm?action=editmailbox&mailbox=#urlencodedformat(url.mailbox)#&error=folderalreadyexists">
	</cfif>
	
	<cfinvoke component="/components/email/cmp_tools" method="renamefolder" returnvariable="a_bol_return">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="sourcefolder" value="#url.mailbox#">
		<cfinvokeargument name="destinationfolder" value="INBOX.#form.frmnewname#">
	</cfinvoke>
	
	<cflock scope="session" timeout="3" type="exclusive">
		<cfset session.a_int_loadfolders_hitcount = 5>
	</cflock>
	
	<b>Aktion erfolgreich ausgef&uuml;hrt!</b>
	<br /><br />
	<a href="default.cfm?action=overview" class="simplelink">Zur Ordner&uuml;bersicht ...</a>
	
</cfif>


