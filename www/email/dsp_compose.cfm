<!--- //

	Module:		EMail
	Action:		ComposeMail
	Description:Compose a new mail / reply / forward
	

// --->

<cfinclude template="queries/q_select_all_pop3_data.cfm">

<cfsavecontent variable="a_str_js_unsaved_mail">
	var a_bol_unsaved_mail = true;
	// stop for a1 sign dialog on sending ...
	
	// MOVE TO COMPOSE JS AFTER BEING FINISHED
	var vg_stop_for_mobile_signature = true;
		
		function CheckUnsavedMail() {
			
			if (a_bol_unsaved_mail == true)
				{
				event.returnValue = confirm('Are you sure?'); 
				}
			}
			
		function SetUnsavedMailToFalse() {
			a_bol_unsaved_mail = false;
			}
			
	window.setTimeout("AutoSaveEmailData()", 120000);
	
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js_unsaved_mail) />
<cfset q_select_company_data = application.components.cmp_customer.GetCustomerData(entrykey = request.stSecurityContext.mycompanykey) />

<!--- has the format been provided? ... --->
<cfset a_bol_explicit_format_provided = StructKeyExists(url, 'format') />

<div id="id_div_email_compose_window">
<cfparam name="ComposemailRequest.popup" type="boolean" default="false">
<cfparam name="url.format" default="text" type="string">
<cfparam name="url.body" type="string" default="">
<cfparam name="url.draftid" type="numeric" default="0">

<!--- forward + reply: the original ID --->
<cfparam name="url.id" default="0" type="numeric">
<!--- original mailbox --->
<cfparam name="url.mailbox" type="string" default="">

<cfparam name="url.mailFrom" default="#request.stSecurityContext.myusername#">
<cfparam name="url.to" type="string" default="">
<cfparam name="url.subject" type="string" default="">
<cfparam name="url.cc" type="string" default="">
<cfparam name="url.bcc" type="string" default="">
<cfparam name="url.priority" type="numeric" default="3">
<cfparam name="url.requestreadconfirmation" type="numeric" default="0">
<cfparam name="url.type" type="numeric" default="0">
<cfparam name="url.attachmenthandling" default="sendreally">

<!--- attach files from the storage? --->
<cfparam name="url.attachfiles" type="string" default="">

<!--- load personal properties ... --->
<cfset a_str_default_address = GetUserPrefPerson('email', 'defaultemailaccount', request.stSecurityContext.myusername, '', false) />
<cfset a_int_confirmsend = GetUserPrefPerson('email', 'confirmsend', '1', '', false) />
<cfset a_str_email_default_format = GetUserPrefPerson('email', 'defaultformat', 'plain', '', false) />
<cfset a_str_insert_signature_by_default = GetUserPrefPerson('email', 'insertsignaturebydefault', '1', '', false) />
<cfset sVcard_entrykey = GetUserPrefPerson('email', 'addressbook.addvcardtomail.entrykey', '', '', false) />
<cfset a_int_attach_vcard_enabled = GetUserPrefPerson('email', 'addressbook.addvcardtomail', '', '', false) />

<!--- build list of needed translations in javascript code ... --->
<cfset a_str_list_get_js_lang = 'mail_ph_compose_confirm_sending_js_box,mail_ph_compose_no_recipients_entered,mail_ph_status_sending_mail,mail_ph_mail_has_been_autosaved' />
<cfset tmp = ExportTranslationValuesAsJS(a_str_list_get_js_lang) />

<!--- set format to html if html is the default format and no explicit format has been provided ... --->
<cfif (url.type IS 0) AND (a_str_email_default_format IS 'html') AND NOT a_bol_explicit_format_provided>
	<cfset url.format = 'html' />
</cfif>

<!--- important ... load draft mail ... --->
<cfset a_int_draft_id = url.draftid />

<cfif a_int_draft_id NEQ 0>
	<cfinclude template="utils/inc_load_draft_message.cfm">
</cfif>	

<!--- cleanup .... --->
<cfset url.to = replacenocase(url.to, "mailto:", "", "ALL") />

<!--- get the email address only ... --->
<cfset a_str_tmp_to = ExtractEmailAdr(url.to) />

