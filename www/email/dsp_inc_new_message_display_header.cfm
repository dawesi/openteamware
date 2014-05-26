<!--- //

	Module:		EMail
	Action:		Showmessage
	Description:Display email headers ...
	
// --->

<cfprocessingdirective pageencoding="utf-8">

<cfinclude template="queries/q_select_all_pop3_data.cfm"><!--- 
<cfinclude template="utils/inc_check_addressbook_cache.cfm">
<cfset q_select_contacts = stReturn.q_select_contacts> --->

<!--- display a border on the left side? --->
<cfset a_bol_border_left = (url.openfullcontent IS 1) OR (url.openfullcontent IS 0 AND url.popup IS 1) />

<cfset a_bol_display_preview = (url.openfullcontent IS 0 AND url.popup IS 0) />

<cfset a_int_to_count = 0 />

<cfset a_str_sender_emailadr = ExtractEmailAdr(q_select_message.afrom) />

<!--- does the message contain a sender or recipient who is a CRM contact? ... --->
<cfset a_bol_msg_has_crm_contact = false />
<cfset a_str_primary_crm_contact_entrykey = '' />

<cfset a_str_own_email_adr = ValueList(q_select_all_pop3_data.emailadr) />
<cfset a_bol_from_is_own_adr = (ListFindNoCase(a_str_own_email_adr, a_str_sender_emailadr) GT 0) />
				
<!--- which one is the "other" address --->	
<cfif NOT a_bol_from_is_own_adr>
	<cfset a_str_save_value_move_adr = a_str_sender_emailadr />
<cfelse>
	<cfset a_str_save_value_move_adr = extractemailadr(q_select_message.ato) />
</cfif>


<cfset stCRMFilter = StructNew() />
<cfset a_struct_loadoptions = StructNew() />
<cfset a_struct_loadoptions.maxrows = 20 />
<cfset a_struct_loadoptions.fieldstoselect = 'entrykey,email_prim,email_adr,surname,firstname,company,photoavailable,b_telephone,department,aposition,b_city,b_zipcode,b_street' />

<cfset a_str_list_email_addresses = q_select_message.ato />
<cfset a_str_list_email_addresses = ListAppend(a_str_list_email_addresses, q_select_message.afrom) />
<cfset a_str_list_email_addresses = ListAppend(a_str_list_email_addresses, q_select_message.cc) />
<cfset a_str_list_email_addresses = ListAppend(a_str_list_email_addresses, q_select_message.bcc) />

<cfloop index="a_str_email_adr" list="#a_str_list_email_addresses#" delimiters=",;">
	
	<cfinvoke component="#application.components.cmp_crmsales#" method="AddTempCRMFilterStructureCriteria" returnvariable="stCRMFilter">
		<cfinvokeargument name="CRMFilterStructure" value="#stCRMFilter#">
		<cfinvokeargument name="operator" value="0">
		<cfinvokeargument name="internalfieldname" value="email_prim">
		<cfinvokeargument name="comparevalue" value="#ExtractEmailAdr(a_str_email_adr)#">
		<cfinvokeargument name="connector" value="1">
	</cfinvoke>
	
</cfloop>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="crmfilter" value="#stCRMFilter#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loaddistinctcategories" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />
		
<!--- preferred default folder saved? --->		
<cfset a_str_default_move_target_folder = GetUserPrefPerson('email', 'mbox.movedefaultfolder.#url.mailbox#.#a_str_save_value_move_adr#', '', '', false) />
	
