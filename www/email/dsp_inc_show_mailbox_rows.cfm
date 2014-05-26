<!--- //

	Module:		E-Mail
	Action:		ShowMailboxContent
	Description:Display content of folder
	

// --->

<cfparam name="url.startrow" type="numeric" default="1">
<cfparam name="url.includeheader" type="numeric" default="0">

<!--- mailbox or search? --->
<cfparam name="MailboxContentDisplay.Displaytype" type="string" default="mailbox">

<cfset a_str_add_msg_open_link = '' />
<cfif a_int_display_mbox_msg_preview IS 0>
	<cfset a_str_add_msg_open_link = '&openfullcontent=1' />
</cfif>

<cfif url.includeheader IS 1>
	<!--- add ... --->
	<cfset a_str_add_msg_open_link = a_str_add_msg_open_link & '&includeheader=1' />
</cfif>

<cfset a_str_mbox_query_md5 = Hash(cgi.QUERY_STRING) />

<cfset tmp = SetHeaderTopInfoString(Returnfriendlyfoldername(url.mailbox)) />

<cfif variables.a_bol_speedmail_used>
	<!-- mailspeed used -->
	<cfset variables.a_str_style_display_id_content = '' />
<cfelse>
	<!-- mailspeed NOT used -->
	<cfset variables.a_str_style_display_id_content = 'none' />
</cfif>

<cfif Len(url.restrict) gt 0>
<table width="100%" border="0" cellspacing="0" cellpadding="4" class="bb mischeader bl">
    <!--- display the number of matching records --->
    <tr>	
      <td class="bt"> 
        <cfset a_str_show_all_again = GetLangVal("mail_ph_restrict_show_all_again")> 
        <cfset a_str_show_all_again = ReplaceNoCase(a_str_show_all_again , "%recordcount%", a_int_original_recordcount)> 
        <a href="index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "restrict", "")#</cfoutput>" class="simplelink"><cfoutput>#a_str_show_all_again#</cfoutput></a>
	  </td>
      <td class="bt"> 
	  
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
</table>
</cfif>

<cfif q_select_mailbox.recordcount IS 0>
	<cfoutput>#GetLangVal('mail_ph_no_messages_found')#</cfoutput>
</cfif>

<cfinvoke component="#application.components.cmp_tools#" method="GeneratePageScroller" returnvariable="a_str_page_scroller">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="current_url" value="#cgi.QUERY_STRING#">
	<cfinvokeargument name="url_tag_name" value="startrow">
	<cfinvokeargument name="step" value="100">
	<cfinvokeargument name="recordcount" value="#q_select_mailbox.recordcount#">
	<cfinvokeargument name="current_record" value="#url.startrow#">
</cfinvoke>

