<!--- //

	Module:		Email
	Action:		Folders
	Description:Display all folders
	
// --->

<cfparam name="url.userkey" type="string" default="">

<!--- Ordner anzeigen --->

<!--- immer mit einem Link --->
<cfset rcd_count = 0 />

<cfset a_arr_tmp = ArrayNew(1) />
<cfset tmp = QueryAddColumn(request.q_select_folders, "weight", a_arr_tmp) />

<cfoutput query="request.q_select_folders">

	<cfif ListFindNoCase("INBOX,INBOX.Trash,INBOX.Junkmail,INBOX.Sent,INBOX.Drafts", request.q_select_folders.fullfoldername) is 0>
		<cfset a_int_weight = 0 />
	<cfelse>
		<cfset a_int_weight = 1 />
	</cfif>

	<cfset tmp = QuerySetCell(request.q_select_folders, "weight", a_int_weight, request.q_select_folders.currentrow) />

</cfoutput>


<cfquery name="request.q_select_folders" dbtype="query">
SELECT
	*,UPPER(fullfoldername) AS uffn
FROM
	request.q_select_folders
ORDER BY
	weight DESC,uffn
;
</cfquery>

<cfsavecontent variable="a_str_content">
<table class="table_overview">
  <tr class="tbl_overview_header">
	<td>
		<cfoutput>#GetLangVal("mail_wd_foldername")#</cfoutput>
	</td>
	<td align="right">
		<cfoutput>#GetLangVal("mail_wd_messages")#</cfoutput>
	</td>
	<td align="right">
		<cfoutput>#GetLangVal("mail_wd_unread")#</cfoutput>
	</td>
	<td align="center">
		<cfoutput>#GetLangVal("mail_wd_action")#</cfoutput>
	</td>
  </tr>

  <cfoutput query="request.q_select_folders">

  <cfset a_bol_built_in_folder = (ListFindNoCase('INBOX,INBOX.Trash,INBOX.Drafts,INBOX.Sent,INBOX.Junkmail', request.q_select_folders.fullfoldername) GT 0) />
  <tr>
    <td>
		<!--- subfolder? --->
		<cfset a_str_foldername_tmp = ReplaceNoCase(request.q_select_folders.fullfoldername, "INBOX.", "") />
		
		<cfif FindNocase(".", a_str_foldername_tmp) GT 0>
			<cfloop list="#a_str_foldername_tmp#" delimiters="." index="a_Str_foldername_part">&nbsp;&nbsp;&nbsp;</cfloop>
		</cfif>
	
		<cfif request.q_select_folders.unreadmessagescount GT 0><img src="/images/si/folder_star.png" class="si_img" /><cfelse><img src="/images/si/folder.png" class="si_img" /></cfif>
	
		<a <cfif request.q_select_folders.unreadmessagescount GT 0>style="font-weight:bold;"</cfif> href="index.cfm?action=ShowMailbox&amp;Mailbox=#urlencodedformat(request.q_select_folders.fullfoldername)##AddUserkeytourl()#">#htmleditformat(request.q_select_folders.foldername)#</a>
	</td>
    <td align="right">
		#val(request.q_select_folders.messagescount)#
	</td>
    <td align="right" <cfif val(request.q_select_folders.unreadmessagescount) gt 0>style="font-weight:bold;color:red;"</cfif>>
		<cfif val(request.q_select_folders.unreadmessagescount) gt 0>#request.q_select_folders.unreadmessagescount#</cfif>
	</td>
    <td style="text-align:center;">

	<cfif NOT a_bol_built_in_folder>
		<a class="nl" href="##" onclick="EditMailbox('#jsstringformat(request.q_select_folders.fullfoldername)#');return false;"><img src="/images/si/pencil.png" alt="edit" class="si_img" /></a>
		&nbsp;
		<a class="nl" href="##" onclick="AskDeleteMailbox('#urlencodedformat(request.q_select_folders.fullfoldername)#');return false;"><img src="/images/si/delete.png" alt="delete" class="si_img" /></a>
	</cfif>

	</td>
  </tr>
 
  <cfif Comparenocase(request.q_select_folders.fullfoldername, "INBOX") IS 0>

  <!--- //
		display the possibility to display only certain emails
	// --->
  	<tr>

		<form name="formgotorestrictedmboxview" action="##">

		<td style="padding-left:40px;line-height:17px;" colspan="4" class="bb">

		#GetLangVal('mail_ph_showfolders_restrict_inbox_view')#:

		<select name="frmGotoRestrictedVersionOfInbox" onChange="GotoRestrictedMboxView();" class="mischeader">

			<option value="">#GetLangVal('cm_ph_please_select_option')#</option>

			<option value="">#GetLangVal("mail_wd_restrict_no")#</option>

			<option value="flagged">#GetLangVal("mail_ph_restrict_flagged")#</option>

			<option value="unread">#GetLangVal("mail_ph_restrict_unread")#</option>

			<option value="recent">#GetLangVal("mail_ph_restrict_last5days")#</option>

			<option value="highpriority">#GetLangVal("mail_ph_restrict_high_priority")#</option>

			<option value="withattachments">#GetLangVal("mail_ph_restrict_has_attachments")#</option>

			<option value="fromknownpersons">#GetLangVal("mail_ph_restrict_known_people")#</option>

			<option value="fromunknownpersons">#GetLangVal("mail_ph_restrict_unknown_people")#</option>	

		</select>

		</td>

		</form>

	</tr>

  </cfif>

  </cfoutput>

  

  <cfif request.stSecurityContext.myuserid is 2>

	<cfinclude template="shareddata/dsp_overview.cfm">

  </cfif>


</table>
</cfsavecontent>

<cfsavecontent variable="a_str_buttons">
<input type="button" class="btn" onclick="GotoLocHref('index.cfm?action=NewFolder');" type="button" value="<cfoutput>#GetLangval("mail_ph_newFolder")#</cfoutput>" />

<input type="button" class="btn2" onclick="GotoLocHref('index.cfm?action=EmptyFolder&foldername=INBOX.Trash&maxage=0');" value="Papierkorb <cfoutput>#GetLangVal('mail_wd_empty')#</cfoutput>" />
<input type="button" class="btn2" onclick="GotoLocHref('index.cfm?action=EmptyFolder&foldername=INBOX.Junkmail&maxage=0');" value="Junkmail <cfoutput>#GetLangVal('mail_wd_empty')#</cfoutput>" />

<cfif request.appsettings.properties.mailspeedenabled IS 1>
<input class="btn2" onclick="GotoLocHref('act_reload_folder_structure.cfm');" href="##" value="<cfoutput>#GetLangVal('mail_ph_reload_folder_structure')#</cfoutput>" />
</cfif>

</cfsavecontent>


<cfoutput>#WriteNewContentBox(GetLangVal('mail_wd_folders'), a_str_buttons, a_str_content)#</cfoutput>