<form action="index.cfm?action=ActCheckSendMailOperation&CFID=<cfoutput>#client.CFID#&CFTOKEN=#client.CFToken#</cfoutput>" onSubmit="return ValidateForm(<cfoutput>#a_int_confirmsend#</cfoutput>);SetUnsavedMailToFalse();" method="POST" name="sendform" <cfif ComposemailRequest.popup>style="margin:0px;"</cfif>>

<cfif StructKeyExists(cookie, 'ib_session_key')>
	<input type="hidden" name="frmibsessionkey" value="<cfoutput>#cookie.ib_session_key#</cfoutput>" />
</cfif>

<!--- action on next page --->
<input type="hidden" name="mailAction" value="SendMail" />

<!--- which content part should be removed? --->
<input type="hidden" name="frmpartidtoremove" id="frmpartidtoremove" value="0" />

<!--- cancel lookup window --->
<input type="hidden" name="frmcancellookupwindowopen" id="frmcancellookupwindowopen" value="0" />

<!--- current userkey --->
<input type="hidden" name="frmuserkey" id="frmuserkey" value="<cfoutput>#request.stSecurityContext.myuserkey#</cfoutput>" />

<!--- ist an dieser nachricht bereits herumget&uuml;ftelt worden?? --->

<!--- id > 0 ... -> message from drafts! --->

<input type="hidden" name="frmDraftId" value="<cfoutput>#a_int_draft_id#</cfoutput>" />

<!--- are we in draft autosave mode or not? default = false --->
<input type="hidden" name="frmDraftAutoSave" value="false" />
<input type="hidden" name="frmDraftMessageID" value="" />

<cfparam name="form.preid" type="string" default="0">
<cfparam name="url.preid" type="numeric" default="0">

<!--- dummy URL fields ... never really set by the URL paramter ... --->
<cfparam name="url.frmreferences" type="string" default="">

<!--- vielleicht sollen files angeh&auml;ngt werden? --->

<cfparam name="url.forwardattachments" default="">

<cfset a_int_pre_id = 0>
<cfif form.preid neq 0><cfset a_int_pre_id = form.preid /></cfif>
<cfif url.preid neq 0><cfset a_int_pre_id = url.preid /></cfif>

<input type="Hidden" name="preid" value="<cfoutput>#a_int_pre_id#</cfoutput>" />

<!--- wird sp&auml;ter f&uuml;r status-meldungen ben&ouml;tigt --->
<!--- die orginale id --->
<input type="Hidden" name="frmoriginalid" value="<cfoutput>#url.id#</cfoutput>" />
<input type="hidden" name="frmmailbox" value="<cfoutput>#htmleditformat(url.mailbox)#</cfoutput>" />
<!--- vorgang ... antwort, weiterleiten --->
<input type="Hidden" name="frmtype" value="<cfoutput>#url.type#</cfoutput>" />


<cfswitch expression="#url.type#">
	<cfcase value="0">
		<!--- new mail --->
		<cfif Len(a_str_default_address) GT 0>
			<cfset url.mailfrom = a_str_default_address>
		</cfif>
	</cfcase>
	
	<cfcase value="1">
		<!--- reply --->
		<cfinclude template="inc_compose_reply.cfm">
	</cfcase>
	
	<cfcase value="2">
		<!--- forward --->
		<cfinclude template="inc_compose_forward.cfm">	
	</cfcase>
</cfswitch>

<!--- check the further hidden fields ... --->
<input type="hidden" name="frmreferences" value="<cfoutput>#htmleditformat(url.frmreferences)#</cfoutput>" />

