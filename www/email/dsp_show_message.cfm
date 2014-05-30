<!--- //

	Module:		EMail
	Action:		ShowMessage
	Description:Display an email message
	
// --->

<cfset a_tc_begin = GetTickCount() />

<cfparam name="url.id" default="0" type="numeric">
<cfparam name="url.Mailbox" default="INBOX" type="string">
<cfparam name="url.search" default="" type="string">
<cfparam name="url.username" default="#request.stSecurityContext.myusername#" type="string">
<cfparam name="url.alternativeversion" default="html" type="string">
<cfparam name="url.account" type="string" default="#request.stSecurityContext.myusername#">
<cfparam name="url.userkey" type="string" default="#request.stSecurityContext.myuserkey#">

<!--- querystring of the mailbox content display --->
<cfparam name="url.mbox_query_md5" type="string" default="">

<!--- opened as popup? --->
<cfparam name="url.popup" type="numeric" default="0">

<!--- maybe existing ... --->
<cfparam name="url.rowno" type="string" default="">

<!--- opened within the normal window (row mode) ? --->
<cfparam name="url.openfullcontent" type="numeric" default="0">

<cfparam name="url.quickanswersent" type="string" default="">

<cfset request.a_tc = GetTickCount()>

<cfset a_cmp_email_tools = CreateObject('component', '/components/email/cmp_tools')>

<!--- get default encoding if no encoding is given ... --->
<cfset a_str_email_default_encoding_if_unknown_encoding = GetUserPrefPerson('email', 'defaultencoding_if_unknown_encoding', 'UTF-8', '', false)>

<!--- surpress external elements? --->
<cfset a_int_surpress_external_elements_by_default = GetUserPrefPerson('email', 'surpress_external_elements_by_default', '1', '', false)>
	
<!--- do *not* surpress if data is coming from a certain domain (email address) --->
<cfset a_str_surpress_external_elements_exception_domains = GetUserPrefPerson('email', 'surpress_external_elements_exception_domains', '', '', false)>

<!--- mbox display style (rows or columns) --->
<cfset a_str_mbox_display_style = GetUserPrefPerson('email', 'mbox.display.viewmode', 'cols', '', false)>
	
<cfif url.id IS 0>
	<cfset a_int_display_mbox_autoload_first_msg = GetUserPrefPerson('email', 'mbox.display.autoloadfirstmsg', '0', '', false)>

	
		<div style="padding:10px; " class="addinfotext">
		<cfoutput>#GetLangVal('mail_ph_select_message')#</cfoutput>
		</div>
	<cfexit method="exittemplate">
</cfif>


<!--- load message ... --->
<!--- application.components.cmp_email --->
<cfinvoke component="#createObject( 'component', '/components/email/cmp_email' )#" method="LoadMessage" returnvariable="stReturn">
	 <cfinvokeargument name="accessdata" value="#request.stSecurityContext.a_struct_imap_access_data#">
	<cfinvokeargument name="foldername" value="#url.mailbox#">
	<cfinvokeargument name="uid" value="#url.id#">
	<cfinvokeargument name="tempdir" value="#request.a_str_temp_directory#">
	<cfinvokeargument name="savecontenttypes" value="image/x-png,image/jpeg,text/html,image/gif,text/plain,image/jpg,message/rfc,message/rfc822,image/pjpeg,rfc/822,binary/email,text/vcard,application/ms-tnef">
</cfinvoke>

<cfif NOT stReturn.result>
	Message not found.
	<cfexit method="exittemplate">
</cfif>


<cfset q_select_message = stReturn.q_select_message />
<cfset q_select_attachments = stReturn.attachments_query />
<cfset q_Select_headers = stReturn.q_select_headers />
	

<!--- select the "real" attachments (no multipart/alternative stuff and so on) ... --->
<cfquery name="q_select_real_attachments" dbtype="query">
SELECT
	*
FROM
	q_select_attachments
WHERE
	<cfif FindNoCase('multipart/alt', q_select_message.contenttype) GT 0>
		(simplecontentid >1) OR (filenamelen > 0) OR NOT (contenttype IN ('text/plain','text/html'))
	<cfelse>
		(simplecontentid >=1) OR (filenamelen > 0)
	</cfif>
;
</cfquery>

<cfset a_str_message_id = q_select_message.messageid />

<cfset request.a_str_current_page_title = q_select_message.subject & ' (' & q_select_message.afrom & ')' />

