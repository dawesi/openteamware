<!--- //

	Module:		EMail
	Action:		ShowMailboxContent
	Description:Display mbox content in COLS mode
	
// --->
<cfparam name="url.startrow" type="numeric" default="1">

<!--- mailbox or search? --->
<cfparam name="MailboxContentDisplay.Displaytype" type="string" default="mailbox">

<div id="idcontent">

<cfset a_str_foldername_without_ibx = ReplaceNoCase(url.mailbox, 'INBOX', '', 'ONE') />


<form name="formsetrestrictions" style="margin:0px; ">
<table border="0" cellspacing="0" cellpadding="2" width="100%">
	
	<!--- if parent folders exist ... --->
  <!--- <cfif ListLen(a_str_foldername_without_ibx, '.') GT 0>
  	<tr>
	  	<td colspan="2">		
			
			<cfset a_str_linked_foldername = 'INBOX'>
			<cfloop from="1" to="#(ListLen(a_str_foldername_without_ibx, '.')-1)#" index="ii">
				<cfset a_str_linked_foldername = ListAppend(a_str_linked_foldername, ListGetAt(a_str_foldername_without_ibx, ii, '.'), '.')>
				<cfoutput>
				<a target="framecontent" href="/email/index.cfm?action=ShowMailbox&Mailbox=#urlencodedformat(a_str_linked_foldername)#">#htmleditformat(ListGetAt(a_str_foldername_without_ibx, ii, '.'))#</a> / 
				</cfoutput>
			</cfloop>
			
		</td>	
 	</tr>
	</cfif> --->
<!---
  <tr> 
  	  <td width="40">
		
	  </td>
      <td>
         <select name="frmFilter" <cfif Len(url.restrict) GT 0>style="background-color:orange;"</cfif> onChange="ShowMailBoxWithNewRestrictSettings();">
          <option value=""><cfoutput>#GetLangVal("mail_wd_restrict_no")#</cfoutput></option>
          <option <cfoutput>#WriteSelectedElement(url.restrict, "flagged")#</cfoutput> value="flagged"><cfoutput>#GetLangVal("mail_ph_restrict_flagged")#</cfoutput></option>
          <option <cfoutput>#WriteSelectedElement(url.restrict, "unread")#</cfoutput> value="unread"><cfoutput>#GetLangVal("mail_ph_restrict_unread")#</cfoutput></option>
          <!---<option <cfoutput>#WriteSelectedElement(url.restrict, "recent")#</cfoutput> value="recent"><cfoutput>#GetLangVal("mail_ph_restrict_last5days")#</cfoutput></option>--->
          <option <cfoutput>#WriteSelectedElement(url.restrict, "highpriority")#</cfoutput> value="highpriority"><cfoutput>#GetLangVal("mail_ph_restrict_high_priority")#</cfoutput></option>
          <option <cfoutput>#WriteSelectedElement(url.restrict, "withattachments")#</cfoutput> value="withattachments"><cfoutput>#GetLangVal("mail_ph_restrict_has_attachments")#</cfoutput></option>
          <option <cfoutput>#WriteSelectedElement(url.restrict, "fromknownpersons")#</cfoutput> value="fromknownpersons"><cfoutput>#GetLangVal("mail_ph_restrict_known_people")#</cfoutput></option>
          <option <cfoutput>#WriteSelectedElement(url.restrict, "fromunknownpersons")#</cfoutput> value="fromunknownpersons"><cfoutput>#GetLangVal("mail_ph_restrict_unknown_people")#</cfoutput></option>
          <option <cfoutput>#WriteSelectedElement(url.restrict, "junkmail")#</cfoutput> value="junkmail"><cfoutput>Spam-Nachrichten</cfoutput></option>
          <cfoutput query="q_select_all_pop3_data"> 
            <option <cfoutput>#WriteSelectedElement(url.restrict, htmleditformat("account-"&q_select_all_pop3_data.pop3server))#</cfoutput>  <cfif len(q_select_all_pop3_data.markcolor) gt 0>style="background-color:#q_select_all_pop3_data.markcolor#;"</cfif> value="#htmleditformat("account-"&q_select_all_pop3_data.pop3server)#">#htmleditformat(q_select_all_pop3_data.emailadr)#</option>
          </cfoutput>
		 </select> 
	</td>
  </tr>--->

  <cfif Len(url.restrict) gt 0>
    <!--- display the number of matching records --->
    <tr>	
      <td class="bt" colspan="2"> 
        <cfset a_str_show_all_again = GetLangVal("mail_ph_restrict_show_all_again")> 
        <cfset a_str_show_all_again = ReplaceNoCase(a_str_show_all_again , "%recordcount%", a_int_original_recordcount)> 
        <a href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "restrict", "")#</cfoutput>"><cfoutput>#a_str_show_all_again#</cfoutput></a>
	  </td>
	 </tr>
	 <tr> 
      <td class="bt" colspan="2"> 
	  
            <img src="../images/info_very_small.gif" width="10" height="10" hspace="2" vspace="2" border="0" align="absmiddle">
            <cfif (q_select_mailbox.recordcount is 0 AND a_int_original_recordcount gt 0) OR (a_int_original_recordcount is 0)>
                <font color="#CC0000" style="font-weight:bold;"> 
                <cfset a_str_no_matching = GetLangVal("mail_ph_restrict_no_matches")>
                <cfset a_str_no_matching = ReplaceNoCase(a_str_no_matching, "%RECORDCOUNT%", a_int_original_recordcount)>
                <cfoutput>#a_str_no_matching#</cfoutput> </font> 
                <cfelse>
                <cfset a_str_percent_match = GetLangVal("mail_ph_restrict_percent_match")>
                <cfset a_str_percent_match = ReplaceNoCase(a_str_percent_match , "%percent%", round(q_select_mailbox.recordcount/(a_int_original_recordcount/100)))>
                <cfoutput>#a_str_percent_match#</cfoutput> </cfif> &nbsp; 
				
		</td>
    </tr>
  </cfif>