<cfif (url.type is 0) AND ((Len(url.body) is 0) OR StructKeyExists(url, 'forcesig')) AND (a_str_insert_signature_by_default is 1)>
	<!--- load signature ... --->
	<cfif url.format IS 'html'>
		<cfset a_int_sig_format = 1 />
	<cfelse>
		<cfset a_int_sig_format = 0 />
	</cfif>
	
	<cfinvoke component="#application.components.cmp_content#" method="GetSignaturesOfUser" returnvariable="q_select_signatures">
		<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
		<cfinvokeargument name="format" value="#a_int_sig_format#">
		<cfinvokeargument name="email_adr" value="#url.mailfrom#">
	</cfinvoke>
	
	<cfif q_select_signatures.recordcount GT 0>
		<cfif url.format IS 'html'>
			<cfset url.body = url.body & '<br/><br/>' & q_select_signatures.sig_data />
		<cfelse>
			<cfset url.body = url.body & chr(13) & chr(10) & chr(13) & chr(10) & q_select_signatures.sig_data />
		</cfif>
	</cfif>
	
</cfif>

<!--- // attachments coming from the storage // --->
<cfif len(url.attachfiles) gt 0>
	<cfinclude template="utils/inc_check_storage_files.cfm">
</cfif>

<cfif Len(trim(url.attachfiles)) gt 0>
	<!--- dummy prozess einf&uuml;hren ... wenn der user auf "absenden" oder "datei entfernen"
		"als entwurf speichern klickt sollen die attachments kopiert werden --->
	<cfset AUserDummyAttachmentListing = true>
	<cfset url.attachfiles= url.attachfiles & "," />
	<input type="Hidden" name="frmCopyAttachments" value="1" />
<cfelse>
	<!--- dummy values setzen --->
	<cfset AUserDummyAttachmentListing = false />
	<input type="Hidden" name="frmCopyAttachments" value="0" />
</cfif>

<!--- // attachments coming from other emails (attachments there) --->
<cfif Len(trim(url.forwardattachments)) gt 0>
	<cfset A_bol_forwardattachments = True>
	<cfset url.forwardattachments = url.forwardattachments & "," />
	<input type="hidden" name="frmCopyEMailAttachments" value="1" />
	<cfelse>
	<cfset A_bol_forwardattachments = false />
	<input type="hidden" name="frmCopyEMailAttachments" value="0" />
</cfif>