<cflock name="lck_set_att"timeout="3" type="exclusive">
	<cfset session.q_msg_attachments = q_select_attachments />
</cflock>

<cfset a_str_charset_html_content = 'ISO-8859-1' />

<cfif (q_select_message.unread is 1) AND CompareNoCase(url.userkey, request.stSecurityContext.myuserkey) IS 0>

	<!--- set this message read --->
	<cfinvoke component="#a_cmp_email_tools#" method="setmessagestatus" returnvariable="a_str_result">
		<cfinvokeargument name="server" value="#request.a_str_imap_host#">
		<cfinvokeargument name="username" value="#request.a_str_imap_username#">
		<cfinvokeargument name="password" value="#request.a_str_imap_password#">
		<cfinvokeargument name="foldername" value="#url.mailbox#">
		<cfinvokeargument name="uid" value="#url.id#">
		<cfinvokeargument name="status" value="2">
	</cfinvoke>

</cfif>


<!--- check if we're NOT in the row mode --->
<cfset variables.a_bol_not_in_row_mode = (Compare(a_str_mbox_display_style, 'rows') NEQ 0) />

<cfif url.popup NEQ 0>
	<!--- popup, that also does NOT count as row mode --->
	<cfset variables.a_bol_not_in_row_mode = false />
</cfif>

<!--- // check if this message is marked as spam ... --->
<!---<cfset a_arr_headers = QueryToArrayOfStructures(q_select_headers)>--->

<cfset a_bol_is_spam = false />
<cfset a_bol_is_fax_message = false />
<cfset a_str_fax_transactionID = '' />
<cfset a_str_full_contenttype = '' />
<cfset a_str_references = '' />
<cfset a_bol_is_qual_signed_msg = false />
<cfset a_bol_sm_jobkey = '' />
<cfset a_int_spam_level = 0 />
<cfset a_str_spam_report = '' />

<cfloop query="q_select_headers">

	<cfswitch expression="#q_select_headers.feld#">
		<cfcase value="X-Spam-Flag">
			<cfset a_bol_is_spam = (CompareNoCase(q_select_headers.wert, 'yes') IS 0) />
		</cfcase>
		<cfcase value="Content-Type">
			<cfset a_str_full_contenttype = q_select_headers.wert />
		</cfcase>
		<cfcase value="In-Reply-To">
			<!--- in reply to which msg ... --->
			<cfset a_str_references = ListPrepend(a_str_references, q_select_headers.wert, '') />
		</cfcase>
		<cfcase value="References">
			<!--- references to other messages ... --->
			<cfset a_str_references = ListPrepend(a_str_references, q_select_headers.wert, '') />
		</cfcase>
		<cfcase value="X-openTeamware.com-sm-jobkey">
			<cfset a_bol_sm_jobkey = q_select_headers.wert />
		</cfcase>
		<cfcase value="X-Spam-Level">
			<!--- level ... --->
			<cfset a_int_spam_level = Len(q_select_headers.wert) />
		</cfcase>
		<cfcase value="X-Spam-Report">
			<!--- full report --->
			<cfset a_str_spam_report = q_select_headers.wert />
		</cfcase>		
	</cfswitch>
		
</cfloop>


<!--- check if we have an html body version or not --->
<cfset a_bol_alternative_version_avaliable = false />

<cfif FindNoCase("multipart/", q_select_message.contenttype) GT 0>

	<!--- maybe we have an alternative version ... check it now --->

	<cfquery name="q_select_alternativ_version" maxrows="1" dbtype="query">
	SELECT
		contentid,simplecontentid,charset,tempfilename
	FROM
		q_select_attachments
	WHERE
		(simplecontentid <= 1)
	AND
		((contenttype IS NOT NULL) AND (UPPER(contenttype) = 'TEXT/HTML'))
	AND
		(filenamelen = 0)
	;
	</cfquery>

	<cfif q_select_alternativ_version.recordcount IS 1>

		<!--- yes, we've an alternative version --->
		<cfset a_bol_alternative_version_avaliable = true />
		
		<cfset a_str_charset_html_content = q_select_alternativ_version.charset>
		
		<cfif Len(q_select_alternativ_version.tempfilename) GT 0>
			<cfset sFilename_html_version = GetFileFromPath(q_select_alternativ_version.tempfilename)>
		<cfelse>
			<!--- save attachment ... --->
			<cfinvoke component="#a_cmp_email_tools#" method="loadattachment" returnvariable="a_struct_result_load_att">
				<cfinvokeargument name="server" value="#request.a_str_imap_host#">
				<cfinvokeargument name="username" value="#request.a_str_imap_username#">
				<cfinvokeargument name="password" value="#request.a_str_imap_password#">
				<cfinvokeargument name="foldername" value="#url.mailbox#">
				<cfinvokeargument name="uid" value="#url.id#">
				<cfinvokeargument name="partid" value="#q_select_alternativ_version.contentid#">
				<cfinvokeargument name="savepath" value="#request.a_str_temp_directory_local#">
			</cfinvoke>
			
			<cfset sFilename_html_version = GetFileFromPath(a_struct_result_load_att.savepath)>
			
		</cfif>

	</cfif>		