</table>
</form>


<form action="act_multi_edit.cfm" name="mboxform" method="post" target="_self" style="margin:0px; ">
<input type="hidden" name="frmredirect" value="<cfoutput>#cgi.http_referer#</cfoutput>" />
<div style="padding:4px;display:none;" id="iddivactions" class="bb mischeader">

	<table class="table_details">
	  <tr>
	  	<td class="field_name">
			<cfoutput>#si_img( 'bin' )#</cfoutput>
		</td>
		<td colspan="2">
			<input class="btn" type="submit" name="frmSubmitDelete" value="<cfoutput>#GetLangVal('email_wd_btn_delete')#</cfoutput>" />
		</td>
	  </tr>
	  <tr>
	  	<td class="field_name">
		
		</td>
		<td>
			<select name="frmnewstatus1">
				<option value=""><cfoutput>#GetLangVal('mail_ph_change_status')#</cfoutput></option>
				<option value="read"><cfoutput>#GetLangVal('mail_ph_change_status_set_read')#</cfoutput></option>
				<option value="unread"><cfoutput>#GetLangVal('mail_ph_change_status_set_unread')#</cfoutput></option>
				<option value="flag"><cfoutput>#GetLangVal('mail_ph_change_status_flag')#</cfoutput></option>
			</select>
		</td>
		<td>
			<input class="btn" type="submit" name="frmSubmitChangeReadStatus1" value="<cfoutput>#GetLangVal('cm_wd_ok')#</cfoutput>" />
		</td>
	  </tr>
	  <tr>
	  	<td class="field_name">
			<img src="/images/si/folder_go.png" class="si_img" />
		</td>
		<td>
			<select name="frmdestinationfolder1">
				<option value=""><cfoutput>#GetLangVal('mail_wd_move_to_folder')#</cfoutput></option>
				<cfoutput query="request.q_select_folders">
				<option value="#htmleditformat(request.q_select_folders.fullfoldername)#"><cfloop from="1" to="#request.q_select_folders.level#" index="iasd">&nbsp;&nbsp;</cfloop>#htmleditformat(request.q_select_folders.foldername)#</option>
				</cfoutput>
			</select>			
		</td>
		<td>
			<input class="btn" type="submit" name="frmSubmitMove1" value="<cfoutput>#GetLangVal('cm_wd_ok')#</cfoutput>" />
		</td>
	  </tr>
	  <tr>
	  	<td class="field_name">
			<input onClick="AllMessages();" type="checkbox" name="frmcbselectall" class="noborder" />
		</td>
		<td colspan="2">
			<cfoutput>#GetLangVal('email_ph_select_all_messages')#</cfoutput>
		</td>
	  </tr>
	</table>