<span style="display:none" id="id_top_status_information"></span>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="id_tbl_top_mail_header">
<tr>
	<td>
	
	<table class="table_details table_edit_form table_compose_mail">
		<tr class="div_header_top">
			<td style="text-align:right;" class="bb">
				
				<cfoutput>#si_img('email')#</cfoutput>
				
			
			</td>
			<td style="font-weight:bold;" class="bb">
				
				<cfoutput>#GetLangVal('mail_ph_top_new_message_hint')#</cfoutput>
				<img src="/images/space_1_1.gif" class="si_img" />
				<br />
				<!--- actions ... --->
				<input class="btn btn-primary" type="submit" name="SubmitSendMessage2" onclick="SetMailAction('sendmail');" value="<cfoutput>#GetLangVal('mail_ph_SendNow')#</cfoutput>" style="font-weight:bold;">
				<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
				
				<input type="button" onclick="SetMailAction('addattachment');document.sendform.submit();" class="btn" value="<cfoutput>#GetLangVal('mail_ph_add_attachments_header')#</cfoutput>">
				<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
				
				<input type="button" onclick="ShowOrHideAddressbook();" class="btn" value="<cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput>">
				<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
				
				<input class="btn" type="button" onClick="SetMailAction('savedraft');document.sendform.submit();" value="<cfoutput>#GetLangVal('mail_ph_saveDraft')#</cfoutput>">
				<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
				
				<input class="btn" type="button" onClick="SetMailAction('cancelmsg');document.sendform.submit();" value="<cfoutput>#GetLangVal("mail_wd_discard")#</cfoutput>">
				  
			</td>
		</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal("cm_wd_from")#</cfoutput>
		</td>
		<td>
		
		<cfset url.mailFrom = ExtractEmailAdr(url.mailfrom) />
		
		<cfinvoke component="#request.a_str_component_email_accounts#" method="GetAliasAddresses" returnvariable="q_select_alias_addresses">
			<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
		</cfinvoke>	
		
		<cfset a_int_accounts_count = q_select_alias_addresses.recordcount + q_select_all_pop3_data.recordcount />
		
		<cfif a_int_accounts_count IS 1>
		
			<!--- get display name ... --->
			<cfset A_str_display_sender = q_select_all_pop3_data.displayname />
			
			<cfif Len(trim(A_str_display_sender)) GT 0>
				<!--- name <email> --->
				<cfset A_str_display_sender = """" & A_str_display_sender & """ <" & q_select_all_pop3_data.emailadr & ">" />
			<cfelse>
				<!--- email address only --->
				<cfset A_str_display_sender = q_select_all_pop3_data.emailadr />	
			</cfif>
			
			<input type="hidden" name="mailfrom" id="mailfrom" value="<cfoutput>#htmleditformat(A_str_display_sender)#</cfoutput>" />
			
			<cfoutput>#htmleditformat(A_str_display_sender)#</cfoutput>
			
		<cfelse>

			<!--- display name laden --->
			<select id="mailfrom" onChange="CheckCreateNewAccount();" style="width:100%;" name="mailFrom" required="Yes">
	
			<cfoutput query="q_select_all_pop3_data">
					
				<!--- get display name ... --->
				<cfset A_str_display_sender = q_select_all_pop3_data.displayname />
				
				<cfif Len(trim(A_str_display_sender)) GT 0>
					<!--- name <email> --->
					<cfset A_str_display_sender = """" & A_str_display_sender & """ <" & q_select_all_pop3_data.emailadr & ">" />
				<cfelse>
					<!--- email address only --->
					<cfset A_str_display_sender = q_select_all_pop3_data.emailadr />	
				</cfif>
				
			<option value="#htmleditformat(A_str_display_sender)#" #WriteSelectedElement(q_select_all_pop3_data.emailadr, url.mailFrom)#>#htmleditformat(A_str_display_sender)#</option>
			</cfoutput>
			
			<cfoutput query="q_select_alias_addresses">
				<option value="#htmleditformat(q_select_alias_addresses.aliasaddress)#" #WriteSelectedElement(q_select_alias_addresses.aliasaddress, url.mailFrom)#>#htmleditformat(q_select_alias_addresses.aliasaddress)#</option>
			</cfoutput>
	
			<!--- link to the assistant for a new e-mail address --->		
			<option class="addinfotext" value="gotocreatenewaccount"><cfoutput>#htmleditformat(GetLangVal("mail_ph_hint_newaccount"))#</cfoutput></option>
	
			</select>
		
		</cfif>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<a title="<cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput> ..." href="javascript:ShowOrHideAddressbook();" style="font-weight:bold; "><cfoutput>#si_img('vcard')#</cfoutput> <cfoutput>#GetLangVal('cm_wd_to')#</cfoutput></a>
		</td>
		<td>
			
			
			<cfif FindNoCase('ibworkgroup', a_str_tmp_to) IS 1>
				<!--- this is an email to a workgroup --->
				<cfset a_bol_mlist_msg = true>
				<cfset a_str_workgroupkey = Mid(a_str_tmp_to, len('ibworkgroup@')+1, len(url.to))>
				
				<input type="hidden" id="mailto" name="mailto" value="<cfoutput>#htmleditformat(a_str_tmp_to)#</cfoutput>">
				
				
				<!--- get the workgroup name --->
				<cfif a_str_workgroupkey IS 'all'>
					<a href="/workgroups/" target="_blank" style="font-weight:bold; ">
					<cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput>:
					<img src="/images/menu/img_members_19x15.gif" align="absmiddle" border="0" alt=""/>
					<cfoutput>#GetLangVal('cm_wd_all')#</cfoutput>
					</a>
				<cfelse>
					<a target="_blank" href="/workgroups/?action=showworkgroup&entrykey=<cfoutput>#a_str_workgroupkey#</cfoutput>"><b>
					<cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput>
					<cfset a_cmp_workgroups = CreateObject('component', request.a_str_component_workgroups)>
				
					<img src="/images/menu/img_members_19x15.gif" align="absmiddle" border="0" alt=""/> <cfoutput>#htmleditformat(a_cmp_workgroups.getworkgroupnamebyentrykey(a_str_workgroupkey))#</cfoutput>
					</b></a>
				</cfif>
				
			
			<cfelse>		
				<!--- ordenary recipients --->
				<cfset a_bol_mlist_msg = false>
				
				<div>
					<textarea tabindex="2" onBlur="HideLookup('to');" onFocus="SetCurrentInputField('to');" name="mailto" id="mailto" rows="1" cols="30" class="b_all" style="overflow-y:auto;width:100%;height:18px;"><cfoutput>#trim(htmleditformat(url.to))#</cfoutput></textarea>
				</div>
				<div id="iddivlookupto" class="div_email_ac_lookups bl bb br"></div>
				
				
			</cfif>

		</td>
	</tr>
	<!--- // the adress book block // --->
	<tr style="display:none;" id="idtraddressbook">
		<td class="field_name"></td>
		<td height="200" style="padding-top:0px;">
		
			<div style="text-align:right;height:18px;">
				<a href="javascript:ShowOrHideAddressbook();"><cfoutput>#GetLangVal('mail_ph_compose_hide_addressbook')#</cfoutput></a>
			</div>
			
			<div style="height:180px;padding:0px;" class="b_all">
				<iframe src="/content/dummy/dummy.html" name="idiframeadddressbook" id="idiframeadddressbook" width="100%" height="100%" frameborder="0"></iframe>
			</div>
		
		
		</td>
	</tr>
	<tr style="display:none;" id="idtrcc">
		<td class="field_name">
			<a title="<cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput> ..." href="javascript:ShowOrHideAddressbook();" style="font-weight:bold; ">CC</a>
			<!---<input onClick="ShowOrHideAddressbook();" type="button" name="frmadrb" value="<cfoutput>#GetLangVal('mail_wd_cc')#</cfoutput> ..." style="text-align:left;width:60px;padding-left:5px;font-weight:bold;">--->
		</td>
		<td>
			<cfif q_select_company_data.status IS 1>
				<input type="hidden" name="mailcc" id="mailcc">
				<cfoutput>#GetLangVal('cm_ph_feature_not_ava_in_trial_phase')#</cfoutput>
			<cfelse>
				<div>
					<textarea onBlur="HideLookup('cc');" onFocus="SetCurrentInputField('cc');" name="mailcc" id="mailcc" rows="1" cols="30" class="b_all" style="overflow-y:auto;width:100%;height:20px;"><cfoutput>#htmleditformat(trim(url.cc))#</cfoutput></textarea>
				</div>			
			</cfif>
			<div  id="iddivlookupcc" class="div_email_ac_lookups bl bb br"></div>
		</td>
	</tr>

	<tr style="display:none;" id="idtrbcc">
		<td class="field_name">
			<a title="<cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput> ..." href="javascript:ShowOrHideAddressbook();" style="font-weight:bold; ">BCC</a>		
		</td>
		<td>
			<cfif q_select_company_data.status IS 1>
				<input type="hidden" name="mailbcc" id="mailbcc">
				<cfoutput>#GetLangVal('cm_ph_feature_not_ava_in_trial_phase')#</cfoutput>
			<cfelse>		
				<div>
					<textarea onBlur="HideLookup('bcc');" onFocus="SetCurrentInputField('bcc');" name="mailbcc" id="mailbcc" rows="1" cols="30" class="b_all" style="overflow-y:auto;width:100%;height:20px;"><cfoutput>#htmleditformat(trim(url.bcc))#</cfoutput></textarea>
				</div>
			</cfif>
			
			<div id="iddivlookupbcc" class="div_email_ac_lookups bl bb br"></div>
		</td>
	</tr>	
	<tr style="display:none;" id="idtraddressbookend">
		<td colspan="2" class="bt" style="padding:0px;" height="1"><img src="../images/space_1_1.gif" height="1" width="1" alt=""/></td>
	</tr>
	
	<!--- // end of the address book block // --->
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal("cm_wd_subject")#</cfoutput>
		</td>
		<td>
			<input type="Text" tabindex="3" onKeyDown="SetWindowTitle(this.value);" onKeyUp="SetWindowTitle(this.value);" onKeyPress="SetWindowTitle(this.value);" style="width:100%;font-weight:bold;" name="mailSubject" id="mailSubject" value="<cfoutput>#htmleditformat(trim(url.subject))#</cfoutput>" required="No" size="30"  maxlength="250">
		</td>
	</tr>
	<!--- display attachments ... --->	
	
	<cfset a_int_attachments_count = 0 />
	
	<!--- new draft message or forwarding message --->
	<cfif (a_int_draft_id gt 0) AND (q_select_attachments.recordcount GT 0) OR
			((url.type IS 2) AND (StructKeyExists(variables, 'q_select_attachments') AND (q_select_attachments.recordcount GT 0)))>
			
		<cfset QueryAddColumn( q_select_attachments, 'content_id', 'Integer', ArrayNew(1) ) />
			
		<cfloop query="q_select_attachments">
			<cfset QuerySetCell( q_select_attachments, 'content_id', Int( Val( q_select_attachments.contentid )), q_select_attachments.currentrow ) />
		</cfloop>
				
		<cfquery name="q_select_read_attachments" dbtype="query">
		SELECT
			*
		FROM
			q_select_attachments
		WHERE
			(content_id >= 1)
			OR
			(Filenamelen > 0)
		;
		</cfquery>
		
		<!--- <cfmail from="hp@openTeamware.com" to="hp@openTeamware.com" subject="att check #request.stSecurityContext.myusername#" type="html">
		<cfdump var="#q_select_attachments#">
		<cfdump var="#q_select_read_attachments#">
		</cfmail> --->
	
	<cfif q_select_read_attachments.recordcount GT 0>
	
		<!--- get attachments localdata ... --->
		<!--- <cfquery name="q_select_attachment_localdata" datasource="#request.a_str_db_tools#">
		SELECT
			filepath
		FROM
			emailattachments
		WHERE
			username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
			AND
			uid = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_draft_id#">
		;
		</cfquery> --->
		
		<tr>
		<td class="field_name">
			<cfoutput>#si_img('attach')# #GetLangVal('cm_wd_files')#</cfoutput>
		</td>
		<td>

		<table class="table_simple">
		  
		  <!--- <cfoutput query="q_select_attachment_localdata">
		  <input type="hidden" name="frmfile#q_select_attachment_localdata.currentrow#" value="#htmleditformat(q_select_attachment_localdata.filepath)#" />
		  </cfoutput> --->
		  
		  <cfoutput query="q_select_read_attachments">
		  
		  <cfset a_int_attachments_count = a_int_attachments_count + 1 />
		  <tr>
			<td>
				#application.components.cmp_tools.GetImagePathForContentType(q_select_read_attachments.contenttype)#
				<a target="_blank" href="index.cfm?action=loadattachment&filename=#urlencodedformat(q_select_read_attachments.afilename)#&contenttype=#urlencodedformat(q_select_read_attachments.contenttype)#&mailbox=#urlencodedformat("INBOX.Drafts")#&id=#a_int_draft_id#&partid=#q_select_read_attachments.contentid#">#htmleditformat(q_select_read_attachments.afilename)#</a>
			</td>
			<td>
				#htmleditformat(q_select_read_attachments.contenttype)#
			</td>
			<td>
				#byteConvert(q_select_read_attachments.asize)#
			</td>
			<td>
				<cfif url.type NEQ 2>
					<a onClick="return CheckRemoveAttConfirmation();" href="javascript:RemoveAttachment('#q_select_read_attachments.contentid#');"><img src="/images/si/delete.png" class="si_img" /> #GetLangVal('mail_wd_compose_attachment_remove')#</a>
				</cfif>
			</td>
		  </tr>			
		</cfoutput>
		
		<!--- <cfif StructKeyExists(variables, "q_add_virtual_attachments") AND (variables.q_add_virtual_attachments.recordcount GT 0)>
			<tr>
				<td>
					#application.components.cmp_tools.GetImagePathForContentType(q_add_virtual_attachments.contenttype)#
					#htmleditformat(q_add_virtual_attachments.afilename)#
				</td>
				<td>
					#q_add_virtual_attachments.contenttype#
				</td>
				<td>
					#byteConvert(q_add_virtual_attachments.asize)#
				</td>
				<td></td>
			</tr>
		</cfif> --->
		
		</table>
		
		
			</td>
		</tr>
	
		</cfif>
	</cfif>
	<tr>
		<td class="field_name"></td>
		<td class="addinfotext" style="padding-top:6px; ">
			
			<!--- format changer ... --->
			
			<!--- TODO hp: translate ... --->
			<cfif url.format IS 'text'>
				<a href="#" onclick="SetMsgFormat('html');"><cfoutput>#GetLangVal('email_ph_use_html_format')#</cfoutput></a>
			<cfelse>
				<a href="#" onclick="SetMsgFormat('text');"><cfoutput>#GetLangVal('email_ph_use_text_format')#</cfoutput></a>
			</cfif>
			
			<input type="hidden" name="frmFormat" id="frmFormat" value="<cfoutput>#htmleditformat(url.format)#</cfoutput>" />
			
			<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
		
			<a href="javascript:Showccandbccfields();">Cc/Bcc</a>
			<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
		
			<a href="javascript:opentextblocks('<cfoutput>#jsstringformat(url.format)#</cfoutput>');"><cfoutput>#GetLangVal("mail_ph_textblockssig")#</cfoutput></a>
			<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
		
			<!--- <a style="border:0px;"  href="javascript:StartSpellCheck();"><cfoutput>#GetLangVal("mail_ph_spellchecker")#</cfoutput></a>
			<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput> --->
		
			<a href="#" onclick="ShowMailProperties();"><cfoutput>#GetLangVal('mail_ph_compose_further_properties')#</cfoutput></a>

			<!--- <cfoutput>#request.a_str_toolbar_sep_img#</cfoutput> --->
			<!---<cfoutput>#request.a_str_toolbar_sep_img#</cfoutput>
			 <a style="border:0px;"  href="javascript:OpenA1SigDialog();"><img border="0" src="/images/partner/img_logo_a1_signatur.png" width="71" height="17" align="absmiddle" alt="Diese Nachricht mit der A1 Signatur unterschreiben"/></a>
			<span style="background-color:#FF0000;color:white;font-size:10px;font-weight:bold;<cfif a_str_default_sm_action NEQ 'a1_sign'>display:none;</cfif>text-transform:uppercase;padding:2px;" id="id_span_a1_sig_enabled">Aktiv</span> --->
			 
			
		
		</td>
	</tr>
	</table>	
	</td>
