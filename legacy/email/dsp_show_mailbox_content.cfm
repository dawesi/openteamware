<!--- //

	Module:		EMail
	Action:		ShowMailboxContent
	Description:Show content of mailbox
	
// --->

<cfparam name="url.mailbox" type="string" default="INBOX">
<cfparam name="url.style" type="string" default="cols">
<cfparam name="url.startrow" type="numeric" default="1">
<cfparam name="url.sort" type="string" default="id">
<cfparam name="url.desc" type="string" default="1">
<cfparam name="url.nocache" type="string" default="0">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">
<cfparam name="url.order" type="string" default="date_local">
<cfparam name="url.restrict" type="string" default="">

<cfset a_t_begin = GetTickCount() />

<cfinclude template="queries/q_select_all_pop3_data.cfm">

<!--- <cfset a_struct_markcolors = StructNew() />
<cfoutput query="q_select_all_pop3_data">
	<cfset a_struct_markcolors[q_select_all_pop3_data.pop3server] = q_select_all_pop3_data.markcolor />
</cfoutput> --->

<!--- check in which viewmode we're ... --->
<cfset a_str_mbox_display_style = 'cols' /><!--- GetUserPrefPerson('email', 'mbox.display.viewmode', 'cols', '', false) /> --->
	
<!--- is a message preview active? --->
<cfset a_int_display_mbox_msg_preview = 1 /> <!--- GetUserPrefPerson('email', 'mbox.display.msgpreview', '1', '', false) /> --->

<!--- mails per page ... --->
<cfset a_int_mails_per_page = GetUserPrefPerson('email', 'emailsperpage', '50', '', false) />
	
<cfif Compare(a_str_mbox_display_style, 'cols') IS 0>
	<!--- column mode, always display preview --->
	<cfset a_int_display_mbox_msg_preview = 1 />
<cfelse>
	<!--- row mode, always disable preview ... --->
	<cfset a_int_display_mbox_msg_preview = 0 />
</cfif>

<!--- // set the target (important) // --->
<cfif a_int_display_mbox_msg_preview IS 1>
	<!--- preview is ON, therefore set the following target: frameemailmessage --->
	<cfset request.a_str_link_current_target = '_blank' />
<cfelse>
	<!--- use "_self" target --->
	<cfset request.a_str_link_current_target = '' />
</cfif>

<cfset a_int_folder_messagescount = 1 />

<cfloop query="request.q_select_folders">
	<cfif Compare(url.mailbox, request.q_select_folders.fullfoldername) IS 0>
		<cfset a_int_folder_messagescount = request.q_select_folders.messagescount />
	</cfif>
</cfloop>

<!--- load from folderdata ... --->
<cfinvoke component="#application.components.cmp_email#" method="ListMessages" returnvariable="a_return_struct">
  <cfinvokeargument name="accessdata" value="#request.stSecurityContext.a_struct_imap_access_data#">
  <cfinvokeargument name="foldername" value="#url.mailbox#">
</cfinvoke>

<cfif NOT a_return_struct.result>
 	<b>Folder not found</b> 
 	<cfexit method="exittemplate">
</cfif>

<cfset q_select_mailbox = a_return_struct.query />
<cfset a_bol_speedmail_used = a_return_struct.a_bol_speedmail_data_used />

<cftry>
	<cfquery name="q_select_mailbox" dbtype="query">
	SELECT
		*
	FROM
		q_select_mailbox
	ORDER BY
		id DESC
	;
	</cfquery>
<cfcatch type="any">
</cfcatch>
</cftry>

<cfset a_int_original_messages_count = q_select_mailbox.recordcount />

<!--- check restrictions ... --->
<cfinclude template="utils/inc_select_mbox_display_restriction.cfm">

<cfsavecontent variable="a_str_refresh_link">
<cfoutput><a class="nl" href="##" onclick="DisplayMBoxContentASync('#JSStringFormat(url.mailbox)#');">#si_img('arrow_refresh_small')#</a></cfoutput>
</cfsavecontent>

<cfset tmp = SetHeaderTopInfoString( Returnfriendlyfoldername(url.mailbox) & ' (' & q_select_mailbox.recordcount & ') ' & trim(a_str_refresh_link) ) />

<!--- the new query string variable ... --->
<cfset a_str_md5_query_string = Hash(cgi.QUERY_STRING) />

<cfset a_str_href = cgi.SCRIPT_NAME & "?" & RemoveURLParameter(cgi.QUERY_STRING, "restrict") />

<cfsavecontent variable="a_str_js">
	var vl_del_count = 1;
	var vl_msg_count = <cfoutput>#q_select_mailbox.recordcount#</cfoutput>;

	function ShowMailBoxWithNewRestrictSettings() {
		location.href = "<cfoutput>#a_str_href#</cfoutput>&restrict="+document.formsetrestrictions.frmFilter.value;
		}
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />

<!--- include junkmail info --->
<cfif CompareNoCase(url.mailbox, "INBOX.Junkmail") is 0>
	<div class="bb">

		<div style="padding:5px;line-height:20px;">
		<b><img src="/images/si/information.png" class="si_img" /><cfoutput>#GetLangVal('mail_ph_junkmail_folder_info1')#</cfoutput></b>
		<br />
		<cfoutput>#GetLangVal('mail_ph_junkmail_folder_info2')#</cfoutput><br>
		<a href="javascript:GotoLocHref('index.cfm?action=EmptyFolder&foldername=INBOX.Junkmail&maxage=0');" target="_self"><img src="/images/si/delete.png" class="si_img" /><cfoutput>#GetLangVal('mail_ph_junkmail_folder_empty')#</cfoutput></a>
		<a href="javascript:GotoLocHref('/settings/index.cfm?action=spamguard');"><img src="/images/si/wrench.png" class="si_img" /><cfoutput>#GetLangVal('cm_wd_preferences')#</cfoutput></a>
		</div>
	</div>

</cfif>

<!--- list holder --->
<cfset a_index = 0 />

<script type="text/javascript">
	
	a_mbox_items = [];
	
	<cfoutput query="q_select_mailbox" startrow="#url.startrow#" maxrows="100">
	a_mbox_items[#a_index#] = { 'rowno' : '#a_index#', 'deleted': false, 'uid': #JsStringFormat( q_select_mailbox.id )#, 'folder' : '#jsStringFormat( q_select_mailbox.foldername )#'};
	
	<cfset a_index = a_index + 1 />
	</cfoutput>
	// console.log( a_mbox_items );
</script>

<cfinclude template="dsp_inc_show_mailbox_cols.cfm">
<!--- 
<!--- display messages ... --->
<cfif CompareNoCase(url.style, 'rows') IS 0>
	<cfinclude template="dsp_inc_show_mailbox_rows.cfm">
<cfelse>
	<cfinclude template="dsp_inc_show_mailbox_cols.cfm">
</cfif> --->

<!--- check autoload first msg ... --->
<cfset a_int_display_mbox_autoload_first_msg = GetUserPrefPerson('email', 'mbox.display.autoloadfirstmsg', '1', '', false) />