</div>

<cfif q_select_mailbox.recordcount IS 0>
	<div class="status">
		<cfoutput>#GetLangVal('mail_ph_no_messages_found')#</cfoutput>
	</div>
</cfif>

<cfset a_bol_more_than_one_page = (q_select_mailbox.recordcount GT a_int_mails_per_page) />

<!--- <div class="bb" style="margin-bottom:6px;padding:4px;font-weight:bold;width:96%;">

<cfoutput>#si_img('folder_star')# #Returnfriendlyfoldername(url.mailbox)#</cfoutput>
<cfif NOT a_bol_more_than_one_page>
<font class="addinfotext">(<cfoutput>#q_select_mailbox.recordcount# #GetLangVal('mail_wd_emails')#</cfoutput>)</font>
</cfif>

</div> --->

<table class="table table-hover" id="id_table_msg_header_displays">
<cfif q_select_mailbox.recordcount GT a_int_mails_per_page>
<tr>
	<td colspan="2" align="center" class="bb">
		
	<cfset a_int_scroll_index = 0 />
	<!---#cgi.QUERY_STRING# --->
	<cfinvoke component="#application.components.cmp_tools#" method="GeneratePageScroller" returnvariable="a_str_page_scroller">
		<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
		<cfinvokeargument name="current_url" value="javascript:DisplayMBoxContentASync('#JsStringFormat(url.mailbox)#', %startrow%);">
		<cfinvokeargument name="url_tag_name" value="startrow">
		<cfinvokeargument name="step" value="#a_int_mails_per_page#">
		<cfinvokeargument name="recordcount" value="#q_select_mailbox.recordcount#">
		<cfinvokeargument name="current_record" value="#url.startrow#">
	</cfinvoke>
	
	<cfoutput>#a_str_page_scroller#</cfoutput>			
	</td>
</tr>
</cfif>

<cfset a_int_date_diff = -1 />
<cfset variables.a_bol_message_age_days_col_exists = ListFindNoCase(q_select_mailbox.columnlist, 'message_age_days') />
<cfset a_str_own_email_adr = ValueList(q_select_all_pop3_data.emailadr) />
<cfset a_int_index = 0 />


<cfsavecontent variable="a_str_mbox_display">
<cfoutput query="q_select_mailbox" startrow="#url.startrow#" maxrows="100">
	
	<cfif variables.a_bol_message_age_days_col_exists>
		<cfif (q_select_mailbox.message_age_days GT a_int_date_diff)>
			<tr>
				<td colspan="2" class="addinfotext">
				
				<cfif q_select_mailbox.message_age_days IS 0>
					#GetLangVal('mail_ph_age_today')#
					<cfset a_int_date_diff = 0>
				<cfelseif q_select_mailbox.message_age_days IS 1>
					#GetLangVal('mail_ph_age_yeasterday')#
					<cfset a_int_date_diff = 1>
				<cfelseif q_select_mailbox.message_age_days LTE 7>
					#GetLangVal('mail_ph_age_last_seven_days')#
					<cfset a_int_date_diff = 7>
				<cfelseif q_select_mailbox.message_age_days LTE 30>
					#GetLangVal('mail_ph_age_last_thirty_days')#
					<cfset a_int_date_diff = 30>
				<cfelseif q_select_mailbox.message_age_days LTE 120>
					#GetLangVal('mail_ph_age_last_three_months')#
					<cfset a_int_date_diff = 120>
				<cfelse>	
					#GetLangVal('mail_ph_age_old')#
					<cfset a_int_date_diff = 99999>
				</cfif>
	
				</td>
			</tr>
			
		</cfif>
	</cfif>
	
  <!--- IMPORTANT: JS is zero - based! ... --->
  <tr id="id_row_#a_int_index#" class="data_row">
  	<td align="center" nowrap="true">
	
		<input type="checkbox" name="frmid" id="msg#a_int_index#" value="#q_select_mailbox.id#_#htmleditformat(q_select_mailbox.foldername)#" class="noborder" />	
		
		<cfif Comparenocase(q_select_mailbox.flagged, 1) is 0>
			<img src="/images/si/flag_red.png" class="si_img" />
		 <cfelseif comparenocase(q_select_mailbox.answered, 1) is 0>
			<img src="/images/si/email_go.png" alt="" class="si_img" />
		<cfelseif comparenocase(q_select_mailbox.unread, 1) is 0>
			<img src="/images/si/email.png" class="si_img" alt="" />
		<cfelseif (q_select_mailbox.attachments gt 0) AND (Comparenocase(q_select_mailbox.contenttype, "multipart/alternative") NEQ 0)>
			<img src="/images/si/attach.png" alt="" class="si_img" />
		<cfelse>
			<img src="/images/si/email_open.png" class="si_img" alt="" />
		</cfif>
	
	</td>
	<td <cfif q_select_mailbox.unread IS 1>style="font-weight:bold;"</cfif>>

		<div style="float:right" class="addinfotext">
		<cfif ListFindNoCase(q_select_mailbox.columnlist, 'message_age_days') GT 0  AND q_select_mailbox.message_age_days IS 0>
					#TimeFormat(q_select_mailbox.date_local, 'HH:mm')#
				<cfelse>
					#DateFormat(q_select_mailbox.date_local, 'dd.mm')#
				</cfif>
		</div>

		<cfset a_bol_from_is_own_adr = (ListFindNoCase(a_str_own_email_adr, q_select_mailbox.afromemailaddressonly) GT 0) />

		<cfif a_bol_from_is_own_adr>
			<cfset a_str_display_address = q_select_mailbox.ato />
		<cfelse>
			<cfset a_str_display_address = q_select_mailbox.afrom />
		</cfif>
		
		<a id="idhref#a_int_index#" onclick="LoadEmailMessage(this);return false;" href="index.cfm?action=ShowMessage&Mailbox=#urlencodedformat(q_select_mailbox.foldername)#&id=#q_select_mailbox.id#&mbox_query_md5=#a_str_md5_query_string#&rowno=#(a_int_index)#" class="nl">
			#htmleditformat(shortenstring(CheckZerostring(a_str_display_address), 27))#
			<div>#htmleditformat(Shortenstring(checkzerostring(q_select_mailbox.subject), 27))#</div>
		</a>
	</td>
  </tr>

	<cfset a_int_index = a_int_index + 1 />
  </cfoutput>
</cfsavecontent>

<cfoutput>#ReplaceNoCase(ReplaceNoCase(a_str_mbox_display, '	', '', 'ALL'), chr(10), '', 'ALL')#</cfoutput>
	
	<cfif q_select_mailbox.recordcount GT 100>
		<tr>
			<td colspan="2" align="center" class="bb">
			<cfoutput>#a_str_page_scroller#</cfoutput>			
			</td>
		</tr>
	</cfif> 
</table>
</form>

</div>

<!--- add JS information on top and call prepare method onload ... SetMsgInfoArray(); --->
<cfset tmp = AddJSToExecuteAfterPageLoad('window.setTimeout("PrepareMBoxColsDisplay()", 10);', '') />