</cfif>


<cfinclude template="dsp_inc_new_message_display_header.cfm">

<!--- image surpress ?? is this domain an exception? --->
<cfset a_str_from = ExtractEmailAdr(q_select_message.afrom)>
<cfset a_str_from_domain = ListLast(a_str_from, '@')>

<cfif ListFindNoCase(a_str_surpress_external_elements_exception_domains, a_str_from_domain, chr(10)) GT 0>
	<cfset a_int_surpress_external_elements_by_default = 0>
</cfif>

<cfif CompareNoCase('INBOX.Junkmail', url.mailbox) IS 0>
	<!--- *always* surpress images in the junkmail folder --->
	<cfset a_int_surpress_external_elements_by_default = 1 />
</cfif>

<div id="idtableqa" style="display:none;padding:4px;" class="bb">

<div style="padding:6px;font-weight:bold; "><cfoutput>#GetLangVal('mail_ph_msg_quickanswer_title')#</cfoutput></div>

<form action="#" method="post" name="formqa" target="_self" onSubmit="SendQANew('<cfoutput>#jsstringformat(url.mailbox)#</cfoutput>','<cfoutput>#jsstringformat(url.id)#</cfoutput>');return false;" style="margin:0px; ">
<input type="hidden" name="frmmailbox" value="<cfoutput>#url.mailbox#</cfoutput>">
<input type="hidden" name="frmid" value="<cfoutput>#url.id#</cfoutput>">
<table class="table_details table_edit_form">
  <tr>
    <td>
		<textarea class="b_all" name="frmtext" cols="20" rows="5" style="width:100%; "></textarea>
	</td>
  </tr>
  <tr id="idtrqastatus" style="display:none; ">
  	<td align="center">
		<cfoutput>#GetLangVal('mail_ph_msg_quickanswer_status_sending')#</cfoutput>
		<br /><br />
		<img src="/images/img_bar_status_loading.gif" width="107" height="13" border="0"/>
	</td>
  </tr>
  <tr id="idtrqasend">
    <td>
		<input type="submit" class="btn btn-primary" value="<cfoutput>#GetLangVal("mail_ph_SendNow")#</cfoutput>">
		&nbsp;&nbsp;
		<input type="checkbox" name="frmquote" class="noborder" value="1" checked> <cfoutput>#GetLangVal('mail_ph_msg_quickanswer_quote')#</cfoutput>
	</td>
  </tr>
</table>
</form>
</div>


<cfif ((NOT a_bol_alternative_version_avaliable) OR (url.alternativeversion is "text")) AND (CompareNoCase("text/html", q_select_message.contenttype) neq 0)>

	<cfset a_str_body_text = q_select_message.body />
	
	<div style="padding:6px;">
	<!-- start output for <cfoutput>#q_select_message.contenttype#</cfoutput> -->

	<cfset a_bol_quote_start = false />

	<cfloop list="#a_str_body_text#" delimiters="#chr(10)#" index="a_str_msg_line">

		<cfset a_str_msg_line = trim(a_str_msg_line) />
		<cfset a_str_msg_line = ActivateURL(a_str_msg_line) />
		<cfset a_str_msg_line = htmleditformat(a_str_msg_line) />
		<cfset a_str_msg_line = Replace(a_str_msg_line, '&lt;A ', '<A ', 'ALL') />
		<cfset a_str_msg_line = Replace(a_str_msg_line, 'target=&quot;', 'target="', 'ALL') />
		<cfset a_str_msg_line = Replace(a_str_msg_line, '_blank&quot;', '_blank"', 'ALL') />
		<cfset a_str_msg_line = Replace(a_str_msg_line, 'HREF=&quot;', 'HREF="', 'ALL') />
		<cfset a_str_msg_line = Replace(a_str_msg_line, '&quot;&gt;', '">', 'ALL') />
		<cfset a_str_msg_line = Replace(a_str_msg_line, '&lt;/A&gt;', '</A>', 'ALL') />	

			<cfif (FindNoCase('&gt;', trim(a_str_msg_line)) IS 1)>
			
				<cfif NOT a_bol_quote_start>
					<cfset a_bol_quote_start = true />
					<div class="mischeader">
				</cfif>
				
			<cfelse>
				<cfif a_bol_quote_start>
					<cfset a_bol_quote_start = false />
					</div>
				</cfif>
			</cfif>
		<cfoutput>#a_str_msg_line#</cfoutput><br />
	</cfloop>
	
	<cfif a_bol_quote_start>
		</div>
	</cfif>
	
	</div>