<!--- first popup menu: various actions ... --->
<cfscript>
	StartNewJSPopupMenu('a_misc_actions_popup_menu');
	
	if (q_select_message.flagged is 1) {
		// TODO: Replace with a background call / ajax
		AddNewJSPopupMenuItem(GetLangValJS('mail_ph_msg_remove_flag'), 'act_label_msg.cfm?status=30&id=#q_select_message.id#&folder=#urlencodedformat(url.mailbox)#');
		} else {
			AddNewJSPopupMenuItem(GetLangValJS('mail_wd_msg_flag'), 'act_label_msg.cfm?status=3&id=#q_select_message.id#&folder=#urlencodedformat(url.mailbox)#');
			}
		
	AddNewJSPopupMenuItem(GetLangValJS('cm_ph_printversion'), 'show_print_version.cfm?id=#q_select_message.id#&folder=#urlencodedformat(url.mailbox)#');
	
	a_str_followup = '/tools/followups/show_popup_create.cfm?objectkey='&urlencodedformat(q_select_message.messageid)&'&servicekey='&request.sCurrentServiceKey&'&title='&urlencodedformat(q_select_message.subject);
	AddNewJSPopupMenuItem(GetLangValJS('crm_ph_create_a_new_follow_up'), 'javascript:OpenNewWindowWithParams(\''#jsstringformat(a_str_followup)#\'');');
	AddNewJSPopupMenuItem(GetLangValJS('mail_ph_export_as_eml'), 'show_get_raw_message.cfm?mailbox=#urlencodedformat(url.mailbox)#&id=#url.id#');
	AddNewJSPopupMenuItem(GetLangValJS('mail_ph_show_full_header'), 'javascript:ShowHeaders(\''#jsstringformat(url.mailbox)#\'', \''#url.id#\'', \''#GetLangValJS('mail_wd_msg_header')#\'');');
	
	if (a_bol_alternative_version_avaliable) {
		
		if (CompareNoCase(url.alternativeversion, "html") is 0) {
			AddNewJSPopupMenuItem(GetLangValJS('mail_ph_msg_show:') & ' ' & GetLangValJS('mail_ph_msg_show_text_version'), 'index.cfm?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "alternativeversion", "text")#');
			} else {
				AddNewJSPopupMenuItem(GetLangValJS('mail_ph_msg_show:') & ' ' & GetLangValJS('mail_ph_msg_show_html_version'), 'index.cfm?#ReplaceOrAddURLParameter(cgi.QUERY_STRING, "alternativeversion", "html")#');
				}
		}
	
	AddNewJSPopupMenuToPage();

	// second popup menu: move to folder ...
	StartNewJSPopupMenu('a_mv2folder_pop_men');
	
	if (Len(a_str_default_move_target_folder) GT 0) {
		AddNewJSPopupMenuItem(GetLangValJS('mail_ph_move_msg_to_folder') & ' ' & JsStringformat(ReplaceNoCase(a_str_default_move_target_folder, 'INBOX.', '', 'ONE')), 'javascript:MoveMessage(\''#JsStringFormat(a_str_default_move_target_folder)#\'');');
		AddNewJSPopupMenuItem('-', '');
		}		
		
	for (x = 1; x LTE request.q_select_folders.RecordCount; x=x+1) {
		a_int_padding_left = (val((request.q_select_folders.level) -1) * 10);
		AddNewJSPopupMenuItem(JSStringformat(ShortenString(request.q_select_folders.foldername[x], 25)), 'javascript:MoveMessage(\''#JsStringFormat(request.q_select_folders.fullfoldername[x])#\'');');
		}	
		
	AddNewJSPopupMenuToPage();
</cfscript>

<!--- third popup menu: popup menu for FROM ... --->
<cfquery name="q_select_sender_adrb_item" dbtype="query" maxrows="1">
SELECT
	*
FROM
	q_select_contacts
WHERE
	(email_prim IS NOT NULL)
	AND NOT
	(email_prim = '')
	AND
	(UPPER(email_prim) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_sender_emailadr)#">)
;
</cfquery>

<cfscript>
	StartNewJSPopupMenu('a_from_adr_popup_menu');	
	AddNewJSPopupMenuItem(GetLangValJS('mail_ph_compose_new_mail'), 'javascript:OpenComposePopupTo(\''#jsstringformat(a_str_sender_emailadr)#\'');');
	AddNewJSPopupMenuItem(GetLangValJS('mail_ph_further_messages'), 'javascript:DisplayOtherMsgUsingSearchWindow(\''\'', \''#jsstringformat(a_str_sender_emailadr)#\'', \''from\'');\'');');
	
	if (q_select_sender_adrb_item.recordcount is 0) {
		AddNewJSPopupMenuItem(GetLangValJS('mail_ph_msg_addressbook_new'), 'javascript:CallSimpleAddAddressbookDialog(\''#jsstringformat(a_str_sender_emailadr)#\'', \''#GetLangValJS('mail_ph_msg_addressbook_new')#\'');');
		//a_from_adr_popup_menu.AddItem(GetLangValJS('mail_ph_msg_addressbook_new'),'javascript:CallSimpleAddAddressbookDialog(\''#jsstringformat(q_select_message.afrom)#\'',\''#GetLangValJS('mail_ph_msg_addressbook_new')#\'');';
		} else {
			AddNewJSPopupMenuItem(GetLangValJS('mail_ph_show_in_addressbook'), 'javascript:GotoLocHrefMain(\''/addressbook/index.cfm?action=ShowItem&entrykey=#q_select_sender_adrb_item.entrykey#\'');');
			}
	AddNewJSPopupMenuItem(GetLangValJS('mail_wd_block'), 'javascript:BlockAddress(\''#jsstringformat(a_str_sender_emailadr)#\'', \''#GetLangValJS('mail_wd_block')#\'');');
	AddNewJSPopupMenuToPage();
	

</cfscript>

<!--- Get out the primary contact key, we're dealing with ... 	if it is the FROM tag, use this one ... --->
<cfif NOT a_bol_from_is_own_adr AND q_select_sender_adrb_item.recordcount IS 1>
	<cfset a_bol_msg_has_crm_contact = true />
	<cfset a_str_primary_crm_contact_entrykey = q_select_sender_adrb_item.entrykey />

</cfif>

<!--- check if a history item exists ... --->
<cfif a_bol_msg_has_crm_contact>
	<cfset a_bol_history_item_exists = application.components.cmp_crmsales.CheckIfHistoryItemsExistForLinkedObject(servicekey = '52227624-9DAA-05E9-0892A27198268072',
												objectkey = a_str_primary_crm_contact_entrykey,
												linked_servicekey = request.sCurrentServiceKey,
												linked_objectkey = a_str_message_id) />
<cfelse>
	<cfset a_bol_history_item_exists = false />												
</cfif>

<cfsavecontent variable="a_str_mail_header">
	
<div class="bb bt" style="width:97%">
	
	<cfoutput>		
	
	<table class="table_details">
	  <tr>
		<td class="field_name">
			<img src="/images/space_1_1.gif" class="si_img" />#GetLangVal('cm_wd_from')#
		</td>
		<td>
			<a id="id_a_from_link" href="##" onClick="ShowHTMLActionPopup('id_a_from_link', a_from_adr_popup_menu);return false;" style="font-weight:bold;">#htmleditformat(DisplayNiceEmailAddress(q_select_message.afrom))# (#ExtractEmailAdr(q_select_message.afrom)#) <img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" border="0"></a>
						
			<cfif (q_select_sender_adrb_item.recordcount IS 1) AND NOT a_bol_from_is_own_adr>
				#si_img('tick')#
				<cfsavecontent variable="a_str_info">
				<cfif Len(q_select_sender_adrb_item.company) GT 0>
					#htmleditformat(q_select_sender_adrb_item.company)#
				</cfif>
				
				<cfif Len(q_select_sender_adrb_item.department) GT 0>
					/ #htmleditformat(q_select_sender_adrb_item.department)#
				</cfif>
				
				<cfif Len(q_select_sender_adrb_item.aposition) GT 0>
					/ #htmleditformat(q_select_sender_adrb_item.aposition)#
				</cfif>
				
				<cfif Len(q_select_sender_adrb_item.b_zipcode) GT 0 OR Len(q_select_sender_adrb_item.b_city) GT 0>
					/ #htmleditformat(q_select_sender_adrb_item.b_zipcode)# #htmleditformat(q_select_sender_adrb_item.b_city)# #htmleditformat(q_select_sender_adrb_item.b_street)#
				</cfif>
				
				<!--- <cfif Len(q_select_sender_adrb_item.b_telephone) GT 0>
					/ T: #htmleditformat(q_select_sender_adrb_item.b_telephone)#
				</cfif> --->
				
			
				</cfsavecontent>
				
				<cfset a_str_info = trim(a_str_info) />
				
				<div style="padding-top:4px;">
				<a href="##" onclick="javascript:GotoLocHrefMain('/addressbook/index.cfm?action=ShowItem&entrykey=#q_select_sender_adrb_item.entrykey#')">#a_str_info#</a>
				</div>
			<cfelse>
				<img src="/images/space_1_1.gif" class="si_img" />
			</cfif>
			
		</td>
		<cfif val(q_select_sender_adrb_item.photoavailable) IS 1>
			<td rowspan="6"  class="bl mischeader" style="width100px;text-align:center;vertical-align:middle;">
				<img style="height:80px;padding:2px;" src="/addressbook/index.cfm?action=ShowContactPhoto&entrykey=#q_select_sender_adrb_item.entrykey#" />
			</td>
		</cfif>
	  </tr>
	  
	  <!--- <tr id="id_tr_addressbook_shortinfo" style="display:none; ">
	  	<td class="field_name"></td>
		<td id="id_td_addressbook_shortinfo"></td>
	  </tr> --->
	  
	  <cfset a_str_to = q_select_message.ato />
	  <!--- to --->
	  <cfif ListLen(a_str_to, ',') IS 1 AND FindNoCase(request.stSecurityContext.myusername, a_str_to) GT 0>
	  <!--- only to the user itself ... so there's no need to display the field --->
	  <cfelse>
	  <tr>
	  	<td class="field_name">
			#GetLangVal('mail_wd_to')#
		</td>
		<td>		
		<cfif ListLen(a_str_to) GT 5>
			<div style="padding:0px;overflow:auto;height:100px;">
		</cfif>		
			
			<cfloop index="a_str_to_item" list="#a_str_to#" delimiters=",;">
			
				<cfset a_int_to_count = a_int_to_count + 1 />				
				<cfset a_str_extracted_email_adr = ExtractEmailadr(a_str_to_item) />
				<cfset a_str_popup_menu_id = 'a_pop_' & CreateUUIDJS() />
				<cfset a_str_link_id = 'id_a_link_' & CreateUUIDJS() />

				<cfif Len(a_str_extracted_email_adr) GT 0>
	
					<cfquery name="q_select_adrb_item" dbtype="query" maxrows="1">
					SELECT
						entrykey
					FROM
						q_select_contacts
					WHERE
						(email_prim IS NOT NULL)
						AND NOT
						(email_prim = '')
						AND
						(UPPER(email_prim) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_extracted_email_adr)#">)
					;
					</cfquery>
					
					<cfif q_select_adrb_item.recordcount IS 1 AND NOT a_bol_msg_has_crm_contact>
						<cfset a_bol_msg_has_crm_contact = true />
						<cfset a_str_primary_crm_contact_entrykey = q_select_adrb_item.entrykey />
					</cfif>
	
					<a id="#a_str_link_id#" href="##" onClick="ShowHTMLActionPopup('#a_str_link_id#', #a_str_popup_menu_id#);return false;">#htmleditformat(DisplayNiceEmailAddress(a_str_to_item))# <img src="/images/arrows/img_arrow_sort_down.gif" align="absmiddle" border="0"></a>
					
					<cfscript>
					StartNewJSPopupMenu(a_str_popup_menu_id);	
					AddNewJSPopupMenuItem(GetLangValJS('mail_ph_compose_new_mail'), 'javascript:OpenComposePopupTo(\''#jsstringformat(a_str_extracted_email_adr)#\'');');
					AddNewJSPopupMenuItem(GetLangValJS('mail_ph_further_messages'), 'javascript:DisplayOtherMsgUsingSearchWindow(\''\'', \''#jsstringformat(a_str_extracted_email_adr)#\'', \''from\'');\'');');
					
					if (q_select_adrb_item.recordcount is 0) {
						AddNewJSPopupMenuItem(GetLangValJS('mail_ph_msg_addressbook_new'), 'javascript:CallSimpleAddAddressbookDialog(\''#jsstringformat(a_str_extracted_email_adr)#\'', \''#GetLangValJS('mail_ph_msg_addressbook_new')#\'');');
						} else {
							AddNewJSPopupMenuItem(GetLangValJS('mail_ph_show_in_addressbook'), 'javascript:GotoLocHrefMain(\''/addressbook/index.cfm?action=ShowItem&entrykey=#q_select_adrb_item.entrykey#\'');');
							}
					AddNewJSPopupMenuItem(GetLangValJS('mail_wd_block'), 'javascript:BlockAddress(\''#jsstringformat(a_str_extracted_email_adr)#\'', \''#GetLangValJS('mail_wd_block')#\'');');
					AddNewJSPopupMenuToPage();
					</cfscript>
								
				</cfif>
				
			<cfif Len(a_str_extracted_email_adr) gt 0 AND ListFind(a_str_to, a_str_to_item) LT ListLen(a_str_to, ',')>
				<br />
			</cfif>
			</cfloop>
			
		<cfif ListLen(a_str_to) GT 5>
			</div>
		</cfif>		
			
		</td>
	  </tr>
	  </cfif>
	  <cfif Len(q_select_message.cc) GT 0>
	  	<tr>
			<td class="field_name">
				#GetLangVal('mail_wd_cc')#
			</td>
			<td>
			
				<cfset a_str_cc = q_select_message.cc>
		
				<cfif ListLen(a_str_cc) GT 5>
					<div style="padding:0px;overflow:auto;height:100px;">
				</cfif>		
				
				<cfloop index="a_str_cc_item" list="#a_str_cc#" delimiters=",;">
				
						<cfset a_int_to_count = a_int_to_count + 1>
						
						<cfset a_str_extracted_email_adr = ExtractEmailadr(a_str_cc_item)> 
	
						<cfif Len(a_str_extracted_email_adr) gt 0>
			
							<cfquery name="q_select_adrb_item" dbtype="query">
							SELECT
								entrykey
							FROM
								q_select_contacts
							WHERE
								(email_prim IS NOT NULL)
								AND NOT
								(email_prim = '')
								AND
								(UPPER(email_prim) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(a_str_extracted_email_adr)#">)
							;
							</cfquery>
			
							
							<cfif q_select_adrb_item.recordcount is 0>
								<a title="#htmleditformat(a_str_cc_item)#" target="_blank" href="../addressbook/index.cfm?Action=createnewitem&email=#urlencodedformat(a_str_extracted_email_adr)#">#htmleditformat(DisplayNiceEmailAddress(a_str_cc_item))# (#GetLangVal('mail_ph_msg_addressbook_new')#)</a>
							<cfelse>
								<a title="#htmleditformat(a_str_cc_item)#" target="_blank" href="../addressbook/index.cfm?action=ShowItem&entrykey=#urlencodedformat(q_select_adrb_item.entrykey)#">#htmleditformat(DisplayNiceEmailAddress(a_str_cc_item))#</a>
							</cfif>
							
			
							
						</cfif>
					<cfif Len(a_str_extracted_email_adr) gt 0 AND ListFind(a_str_cc, a_str_cc_item) LT ListLen(a_str_cc, ',')>
						<br />
					</cfif>
				</cfloop>
				
			<cfif ListLen(a_str_cc) GT 5>
				</div>
			</cfif>					
			
			</td>
		</tr>
	  </cfif>
	  <tr>
	  	<td class="field_name">
			#GetLangVal('mail_wd_subject')#
		</td>
		<td style="font-weight:bold;">
			#htmleditformat(checkzerostring(q_select_message.subject))#
			<cfif q_select_message.flagged is 1>
				#si_img('flag_red')#
			</cfif>		
	  </tr>	 
	  <tr>
	  	<td class="field_name">
			#GetLangVal('mail_wd_date')#
		</td>
		<td>
			<cfset a_dt_local = ParseDateTime(q_select_message.date_local)>
			<!---<cfset a_dt_local = DateAdd('h', -request.stUserSettings.utcdiff-2, a_dt_local)>--->

			#lsdateformat(a_dt_local, "dddd, dd.mm.yyyy")# #Timeformat(a_dt_local, "HH:mm")#
		</td>
		</td>
	  </tr>
	  <cfif (CompareNoCase(url.mailbox, "inbox.drafts") NEQ 0) AND a_bol_msg_has_crm_contact AND a_bol_history_item_exists>
	  <tr>
		<td class="field_name">
			CRM
		</td>
		<td>
			<cfoutput>#GetLangVal('crm_ph_saved_in_history')#</cfoutput>
		</td>
	  </tr>
	  </cfif>
	 
	  <cfif q_select_real_attachments.recordcount GT 0>
			<tr>
				<td class="field_name">
					#GetLangVal('mail_wd_attachments')# (#q_select_real_attachments.recordcount#)
				</td>
				<td>					
					#htmleditformat(ValueList(q_select_real_attachments.afilename, ', '))#
				</td>
			</tr>
	  </cfif>
	  <cfif a_bol_is_spam>
			<tr>
				<td class="field_name">
					#GetLangVal('cm_wd_information')#
				</td>
				<td>
					<b>#GetLangVal('mail_ph_msg_identified_as_spam')#</b>
					<br /> 
					#GetLangVal('mail_ph_msg_spam_level')# (#a_int_spam_level#) <cfloop from="1" to="#a_int_spam_level#" index="ii">#si_img('bug')#</cfloop>
					
					<a href="##" onclick="$('##iddivspamreport').show();return false;">#GetLangVal('mail_ph_msg_spam_show_full_report')#</a>
					<br /> 
					<a href="../settings/act_add_to_sa_whitelist.cfm?emailaddress=<cfoutput>#UrlEncodedFormat(extractemailadr(a_str_sender_emailadr))#&redirect=#urlencodedformat(cgi.SCRIPT_NAME&'?'&cgi.QUERY_STRING&'&sawhitelistadded=1')#</cfoutput>">#si_img('cross')#<cfoutput>#GetLangVal('mail_ph_msg_spam_is_no_spam')#</cfoutput></a>
					
					<div style="display:none;padding-top:10px;" id="iddivspamreport">
						
						<b><cfoutput>#GetLangVal('mail_ph_msg_spam_full_report')#</cfoutput></b><br /> 
						<cfloop index="a_str_spam_report_line" list="#a_str_spam_report#" delimiters="*">
						<cfoutput>#htmleditformat(a_str_spam_report_line)#</cfoutput><br />
						</cfloop>
	
					</div>
					
					<cfif StructKeyExists(url, 'sawhitelistadded')>
						<div style="padding:6px;">
						<b>#si_img('information')# #GetLangVal('mail_ph_msg_spam_is_no_spam_whitelist_added')#</b>
						</div>
					</cfif>
				</td>
			</tr>
		</cfif>
	  <tr id="id_tr_qa_sent_successfully_information" style="display:none; ">
	  	<td></td>
		<td style="text-align:center;">
			<div style="padding:4px;text-align:center;padding-left:0px;">
			<span style="background-color:orange;font-weight:bold;color:white;padding:2px; ">
			#GetLangVal('mail_ph_msg_quickanswer_sent_confirmation')#
			</span>
			</div>
		</td>
	  </tr>
	</table>
	</cfoutput>
</div>	

</cfsavecontent>

<!--- build the string holding the buttons ... --->
<cfsavecontent variable="a_str_mail_header_buttons">
<div style="padding:6px;padding-top:3px;">
<form action="#" style="margin:0px;">
	
	<!--- is this message saved in the "drafts" folder? --->
	<cfif CompareNoCase(url.mailbox, "inbox.drafts") is 0>
	
		<input type="button" class="btn" onclick="OpenDraftMsg('<cfoutput>#url.id#</cfoutput>'); return false;" value="<cfoutput>#GetLangVal('mail_ph_msg_draft_continue')#</cfoutput>">
	
	<cfelse>
	
		<!--- no draft msg ... --->
		<input type="button" class="btn" onclick="OpenComposeWindow(1,<cfoutput>#url.id#</cfoutput>,'<cfoutput>#url.mailbox#</cfoutput>');" value="<cfoutput>#GetLangVal("mail_wd_reply")#</cfoutput>"/>
		<!--- <input type="button" class="btn2" onclick="ShowQA();" value="<cfoutput>#GetLangVal('mail_wd_quick_reply')#</cfoutput>"/> --->
		
		<cfif a_int_to_count GT 1>
			<input type="button" class="btn2" onclick="OpenComposeWindow(1,<cfoutput>#url.id#</cfoutput>,'<cfoutput>#url.mailbox#</cfoutput>', '', 1);" value="<cfoutput>#GetLangVal("mail_ph_reply_all")#</cfoutput>"/>
		</cfif>
		
		<input type="button" class="btn2" onclick="OpenComposeWindow(2,<cfoutput>#url.id#</cfoutput>,'<cfoutput>#url.mailbox#</cfoutput>');" value="<cfoutput>#GetLangVal("mail_wd_forward")#</cfoutput>"/>
		<input type="button" id="id_btn_link_mail_move" onclick="ShowHTMLActionPopup(this.id, a_mv2folder_pop_men);" class="btn2" value="<cfoutput>#GetLangVal('mail_wd_move_to_folder')#</cfoutput>"/>
	
		<!--- offer to add email to history ... --->
		<cfif a_bol_msg_has_crm_contact AND NOT a_bol_history_item_exists>
			<input type="button" class="btn2" onclick="AddMailToCRMHistory('<cfoutput>#url.mailbox#</cfoutput>', '<cfoutput>#url.id#</cfoutput>', '<cfoutput>#JsStringFormat(a_str_message_id)#</cfoutput>', '<cfoutput>#JsStringFormat(a_str_primary_crm_contact_entrykey)#</cfoutput>');" value="<cfoutput>#GetLangVal('crm_ph_add_to_crm_history')#</cfoutput>" />
		</cfif>
		
	</cfif>
	
	<input type="button" onclick="DeleteMessage(<cfoutput>#url.id#</cfoutput>,'<cfoutput>#jsstringformat(url.mailbox)#</cfoutput>','<cfoutput>#url.rowno#</cfoutput>', true, <cfoutput>#ReturnTrueFalseOnZeroOne(url.openfullcontent)#</cfoutput>, '<cfoutput>#JsStringFormat(url.mbox_query_md5)#</cfoutput>');" class="btn2" value="<cfoutput>#GetLangVal('mail_wd_delete')#</cfoutput>" />
	
	<input type="button" id="id_btn_link_open_mail_action_popup" onclick="ShowHTMLActionPopup(this.id, a_misc_actions_popup_menu);" class="btn2" value="<cfoutput>#GetLangVal('cm_wd_link_more')#</cfoutput>" />
	

</form>
</div>
</cfsavecontent>

<!--- output buttons plus header ... --->
<div style="padding:2px;">
<cfoutput>
#a_str_mail_header_buttons#
#a_str_mail_header#
</cfoutput>
</div>
	

<cfset variables.a_str_cgi_http_ref = Duplicate(ReturnRedirectURL()) />

<!--- // mail action list // --->

<cfparam name="url.popup" type="numeric" default="0">
<cfparam name="url.mbox_query_md5" type="string" default="">
<cfparam name="url.rowno" type="string" default="">

<cfif Compare(request.stSecurityContext.myuserkey, url.userkey) NEQ 0>
	<cfexit method="exittemplate">
</cfif>

<!--- popup or not? ---->
<cfif url.popup IS 1>
	<cfset a_str_redirect = 'show_close_window.cfm'>
<cfelse>
	<cfset a_str_redirect = 'index.cfm?action=showmessage'>
</cfif>

<!--- TODO: move code to email.js ... --->
<cfsavecontent variable="a_str_js">
		
	function MoveMessage(folder) {
		var obj1,obj2,obj3,mbox,id,rowno,targetmailbox;
		var req = new cSimpleAsyncXMLRequest();
		
		afrom = '<cfoutput>#JSStringFormat(ExtractEmailAdr(q_select_message.afrom))#</cfoutput>';
		ato = '<cfoutput>#JSStringFormat(ExtractEmailAdr(q_select_message.ato))#</cfoutput>';
		mbox = '<cfoutput>#jsstringformat(url.mailbox)#</cfoutput>';
		id = '<cfoutput>#jsstringformat(url.id)#</cfoutput>';		
		rowno = '<cfoutput>#url.rowno#</cfoutput>';
		
		MakeLineInvisible(rowno);
		a_mbox_items[rowno].deleted = true;
		ShowLoadingStatus();
		
		if (folder)
			{
			targetmailbox = folder;
			} else {
					targetmailbox = document.form_move.frmdestinationfolder1.value;
					}
					
		
		req.action = 'MoveMessage';
		req.AddParameter('uid', id);
		req.AddParameter('foldername', mbox);
		req.AddParameter('targetmailbox', targetmailbox);
		req.doCall();	
		
		
		
		$('#iddiv_status_delete_move').show();
		$('#id_span_status_move').show();
		
		// make line invisible
		<cfif url.openfullcontent IS 0>
		
		</cfif>
		
		LoadNextAvailableMessage( rowno );
		
		// goto move page ...		
		// location.href = 'index.cfm?Action=DoMoveMessage&targetmailbox='+escape(targetmailbox)+'&id='+id+'&mailbox='+escape(mbox)+'&mbox_md5=<cfoutput>#url.mbox_query_md5#</cfoutput>&redirect=nextmsg&openfullcontent=<cfoutput>#url.openfullcontent#</cfoutput>&afrom='+escape(afrom)+'&ato='+escape(ato);
		}
</cfsavecontent>

<cfscript>
	// add to html header
	AddJSToExecuteAfterPageLoad('', a_str_js);
</cfscript>


<div id="iddiv_status_delete_move" style="padding:10px;display:none;background-color:white;" align="center" class="bb">
	<div align="center" style="padding:20px;width:90%;color:black;font-weight:bold">
			
			<span id="id_span_status_delete" style="display:none;"><cfoutput>#GetLangVal('mail_ph_status_msg_being_deleted')#</cfoutput></span>
			<span id="id_span_status_move" style="display:none;"><cfoutput>#GetLangVal('mail_ph_status_msg_being_moved')#</cfoutput></span>			
			<br /><br />
			
			<cfoutput>#request.a_str_img_tag_status_loading#</cfoutput>
			
	</div>
</div>

<!--- display followup information ... --->
<cftry>
<cfinvoke component="#request.a_str_component_followups#" method="DisplayShortFollowupInfos" returnvariable="stReturn">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="objectkeys" value="#q_select_message.messageid#">				
</cfinvoke>

<cfif stReturn.result>
	<cfoutput>#stReturn.content#</cfoutput>
</cfif>
<cfcatch type="any">
</cfcatch>
</cftry>


<cfsavecontent variable="a_str_js">
	
function processReqReportAsSpamDialogChange() {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	
	// close old dialog and open new one
	CloseSimpleModalDialog();
	// HideStatusInformation();
		
	// show confirmation ...
	// a_simple_modal_dialog.type = 'information';
	// a_simple_modal_dialog.customcontent = '<cfoutput>#GetLangvalJS('email_ph_mail_has_been_reported_as_spam')#</cfoutput>';
	// a_simple_modal_dialog.ShowDialog();
	
	DeleteMessage(<cfoutput>#url.id#</cfoutput>,'<cfoutput>#jsstringformat(url.mailbox)#</cfoutput>','<cfoutput>#url.rowno#</cfoutput>', '');
	}
	
	
function processReqSimpleAddAddressbookChange() {
	var a_simple_modal_dialog = new cSimpleModalDialog();
	
	// close old dialog and open new one
	CloseSimpleModalDialog();
	HideStatusInformation();
		
	a_simple_modal_dialog.type = 'information';
	a_simple_modal_dialog.customcontent = '<cfoutput>#GetLangvalJS('adrb_ph_contact_data_saved')#</cfoutput>';
	a_simple_modal_dialog.ShowDialog();
	}
	
function DisplayReferencesMessages(userkey,messageid,references,uid) {
	/*var a_simple_get = new cBasicBgOperation();
	a_simple_get.url = '/email/utils/show_js_display_message_references.cfm?userkey='+escape(userkey)+'&messageid='+escape(messageid)+'&references='+escape(references)+'&uid='+escape(uid);
	a_simple_get.callback_function = processReqMessageReferencesChange;
	a_simple_get.doOperation();*/
	}

function processReqMessageReferencesChange(responseText) {
	//$('id_div_references').html(responseText).show();
	}
</cfsavecontent>

<!--- add js ... and calc references in case mailspeed is enabled ... --->
<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />

<cfif request.appsettings.properties.mailspeedenabled IS 1>
	<cfset tmp = AddJSToExecuteAfterPageLoad('DisplayReferencesMessages(''#jsstringformat(url.userkey)#'',''#jsstringformat(a_str_message_id)#'',''#jsstringformat(a_str_references)#'',''#jsstringformat(url.id)#'');', '') />
</cfif>