<form action="act_multi_edit.cfm" name="mboxform" method="post" target="_self">
<table class="table_overview">
	<tr>
		<td colspan="3" style="padding:6px; ">
			<select name="frmnewstatus1">
				<option value=""><cfoutput>#GetLangVal('mail_ph_change_status')#</cfoutput></option>
				<option value="read"><cfoutput>#GetLangVal('mail_ph_change_status_set_read')#</cfoutput></option>
				<option value="unread"><cfoutput>#GetLangVal('mail_ph_change_status_set_unread')#</cfoutput></option>
				<option value="flag"><cfoutput>#GetLangVal('mail_ph_change_status_flag')#</cfoutput></option>
			</select>
			&nbsp;
			<input type="submit" name="frmSubmitChangeReadStatus1" value="<cfoutput>#GetLangVal('cm_wd_ok')#</cfoutput>" class="btn2" />
			&nbsp;|&nbsp;
			<select name="frmdestinationfolder1">
				<option value=""><cfoutput>#GetLangVal('mail_wd_move_to_folder')#</cfoutput></option>
				<cfoutput query="request.q_select_folders">
				<option value="#htmleditformat(request.q_select_folders.fullfoldername)#">#htmleditformat(request.q_select_folders.foldername)#</option>
				</cfoutput>
			</select>
			&nbsp;
			<input type="submit" name="frmSubmitMove1" value="<cfoutput>#GetLangVal('mail_wd_move_to_folder')#</cfoutput>" class="btn2" />
			&nbsp;|&nbsp;
			<input type="submit" value="<cfoutput>#GetLangVal('email_wd_btn_delete')#</cfoutput>" name="frmSubmitDelete" class="btn2" /> 
		
		</td>
		<td colspan="3">
			<cfoutput>#a_str_page_scroller#</cfoutput>	
		</td>
	</tr>
	
	<cfif url.desc IS 1>
		<cfset a_str_qs = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'desc', '0') />
	<cfelse>
		<cfset a_str_qs = ReplaceOrAddURLParameter(cgi.QUERY_STRING, 'desc', '1') />
	</cfif>
	
   <tr class="tbl_overview_header">
   	<td align="center">
		<input onClick="AllMessages();" type="checkbox" name="frmcbselectall" class="noborder" />
		<img src="/images/space_1_1.gif" class="si_img" />
		</td>
	<td>
		<cfset a_str_qs = ReplaceOrAddURLParameter(a_str_qs, 'order', 'from') />
		<a href="index.cfm?<cfoutput>#a_str_qs#</cfoutput>"><cfoutput>#GetLangVal('mail_wd_address')#</cfoutput></a>
	</td>
	<td>
		<cfset a_str_qs = ReplaceOrAddURLParameter(a_str_qs, 'order', 'subject') />
		<a href="index.cfm?<cfoutput>#a_str_qs#</cfoutput>"><cfoutput>#GetLangVal('mail_wd_subject')#</cfoutput></a>
	</td>
	<td>
		<cfset a_str_qs = ReplaceOrAddURLParameter(a_str_qs, 'order', 'date_local') />
		<a href="index.cfm?<cfoutput>#a_str_qs#</cfoutput>"><cfoutput>#GetLangVal('mail_wd_date')#</cfoutput></a>
	</td>
	<td align="right">
		<cfset a_str_qs = ReplaceOrAddURLParameter(a_str_qs, 'order', 'asize') />
		<a href="index.cfm?<cfoutput>#a_str_qs#</cfoutput>">kb</a>
	</td>
	<td>
   </tr>
	
  <cfoutput query="q_select_mailbox" startrow="#url.startrow#" maxrows="100">
  
  <cfset a_str_tr_id = q_select_mailbox.id & '_' & q_select_mailbox.foldername />
  <cfset a_str_hash_id = Hash(a_str_tr_id) />
  <tr>
  	<td align="center" nowrap <cfif StructKeyExists(a_struct_markcolors, q_select_mailbox.account)>bgcolor="#a_struct_markcolors[q_select_mailbox.account]#"</cfif>>
		<input type="checkbox" onClick="tgl(this);" name="frmid" id="msg#q_select_mailbox.currentrow#" value="#q_select_mailbox.id#_#htmleditformat(q_select_mailbox.foldername)#" class="noborder" />
				
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
    <td>
		<cfif CompareNoCase(q_select_mailbox.foldername, 'INBOX.Sent') IS 0>
			<cfset a_str_display_adr = q_select_mailbox.ato>		
		<cfelse>
			<cfset a_str_display_adr = q_select_mailbox.afrom>
		</cfif>
		<a #WriteCurrentTargetForLink()# onDblClick="OpenMsgInNewWindow('#jsstringformat(q_select_mailbox.foldername)#', '#q_select_mailbox.id#', '#request.stSecurityContext.myuserkey#');" href="index.cfm?action=showmessage&mailbox=#urlencodedformat(url.mailbox)#&id=#q_select_mailbox.id#&rowno=#a_str_hash_id#&mbox_query_md5=#Hash(cgi.QUERY_STRING)##a_str_add_msg_open_link##AddUserkeyToURL()#">#htmleditformat(shortenstring(a_str_display_adr, 40))#</a>
	</td>	
	<td>
		<!--- display link - use _self as target is neccessary --->
		<a #WriteCurrentTargetForLink()# id="idhref#q_select_mailbox.currentrow#" onClick="MarkLine('#a_str_hash_id#');" onDblClick="OpenMsgInNewWindow('#jsstringformat(q_select_mailbox.foldername)#', '#q_select_mailbox.id#', '#request.stSecurityContext.myuserkey#');" href="index.cfm?action=showmessage&mailbox=#urlencodedformat(url.mailbox)#&id=#q_select_mailbox.id#&rowno=#a_str_hash_id#&mbox_query_md5=#Hash(cgi.QUERY_STRING)##a_str_add_msg_open_link##AddUserkeyToURL()#"><cfif q_select_mailbox.unread IS 1><b></cfif>#htmleditformat(Shortenstring(checkzerostring(q_select_mailbox.subject), 30))#</a>
	</td>
	<td>
	<cfif isDate(q_select_mailbox.date_local)>
		<cfset a_str_dt_today = DateFormat(now(), "ddmmyy")>
		<cfset a_Str_dt_yeasterday = DateFormat(DateAdd("d", -1, now()), "ddmmyy")>
		<cfset a_str_dt_localdate = DateFormat(q_select_mailbox.date_local, "ddmmyy")>

		<cfif Comparenocase(a_str_dt_today, a_str_dt_localdate) is 0>
			heute #TimeFormat(q_select_mailbox.date_local, "HH:mm")#
		<cfelseif CompareNoCase(a_str_dt_localdate, a_Str_dt_yeasterday) is 0>
			gestern #TimeFormat(q_select_mailbox.date_local, "HH:mm")#
		<cfelse>
			#lsdateformat(ParseDateTime(q_select_mailbox.date_local), "ddd, dd.mm.yy")#
		</cfif>

	<cfelse>&nbsp;</cfif>
	</td>
	<td align="right">
		#byteconvert(val(q_select_mailbox.asize))#
	</td>
	<td>
		<a  href="act_delete_message.cfm?id=#q_select_mailbox.id#&mailbox=#urlencodedformat(q_select_mailbox.foldername)#&mbox_md5=#a_str_mbox_query_md5#&redirect=">#si_img('delete')#</a>
	</td>
  </tr>
  </cfoutput>
 </form>
</table>