</cfif>



<cfif (q_select_message.contenttype is "text/html")>

	<cfset a_str_charset_html_version = a_str_email_default_encoding_if_unknown_encoding />
		
	<cfinvoke component="#a_cmp_email_tools#" method="MakeHTMLMailSafe" returnvariable="stReturn_email_html">
		<cfinvokeargument name="input_html" value="#q_select_message.body#">
		<cfinvokeargument name="surpress_images" value="#a_int_surpress_external_elements_by_default#">
	</cfinvoke>
		
	<div style="padding:6px; ">
		<cfoutput>#stReturn_email_html.content#</cfoutput>
	</div>
	
	<cfset a_str_body_text = q_select_message.body />

	<cfset sFilename_id = createuuid() />

	<cffile action="write" file="#request.a_str_temp_directory_local##sFilename_id#" output="#a_str_body_text#" addnewline="no" charset="ISO-8859-1">
	
	<!--- <div class="bt" style="padding:2px;">

	<a target="_blank" href="show_html_version.cfm?userkey=<cfoutput>#url.userkey#</cfoutput>&secure=0&privacyguardenabled=0&id=<cfoutput>#sFilename_id#</cfoutput>"><img src="/images/si/page_code.png" class="si_img" /><cfoutput>#GetLangVal('mail_ph_msg_show_full_html_version')#</cfoutput></a>

	</div>
 --->
	<!--- display html version --->

<!--- <cfelseif q_select_message.contenttype is "application/x-pkcs7-mime" OR q_select_message.contenttype IS 'application/pkcs7-mime'>

	<!--- encrypted --->
	<cfset a_bol_is_gpg_mail = true />

	<h4>Diese Nachricht wurde verschluesselt.</h4>
	
	<cfinclude template="dsp_inc_securemail_signed.cfm">

<cfelseif q_select_message.contenttype is "multipart/signed">

	<cfset a_bol_signed_email = true>
	<cfset a_bol_is_gpg_mail = true>
	
	<cfinclude template="sm/dsp_inc_signed_verify.cfm"> --->

</cfif>