</tr>
<tr class="mischeader">
	<td colspan="2">
	
		<div id="id_div_mail_properties" class="bt" style="display:none;padding:4px;">
		<table width="99%" border="0" cellspacing="0" cellpadding="4">
		  <tr>
		  	<td><cfoutput>#GetLangVal('cm_wd_priority')#</cfoutput>:</td>
			<td><cfoutput>#GetLangVal('mail_ph_compose_save_destination')#</cfoutput></td>
			
			<td valign="middle" rowspan="2">
				<input <cfoutput>#writecheckedelement(url.requestreadconfirmation, 1)#</cfoutput> class="noborder" type="Checkbox" name="frmRequestReadConfirmation" value="1">
			</td>
			<td valign="middle" rowspan="2">
				<cfoutput>#GetLangVal('mail_ph_compose_request_read_confirmation')#</cfoutput>
			</td>
			<td rowspan="2" valign="middle">
				<input type="checkbox" name="frmcbvcard" value="1" class="noborder" <cfoutput>#WriteCheckedElement(a_int_attach_vcard_enabled, 1)#</cfoutput>>
			</td>
			<td rowspan="2" valign="middle">
				 <a href="/settings/?action=addressbook" target="_blank"><cfoutput>#GetLangVal('mail_ph_compose_attach_vcard')#</cfoutput></a>
			</td>
		  </tr>
		  <tr>
			<td>
				<select name="frmpriority">
					<option value="1" <cfoutput>#WriteSelectedElement(url.priority,1)#</cfoutput>><cfoutput>#GetLangVal('mail_wd_priority_high')#</cfoutput>
					<option value="3" <cfoutput>#WriteSelectedElement(url.priority,3)#</cfoutput>><cfoutput>#GetLangVal('mail_wd_priority_normal')#</cfoutput>
					<option value="5" <cfoutput>#WriteSelectedElement(url.priority,5)#</cfoutput>><cfoutput>#GetLangVal('mail_wd_priority_low')#</cfoutput>
				</select>
			</td>
			<td>
			 <select name="frmsaveinfolder">
				<cfoutput query="request.q_select_folders">
				<option value="#htmleditformat(request.q_select_folders.fullfoldername)#" <cfif request.q_select_folders.FullFoldername is "INBOX.Sent">selected</cfif>>#request.q_select_folders.Foldername#
				</cfoutput>
				</select>
			</td>
		  </tr>
		</table>
		</div>
	
	
	</td>