<!--- // alternative version is avaliable // --->
<cfif a_bol_alternative_version_avaliable AND url.alternativeversion is "html">
		
	<!--- in spam messages disable loading of web_bugs --->
	<cfif a_bol_is_spam>
		<cfset a_str_privacy_guard_enabled = 1 />
	<cfelse>
		<cfset a_str_privacy_guard_enabled = 0 />
	</cfif>
	
	<!--- charset--->
	<cfif Len(q_select_alternativ_version.charset) GT 0>
		<cfset a_str_charset_html_version = q_select_alternativ_version.charset>
	<cfelse>
		<cfset a_str_charset_html_version = a_str_email_default_encoding_if_unknown_encoding>
	</cfif>
		
	<!--- if invalid charset, use default ... --->
	<cfif ListFindNoCase('utf-8,iso-8859-1', a_str_charset_html_version) IS 0>
		<cfset a_str_charset_html_version = 'utf-8'>
	</cfif>
		
	<cffile action="read" file="#q_select_alternativ_version.tempfilename#" charset="#a_str_charset_html_version#" variable="a_str_html_version">
	
	<cfinvoke component="#a_cmp_email_tools#" method="MakeHTMLMailSafe" returnvariable="stReturn_email_html">
		<cfinvokeargument name="input_html" value="#a_str_html_version#">
		<cfinvokeargument name="surpress_images" value="#a_int_surpress_external_elements_by_default#">
	</cfinvoke>
		
	<cfset a_str_content = stReturn_email_html.content />
		
	<cfif (FindNoCase("cid:", a_str_content) gt 0) AND (q_select_attachments.recordcount GT 0)>
		<cfloop query="q_select_attachments">
			<cfif Len(q_select_attachments.cid) GT 0>
		
				<cfset a_str_cid = ReplaceNoCase(ReplaceNoCase(q_select_attachments.cid, '<', ''), '>', '')>
		
				<cfset a_str_tmp_filename = GetFileFromPath(q_select_attachments.tempfilename)>
		
				<cfset a_str_img_link = 'show_load_saved_att_img.cfm?thumbnail=0&src='&a_str_tmp_filename&'&contenttype='&q_select_attachments.contenttype&'&userkey='&url.userkey>
		
				<cfset a_str_content = ReplaceNoCase(a_str_content, 'cid:' & a_str_cid, a_str_img_link, 'ALL')>
		
			</cfif>
		</cfloop>
	</cfif>
		
	<cfif stReturn_email_html.images_surpressed>
		<!--- images have been surpressed --->
		<div style="padding:6px;" class="bb">
			<a href="index.cfm?Action=AddDomainToRemoteImageDisplayException&sender=<cfoutput>#urlencodedformat(a_str_from)#</cfoutput>"><img src="/images/si/picture_delete.png" class="si_img" /><cfoutput>#GetLangVal('mail_ph_images_have_been_surpressed_info_download_now')#</cfoutput></a>
		</div>
		
	</cfif>
	
	<div style="padding:6px;width:95%;">
		<cfoutput>#a_str_content#</cfoutput>
	</div>

	<cfif stReturn_email_html.unsafe>
	<!--- <div style="padding:6px; " class="bt">
		<a target="_blank" href="show_html_version.cfm?userkey=<cfoutput>#url.userkey#</cfoutput>&charset=<cfoutput>#urlencodedformat(a_str_charset_html_content)#</cfoutput>&privacyguardenabled=<cfoutput>#a_str_privacy_guard_enabled#</cfoutput>&secure=0&id=<cfoutput>#sFilename_html_version#</cfoutput>"><img src="/images/si/page_code.png" class="si_img" /><cfoutput>#GetLangVal('mail_ph_msg_show_full_html_version')#</cfoutput></a>
	</div> --->
	</cfif>
	
</cfif>

<!--- attachments? --->
<cfif q_select_real_attachments.recordcount gt 0>
	<cfinclude template="dsp_inc_msg_attachments.cfm">
</cfif>

<!--- references? only in mailspeed mode! ... --->
<cfif request.appsettings.properties.mailspeedenabled IS 1>
	<!--- references? --->
	<cftry>
	<cfif StructKeyExists(variables, 'q_select_reference_messages') AND (q_select_reference_messages.recordcount GT 0)>
		<cfset variables.CheckReferencesRequest.date_local = q_select_message.date_local>
		<cfset variables.CheckReferencesRequest.references = a_str_references>
		<cfset variables.CheckReferencesRequest.messageid = a_str_message_id>
		
		<cfinclude template="utils/dsp_inc_check_references.cfm">
	</cfif>
	<cfcatch type="any">
	</cfcatch>
	</cftry>
</cfif>

<!--- the div for referenced messages --->
<div id="id_div_references" style="display:none;"></div>

<cfif (url.openfullcontent IS 0) AND (Len(url.rowno) GT 0)>
	<cfsavecontent variable="a_str_js_add">
	try {
		parent.MarkLine('<cfoutput>#url.rowno#</cfoutput>');
		}
	catch(e)
		{ }
	</cfsavecontent>
	
	<cfscript>
		AddJSToExecuteAfterPageLoad('', a_str_js_add);
	</cfscript>
</cfif>


<cfif q_select_message.recordcount is 0>

	<h4><cfoutput>#GetLangVal('mail_ph_no_message_found')#</cfoutput></h4>	

</cfif>

<cfif url.popup IS 0>

	<cfscript>
		// hide loading information (only if NOT in popup mode)
		AddJSToExecuteAfterPageLoad('HideStatusInformation()', '');
	</cfscript>
				
</cfif>