</tr>
</table>

<div id="id_div_mailbody" class="mischeader <cfif url.format IS "html">bt</cfif>" style="overflow:auto;<cfif url.format IS "html">padding:0px;<cfelse>padding:8px;padding-top:0px;</cfif>">
	<cfif url.format is "html">
		
		<cfscript>
			fckEditor = application.components.cmp_fckeditor;
			fckEditor.instanceName	= "mailbody";
			fckEditor.value			= url.body;
			fckEditor.width			= "100%";
			fckEditor.height		= "100%";
			fckEditor.toolbarSet	= 'INBOX_Default';
			fckEditor.create(); // create the editor.
		</cfscript>
		
	<cfelse>
	
	<fieldset style="border:0;padding:0px" id="id_mailbody_fieldset">
		<label>
		<textarea tabindex="4" class="b_all" cols="73" rows="30" name="mailbody" id="mailbody" style="width:100%;"><cfoutput>#url.body#</cfoutput></textarea>
		</label>
	</fieldset>
	</cfif>
</div>
</form>

<!--- utils/show_iframe_load_contacts.cfm --->
<div style="display:none; ">
	<iframe src="/content/dummy/dummy.html" id="id_iframe_load_contacts" name="id_iframe_load_contacts" height="1" width="1"></iframe>
</div>

<div style="display:none;">
	<iframe src="/content/dummy/dummy.html" id="id_iframe_autosave_draft" name="id_iframe_autosave_draft" height="200" width="300"></iframe>
</div>

<!--- display status= --->
		
<cfsavecontent variable="a_str_js_auto_fill">
	var a_int_attachments_count = <cfoutput>#a_int_attachments_count#</cfoutput>;
</cfsavecontent>

<!--- show cc/bcc is neccessary --->
<cfsavecontent variable="a_str_js_show_fields">
	
	function CheckRemoveAttConfirmation() {
		return confirm('<cfoutput>#GetLangValJS('email_ph_really_delete_attachment')#</cfoutput>');
		}
			
	function ShowCCBCCFields() {
		<cfif len(url.bcc) GT 0>
			Showbccfield();
		</cfif>
	
		<cfif len(url.cc) GT 0>
			Showccfield();
		</cfif>
		}
</cfsavecontent>

</div>

<cfscript>
	// address book smartload
	AddJSToExecuteAfterPageLoad('window.setTimeout("SmartLoadContactDataFromAddressbook()", 500)', '');
	// call resize on init
	AddJSToExecuteAfterPageLoad('window.setTimeout("AOnCheckResize()", 500)', '');
	// load small address book
	AddJSToExecuteAfterPageLoad('window.setTimeout("CheckLoadAddressBookSearch()", 3000)', '');
	// auto-fill 
	AddJSToExecuteAfterPageLoad('window.setTimeout("AttachNeccessaryEvents()", 1000)', a_str_js_auto_fill);
	// show cc/bcc?
	AddJSToExecuteAfterPageLoad('window.setTimeout("ShowCCBCCFields()", 1000)', a_str_js_show_fields);
	
	// focus to body, to or subject
	// AddJSToExecuteAfterPageLoad('findObj(''mailbody'').focus();', '');
	if (Len(url.to) IS 0) {
		AddJSToExecuteAfterPageLoad('findObj(''mailto'').focus();', '');
		}
	
	if (Len(url.subject) IS 0)  {
		AddJSToExecuteAfterPageLoad('findObj(''mailSubject'').focus();', '');
		}
	
	AddJSToExecuteAfterPageLoad('', '$(window).resize( function() { AOnCheckResize(); } );');
</cfscript>

