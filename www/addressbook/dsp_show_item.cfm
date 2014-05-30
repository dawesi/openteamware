<!--- //

	Module:		Address Book
	Description:ShowItem (contact, account, lead, ...)
	

	
	
	Do the following things:
	
		- Load data and preferences
		- Build menus and so on
		- Display contact information
		- Own datafields
		- CRM data
			tasks, appointments and so on
		
		- Additional informations
	
// --->

<cfprocessingdirective pageencoding="utf-8">

<!--- entrykey of object ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_object">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="loadmetainformations" value="true">
</cfinvoke>

<cfif NOT a_struct_object.result>
	<cfswitch expression="#a_struct_object.error#">
		<cfcase value="10100">
			<b><cfoutput>#GetLangVal('cm_ph_object_not_found')#</cfoutput></b>
		</cfcase>
		<cfdefaultcase>
		
		</cfdefaultcase>
	</cfswitch>
	
	<cfexit method="exittemplate">
</cfif>

<!--- get data from return struct ... --->
<cfset q_select_contact_data = a_struct_object.q_select_contact />
<cfset q_select_sub_items = a_struct_object.q_select_sub_items />
<cfset q_select_assigned_employees = a_struct_object.q_select_assigned_contacts />
<cfset q_select_workgroup_shares = a_struct_object.q_select_workgroup_shares />

<!--- load data of user ... --->
<cfset q_select_user_data = application.components.cmp_user.GetUserData( request.stSecurityContext.myuserkey ) />

<!--- // Load preferences // --->
<cfset a_int_crm_enabled = true />
<cfset a_int_skype_enabled = GetUserPrefPerson('extensions.skype', 'enabled', '1', '', false) />
<cfset a_str_contact_own_comment = GetUserPrefPerson('crm.contact.owncomment', url.entrykey, '', '', false) />

<!--- update list of lately shown contacts / accounts / leads (save individually) ... --->
<cfset sEntrykeys_lastshown_contacts = GetUserPrefPerson('addressbook', 'lastshown.entrykeys' & q_select_contact_data.contacttype, '', '', false) />
<cfset ii_find = ListFindNoCase(sEntrykeys_lastshown_contacts, url.entrykey) />

<cfif ii_find GT 0>
	<cfset sEntrykeys_lastshown_contacts = ListDeleteAt(sEntrykeys_lastshown_contacts, ii_find) />
</cfif>

<!--- update list of lately shown items now ... --->
<cfset sEntrykeys_lastshown_contacts = ListPrepend(sEntrykeys_lastshown_contacts, url.entrykey) />

<cfmodule template="../common/person/saveuserpref.cfm"
	entrysection = "addressbook"
	entryname = "lastshown.entrykeys#q_select_contact_data.contacttype#"
	entryvalue1 = #sEntrykeys_lastshown_contacts#>

<!--- contact or account ?? --->
<cfswitch expression="#q_select_contact_data.contacttype#">
	<cfcase value="1">
		<cfset a_str_display_header = GetLangVal('cm_wd_account') & ': ' & q_select_contact_data.company & ' (' & q_select_contact_data.b_city & ')' />
	</cfcase>
	<cfcase value="2">
		<cfset a_str_display_header = GetLangVal('cm_wd_lead') & ': ' & q_select_contact_data.surname />
	</cfcase>
	<cfdefaultcase>
		<cfset a_str_display_header = a_struct_object.q_select_contact.surname & ', '&a_struct_object.q_select_contact.firstname />
	
		<cfif Len(a_struct_object.q_select_contact.company) GT 0>
			<cfset a_str_display_header = a_str_display_header & ' @ ' & a_struct_object.q_select_contact.company />
		</cfif>
		
		<cfif Len(a_struct_object.q_select_contact.b_city) GT 0>
			<cfset a_str_display_header = a_str_display_header & ' (' & a_struct_object.q_select_contact.b_city & ')' />
		</cfif>
	</cfdefaultcase>
</cfswitch>

<cfset request.a_str_current_page_title = a_str_display_header />

<cfset tmp = SetHeaderTopInfoString(a_str_display_header) />

<cfsavecontent variable="a_str_js">
function NewElementClickEv(item_type) {
	call_new_item_for_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', item_type);
	}	
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />

<cfscript>
	StartNewJSPopupMenu('a_pop_crm_new_activity');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_email'), 'javascript:NewElementClickEv(\''email\'');');
	AddNewJSPopupMenuItem(GetLangValJS('crm_wd_follow_up'), 'javascript:NewElementClickEv(\''followup\'');');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_appointment'), 'javascript:NewElementClickEv(\''appointment\'');');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_task'), 'javascript:NewElementClickEv(\''task\'');');	
	AddNewJSPopupMenuItem(GetLangValJS('crm_ph_sales_project'), 'javascript:NewElementClickEv(\''project\'');');
	AddNewJSPopupMenuItem('-', '');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_crm_event') & ' (' & GetLangValJS('crm_wd_history') & ')', 'javascript:NewElementClickEv(\''history\'');');
	AddNewJSPopupMenuItem('-', '');
	AddNewJSPopupMenuItem(GetLangValJS('crm_ph_assign_product'), 'javascript:NewElementClickEv(\''product\'');');
	AddNewJSPopupMenuItem(GetLangValJS('crm_wd_contact_link'), 'javascript:NewElementClickEv(\''contact_link\'');');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_file'), 'javascript:NewElementClickEv(\''file\'');');
	//AddNewJSPopupMenuItem('-', '');
	// TODO: add actions
	//AddNewJSPopupMenuItem(GetLangValJS('cm_wd_sms'), 'javascript:NewElementClickEv(\''sms\'');');
	AddNewJSPopupMenuToPage();
</cfscript>

<cfoutput>
<div style="padding:6px;">
	<input type="button" class="btn" onclick="ShowHTMLActionPopup('id_btn_new_activity', a_pop_crm_new_activity);return false;" value="<cfoutput>#GetLangVal('crm_ph_set_new_activity_collect_data')#</cfoutput>" id="id_btn_new_activity" />
	
	<!--- <cfif q_select_contact_data.contacttype NEQ 1 AND val(q_select_contact_data.id_re_job_available) IS 0>
		<input onClick="CallRemoteEditDialog('#JSStringformat(url.entrykey)#');" type="button" value=" #htmleditformat(GetLangVal('adrb_ph_enable_remoteedit'))# " class="btn">
	</cfif> --->
	
	<input type="button" value="#GetLangVal('cm_ph_more_actions')# ..." id="id_btn_contacts_further_actions" class="btn" onClick="ShowHTMLActionPopup('id_btn_contacts_further_actions', a_pop_further_actions);return false;">
		
	<input type="button" class="btn" onclick="location.reload();return false;" value="<cfoutput>#GetLangVal('adrb_wd_reload')#</cfoutput>" />

	<input type="button" class="btn" onclick="ShowSimpleConfirmationDialog('index.cfm?action=deletecontacts&entrykeys=#url.entrykey#&confirmed=true&redirect_start_contacts=true');return false;" value="#MakeFirstCharUCase(GetLangVal('cm_wd_delete'))#" />
</div>
</cfoutput>

<!--- info block ... --->
<div style="padding:6px;" id="id_crm_info_block_top"></div>

<cfset tmp = ExportTranslationValuesAsJS('adrb_wd_activities') />

<cfset a_bol_skype_enabled = (a_int_skype_enabled IS 1) />	

<!--- display private data? --->	
<cfset a_bol_display_private_data = NOT (q_select_contact_data.contacttype IS 1) />

<!--- hide for contacts without private data as well ... --->
<cfif (q_select_contact_data.contacttype IS 0) AND (q_select_contact_data.length_private_data IS 0)>
	<cfset a_bol_display_private_data = false />
</cfif>


<!--- check for open remote edit operations ... --->
<cfset a_bol_re_available =  StructKeyExists(a_struct_object.rights, 'edit') AND
		a_struct_object.rights.edit AND
		(Len(q_select_contact_data.is_re_data_available) GT 0) />
	
<cfif a_bol_re_available>
		<cfoutput>
		<table class="table_simple mischeader" cellpadding="8">
		  <tr>
			<td>
				#si_img('exclamation')#
			</td>
			<td class="bl mischeader" style="padding:12px;">
			<b>#GetLangVal('adrb_ph_remoteedit_contact_has_updated_data1')#</b>
			<br />
			#GetLangVal('adrb_ph_remoteedit_contact_has_updated_data2')#
			<br /><br />
			<a href="?action=edititem&entrykey=#urlencodedformat(url.entrykey)#">#si_img('pencil')#<b>Jetzt in den Editiert-Modus wechseln ...</b></a>
			</td>
		  </tr>
		</table>
		</cfoutput>
</cfif>


<!--- <cfset variables.a_cmp_route_planner = CreateObject('component', '/components/tools/cmp_route_planner')>
 --->
<!--- TODO: Remove this ugly code ... --->


<!--- add action popop menu javascript to header --->
<!--- TODO translate --->

<cfswitch expression="#q_select_contact_data.contacttype#">
	<cfcase value="1">
		<!--- account ... --->
		<cfscript>
		StartNewJSPopupMenu('a_pop_further_actions');
		AddNewJSPopupMenuItem(MakeFirstCharUCase(GetLangValJS('adrb_ph_actions_forward')), 'index.cfm?action=forward&entrykeys=#urlencodedformat(url.entrykey)#');
		AddNewJSPopupMenuToPage();
		</cfscript>
	</cfcase>
	<cfdefaultcase>
		<!--- any other datatype ... --->
		<cfscript>
		StartNewJSPopupMenu('a_pop_further_actions');
		
		AddNewJSPopupMenuItem(MakeFirstCharUCase(GetLangValJS('adm_ph_set_photo')), 'javascript:SetPhotoForContact(\''#url.entrykey#\'');');
		
			if (q_select_contact_data.contacttype IS 0 AND q_select_contact_data.parentcontactkey IS '') {
				AddNewJSPopupMenuItem(GetLangValJS('crm_ph_create_account_for_this_contact'), 'javascript:DoCreateAutoAccountForContactDlg(\''#url.entrykey#\'');');
				}
			
			AddNewJSPopupMenuItem(GetLangValJS('crm_ph_duplicate_contact'), 'javascript:DuplicateContact(\''#url.entrykey#\'', #q_select_contact_data.contacttype#);');	
		
		AddNewJSPopupMenuItem(MakeFirstCharUCase(GetLangValJS('adrb_ph_actions_forward')), 'index.cfm?action=forward&entrykeys=#urlencodedformat(url.entrykey)#');
		AddNewJSPopupMenuItem('-', '');
		AddNewJSPopupMenuItem(GetLangValJS('crm_ph_update_last_contact'), 'javascript:DoUpdateLastContactOfContact(\''#url.entrykey#\'');');
	
		AddNewJSPopupMenuToPage();
		</cfscript>
	</cfdefaultcase>>
</cfswitch>

	
<cfoutput query="q_select_contact_data">
	
	<!--- buttons --->		
	<cfsavecontent variable="a_str_buttons">
		<cfif a_struct_object.rights.edit>
		<input onClick="call_edit_contact('#jsstringformat(url.entrykey)#', 'contactdata');" type="button" value=" #htmleditformat(MakeFirstCharUCase(GetLangVal('cm_wd_edit')))# " class="btn btn-primary">
		</cfif>
		
		<!--- <cfif q_select_contact_data.contacttype NEQ 1 AND val(q_select_contact_data.id_re_job_available) IS 0>
			&nbsp;
			<input onClick="CallRemoteEditDialog('#JSStringformat(url.entrykey)#');" type="button" value=" #htmleditformat(GetLangVal('adrb_ph_enable_remoteedit'))# " class="btn">
		</cfif>
		&nbsp;
		<input type="button" value="#GetLangVal('cm_ph_more_actions')# ..." id="id_btn_contacts_further_actions" class="btn" onClick="ShowHTMLActionPopup('id_btn_contacts_further_actions', a_pop_further_actions);return false;">
		 --->
		
	</cfsavecontent>	
		
	
	<!--- Create tab selection if private data available ... --->
	<cfif a_bol_display_private_data>
		
		<cfset tmp = StartNewTabNavigation() />
		<cfset a_str_id_business_data_box = AddTabNavigationItem(GetLangVal('adrb_wd_business'), '', '') />
		<cfset a_str_id_private_data_box = AddTabNavigationItem(GetLangVal('adrb_ph_private_data'), '', '') /> 
	
		<cfsavecontent variable="a_str_business_data">
			<cfoutput>#BuildTabNavigation('', false)#</cfoutput>
		</cfsavecontent>
		
	</cfif>


<!--- business data --->
<cfsavecontent variable="a_str_business_contact_data">
	
	<!--- build box around ... --->	
	<cfif a_bol_display_private_data>
		<div class="div_module_tabs_content_box" style="width:99%;" id="<cfoutput>#a_str_id_business_data_box#</cfoutput>">
	</cfif>
	
	<table class="table_details">
			
		<cfif (val(q_select_contact_data.id_re_job_available) GT 0) AND NOT a_bol_re_available>
			<tr>
				<td class="field_name">
					<img src="/images/si/information.png" class="si_img" /> #GetLangVal('adrb_ph_remoteedit')#
				</td>
				<td colspan="3">
					#GetLangVal('adrb_ph_remoteedit_contact_not_reacted_yet')#<img alt="" src="/images/space_1_1.gif" class="si_img" />
				</td>
			</tr>
		</cfif>
		  <cfif q_select_contact_data.contacttype NEQ 1>
		  <tr>
			 <cfif q_select_contact_data.photoavailable IS 1>
				<td rowspan="99" align="center" class="br" style="width:160px;">
					<img src="index.cfm?action=ShowContactPhoto&entrykey=#url.entrykey#" style="padding:6px;width:140px;" class="" />
				</td>
			</cfif>
			<td class="td_title field_name">
				#GetLangVal('cm_wd_name')#
			</td>
			<td style="font-weight:bold;">
				
				<cfswitch expression="#q_select_contact_data.sex#">
					<cfcase value="0">#GetLangVal('cm_wd_male')#</cfcase>
					<cfcase value="1">#GetLangVal('cm_wd_female')#</cfcase>
				</cfswitch>
				
				#htmleditformat(q_select_contact_data.title)# #htmleditformat(q_select_contact_data.firstname)# #htmleditformat(q_select_contact_data.surname)#
			</td>
			<td class="td_title field_name">
				#GetLangVal('adrb_ph_last_contact')#
			</td>
			<td>
				<cfif isDate(q_select_contact_data.dt_lastcontact)>
					#LsDateFormat(q_select_contact_data.dt_lastcontact, request.stUserSettings.default_Dateformat)#
				</cfif>
			</td>
		  </tr>
		  </cfif>
		  	 <tr>
				<td class="field_name">
					#GetLangVal('adrb_wd_organisation')#
				</td>
				<td>
					<cfif Len(q_select_contact_data.parentcontactkey) GT 0>
						<a href="index.cfm?action=ShowItem&entrykey=#q_select_contact_data.parentcontactkey#">#htmleditformat(CheckZeroString(q_select_contact_data.company))#</a><!---  <img src="/images/si/brick.png" class="si_img" /> --->
					<cfelse>
						#htmleditformat(q_select_contact_data.company)#
					</cfif>
					
					<cfif Len(q_select_contact_data.b_city) GT 0>
						(#htmleditformat(q_select_contact_data.b_city)#)
					</cfif>
				</td>
				<td class="field_name">
					#GetLangVal('cm_wd_language')#
				</td>
				<td>
					#htmleditformat(q_select_contact_data.lang)#
				</td>
			</tr>
			  <tr>
				<td class="field_name">
					#GetLangVal('adrb_wd_department')#<cfif q_select_contact_data.contacttype NEQ 1>/#GetLangVal('adrb_wd_position')#</cfif>
				</td>
				<td>
					#htmleditformat(q_select_contact_data.department)#

					<cfif Len(q_select_contact_data.aposition) GT 0>
						<cfif Len(q_select_contact_data.department) GT 0>/</cfif>
						#htmleditformat(q_select_contact_data.aposition)#
					</cfif>
				</td>
				
				<!--- display superior contact or number of employees ... --->
				<cfif q_select_contact_data.contacttype NEQ 1>
					<td class="field_name">
						#GetLangVal('adrb_wd_superior')#
					</td>
					<td>
						<a href="index.cfm?action=ShowItem&entrykey=#q_select_contact_data.superiorcontactkey#">#htmleditformat(q_select_contact_data.superiorcontactkey_displayvalue)#</a>
					</td>
				<cfelse>
					<td class="field_name">
						#GetLangVal('crm_wd_employees')#
					</td>
					<td>
						#q_select_contact_data.employees#
					</td>
				</cfif>
			</tr>
			<tr>
				<td class="field_name">
					#GetLangVal('adrb_wd_categories')#
				</td>
				<td>
					<cfloop list="#q_select_contact_data.categories#" delimiters=";," index="a_str_category">
						<a href="##">#htmleditformat(trim(a_str_category))#</a><cfif a_str_category IS NOT ListLast(q_select_contact_data.categories)>, </cfif>
					</cfloop>
				</td>
				<td class="field_name">
					#GetLangVal('cm_wd_industry')#
				</td>
				<td>
					<cfif Len(q_select_contact_data.nace_code) GT 0>
						<a href="##">#htmleditformat(application.components.cmp_Addressbook.ReturnIndustryNameByNACECode(nace_code = q_select_contact_data.nace_code, language = request.stUserSettings.language))#</a>
					</cfif>
				</td>
			  </tr>
		  <tr>
			<td class="field_name">
				#GetLangVal('cm_wd_email')#
			</td>
			<td>
				<a href="##" onclick="OpenEmailPopup('#jsstringformat(q_select_contact_data.entrykey)#', '#jsstringformat(q_select_contact_data.email_prim)#');return false;">#htmleditformat(q_select_contact_data.email_prim)#</a>
			
				<cfloop list="#q_select_contact_data.email_adr#" delimiters="#chr(13)#" index="a_str_email_address">
					, <a href="##" onclick="OpenEmailPopup('#jsstringformat(q_select_contact_data.entrykey)#', '#jsstringformat(a_str_email_address)#');">#htmleditformat(a_str_email_address)#</a>
				</cfloop>
			</td>
			<td class="field_name">
				<cfif q_select_contact_data.contacttype NEQ 1>
				#GetLangVal('adrb_wd_day_of_birth')#
				</cfif>
			</td>
			<td>
				<cfif isDate(q_select_contact_data.birthday)>
				#DateFormat(q_select_contact_data.birthday, 'dd.mm.yyyy')#
				</cfif>
			</td>
		  </tr>
	  
		<!--- 
		  <tr>
			<td class="td_title field_name"></td>
			<td>
			
			</td>
			<td class="td_title field_name">
			
			</td>
			<td>
		
			</td>
		  </tr> --->
	  

	  <cfif ListLen(q_select_contact_data.criteria) GT 0>
	  	<tr>
			<td class="field_name">
				#GetLangVal('crm_wd_criteria')#
			</td>
			<td>
				<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCriteriaTree" returnvariable="sReturn_criteria_tree">
					<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
					<cfinvokeargument name="selected_ids" value="#q_select_contact_data.criteria#">
					<cfinvokeargument name="options" value="display_selected">
				</cfinvoke>
				
				#sReturn_criteria_tree#
			</td>
			<td class="field_name">
			</td>
			<td>
			<!--- 	Vollständige Adress- und Kontaktdaten anzeigen ... --->
			</td>
		</tr>			  
	  </cfif>
	  	  
			  <tr style="">
				<td class="field_name">
					#GetLangVal('adrb_wd_telephone')#
				</td>
				<td>
					<cfif Len(q_select_contact_data.b_telephone) GT 0>
						<a href="javascript:OpenCallPopup('#q_select_contact_data.entrykey#', '#jsstringformat(q_select_contact_data.b_telephone)#');">#htmleditformat(q_select_contact_data.b_telephone)#</a>
					</cfif>
					
					<cfif Len(q_select_contact_data.b_telephone_2) GT 0>
						, <a href="javascript:OpenCallPopup('#q_select_contact_data.entrykey#', '#jsstringformat(q_select_contact_data.b_telephone_2)#');">#htmleditformat(q_select_contact_data.b_telephone_2)#</a>
					</cfif>
				</td>
				<td class="field_name">
					<cfif (Len(q_select_contact_data.skypeusername) GT 0)>
					Skype
					</cfif>
				</td>
				<td>
					#htmleditformat(q_select_contact_data.skypeusername)#
					<cfif (Len(q_select_contact_data.skypeusername) GT 0)>
						<cfset tmp = AddJSToExecuteAfterPageLoad('ShowSkypeOnlineStatusData(''#jsstringformat(q_select_contact_data.skypeusername)#'', ''#jsstringformat(url.entrykey)#'')', '') />
					</cfif>
				</td>
			  </tr>
		  
		  
		  <cfif Len(q_select_contact_data.b_fax) GT 0 OR Len(q_select_contact_data.b_mobile) GT 0>
			  <tr style="">
				<td class="field_name">
					#GetLangVal('adrb_wd_fax')#
				</td>
				<td>				
					<a href="/fax/index.cfm?action=composefax&faxto=#urlencodedformat(q_select_contact_data.b_fax)#">#htmleditformat(q_select_contact_data.b_fax)#</a>
				</td>
				<td class="field_name">
					#GetLangVal('cm_wd_mobile')#
				</td>
				<td>
					<a href="javascript:OpenCallPopup('#q_select_contact_data.entrykey#', '#jsstringformat(q_select_contact_data.b_mobile)#', 'mobile');">#htmleditformat(q_select_contact_data.b_mobile)#</a>
				</td>
			  </tr>
		  </cfif>
		  
		   <tr style="">							
				<td class="field_name">
					#GetLangVal('adrb_wd_postal_address')#
				</td>
				<td>
					<!--- call JS fn function OpenAddressOptions(contactkey,adr_type,street,zipcode,city,country) --->
					<a title="Display route, information and more" href="javascript:OpenAddressOptions('#jsstringformat(q_select_contact_data.entrykey)#', 'business', '#JsStringformat(q_select_contact_data.b_street)#', '#JsStringformat(q_select_contact_data.b_zipcode)#', '#JsStringformat(q_select_contact_data.b_city)#', '#JsStringformat(q_select_contact_data.b_country)#');">
					#htmleditformat(q_select_contact_data.b_street)#
					
					<cfif Len(q_select_contact_data.b_zipcode) GT 0 OR Len(q_select_contact_data.b_city) GT 0>
						<cfif Len(q_select_contact_data.b_street) GT 0><br /></cfif>
						#htmleditformat(q_select_contact_data.b_zipcode)# #htmleditformat(q_select_contact_data.b_city)#
					</cfif>
					
					<cfif Len(q_select_contact_data.b_country) GT 0>
						/
						#htmleditformat(q_select_contact_data.b_country)#
					</cfif>
					
					</a>
				
				</td>
				<td class="field_name">
					
				</td>
				<td>
					
				</td>					
			  </tr>		  
	  
	  
	  		<!--- <cfif Len(q_select_contact_data.b_url) GT 0>
						#GetLangVal('cm_wd_url')#
					</cfif>
					<cfif Len(q_select_contact_data.b_url) GT 0>
						<cfif FindNoCase('http', q_select_contact_data.b_url) IS 1>
							<cfset a_str_link_href = q_select_contact_data.b_url>
						<cfelse>
							<cfset a_str_link_href = 'http://'&q_select_contact_data.b_url>				
						</cfif>
						<a href="#a_str_link_href#" target="_blank">#q_select_contact_data.b_url#</a>
					</cfif> --->
	  
	  	
	  	<cfif q_select_assigned_employees.recordcount GT 0 OR q_select_workgroup_shares.recordcount GT 0>
	  	<tr>
			<td class="field_name">
				#GetLangVal('cm_wd_workgroups')#
			</td>	
			<td>
				<cfloop query="q_select_workgroup_shares">
					<a href="##">#application.components.cmp_workgroups.ReturnWorkgroupNameByKeyUsingSecurityContext(securitycontext = request.stSecurityContext, workgroupkey = q_select_workgroup_shares.workgroupkey)#</a>
				</cfloop>
			</td>
			<td class="field_name">
				#GetLangVal('crm_wd_custodian')#
			</td>
			<td>
				<!--- TODO: link should direct somewhere ... --->
				<cfloop query="q_select_assigned_employees">
					<a href="/workgroups/?action=ShowUser&entrykey=#q_select_assigned_employees.userkey#">#htmleditformat(q_select_assigned_employees.displayname)#</a>
					<!--- <cfif Len(q_select_assigned_employees.comment) GT 0>
						(#htmleditformat(q_select_assigned_employees.comment)#)
					</cfif> --->
					<cfif q_select_assigned_employees.currentrow NEQ q_select_assigned_employees.recordcount>,</cfif>
				</cfloop>
			</td>
		</tr>
		</cfif>
		
		<cfif Len( q_select_contact_data.ownfield1 ) GT 0 OR Len( q_select_contact_data.ownfield2 ) GT 0>
			<tr>
				<td class="field_name">
					Own Field ##1
				</td>
				<td>
					#htmleditformat( q_select_contact_data.ownfield1 )#
				</td>
					<td class="field_name">
					Own Field ##2
				</td>
				<td>
					#htmleditformat( q_select_contact_data.ownfield2 )#
				</td>
			</tr>
		</cfif>
		
		<!--- in case of mobile office, display notices here directly ... --->
		<cfif ((Len(q_select_contact_data.notice) GT 0) OR (Len(a_str_contact_own_comment) GT 0))>
		  <tr>
			<td class="field_name">
				#GetLangVal('adrb_wd_notices')#
			</td>
			<td>#ReplaceNoCase(Trim(q_select_contact_data.notice), chr(13), '<br />', 'ALL')#</td>			
			<td class="field_name">
				<cfif Len(a_str_contact_own_comment) GT 0>#GetLangVal('adrb_ph_private_notices')#</cfif>
			</td>
			<td>
				#ReplaceNoCase(Trim(a_str_contact_own_comment), chr(13), '<br />', 'ALL')#
			</td>
		  </tr>
	  </cfif>
		
	</table>

	<!--- close div holding the content ... only needed if tabs are enabled --->
	<cfif a_bol_display_private_data>
		</div>
	</cfif>
	
</cfsavecontent>
	
<cfif a_bol_display_private_data>
	<!--- table with private contact data ... --->
	<cfsavecontent variable="a_str_private_contact_data">

		<div class="div_module_tabs_content_box" id="#a_str_id_private_data_box#">
		<table cellspacing="0" class="table_details">
			<tr>
				<td class="td_title field_name">
					#GetLangVal('adrb_wd_postal_address')#
				</td>
				<td>
					<a title="Display route and more" href="javascript:OpenAddressOptions('#jsstringformat(q_select_contact_data.entrykey)#', 'private', '#JsStringformat(q_select_contact_data.p_street)#', '#JsStringformat(q_select_contact_data.p_zipcode)#', '#JsStringformat(q_select_contact_data.p_city)#', '#JsStringformat(q_select_contact_data.p_country)#');">
					#htmleditformat(q_select_contact_data.p_street)#
					
					<cfif Len(q_select_contact_data.p_zipcode) GT 0 OR Len(q_select_contact_data.p_city) GT 0>
						<cfif Len(q_select_contact_data.p_street) GT 0><br /></cfif>
						#htmleditformat(q_select_contact_data.p_zipcode)# #htmleditformat(q_select_contact_data.p_city)#
					</cfif>
					
					<cfif Len(q_select_contact_data.p_country) GT 0>
						/
						#htmleditformat(q_select_contact_data.p_country)#
					</cfif>					
					</a>
				</td>
				<td class="td_title field_name">
					#GetLangVal('adrb_wd_telephone')#
				</td>
				<td>
					<a href="javascript:OpenCallPopup('#q_select_contact_data.entrykey#', '#jsstringformat(q_select_contact_data.p_telephone)#', '');">#htmleditformat(q_select_contact_data.p_telephone)#</a>
				</td>				
			</tr>		
			  <tr>
				<td class="field_name">
					#GetLangVal('adrb_wd_fax')#
				</td>
				<td>
					<a href="/fax/index.cfm?action=composefax&faxto=#urlencodedformat(q_select_contact_data.p_fax)#">#htmleditformat(q_select_contact_data.p_fax)#</a>
				</td>
				<td class="field_name">#GetLangVal('cm_wd_mobile')#</td>
				<td>
					<a href="javascript:OpenCallPopup('#q_select_contact_data.entrykey#', '#jsstringformat(q_select_contact_data.p_mobile)#', 'mobile');">#htmleditformat(q_select_contact_data.p_mobile)#</a>
				</td>				
			  </tr>
			  <tr>
				<td class="field_name">#GetLangVal('cm_wd_url')#</td>
				<td>
				<cfif Len(q_select_contact_data.p_url) GT 0>
				
					<cfif FindNoCase('http', q_select_contact_data.p_url) IS 1>
						<cfset a_str_link_href = q_select_contact_data.p_url>
					<cfelse>
						<cfset a_str_link_href = 'http://'&q_select_contact_data.p_url>				
					</cfif>			
					
				<a href="#a_str_link_href#" target="_blank">#htmleditformat(q_select_contact_data.p_url)#</a>
				</cfif>
				</td>
				<td class="field_name"></td>
				<td></td>				
			  </tr>
		</table>
		</div>
	</cfsavecontent>
	
</cfif>
	
<!--- write tab header and business/private content ... or just business data if no private data available --->
<cfif a_bol_display_private_data>
	
	<!--- join string together ... --->
	<cfsavecontent variable="a_str_business_data">
		#a_str_business_data#
		#a_str_business_contact_data#
		#a_str_private_contact_data#
	</cfsavecontent>
	
	#WriteNewContentBox(GetLangVal('adrb_ph_contact_data'), a_str_buttons, a_str_business_data)#

	
	<cfscript>
	// AddJSToExecuteAfterPageLoad('DisplayContactDataType(''business'');', '');
	</cfscript>
	
<cfelse>
	#WriteNewContentBox(GetLangVal('adrb_ph_contact_data') & ' (' & GetLangVal('adrb_wd_business') & ')', a_str_buttons, a_str_business_contact_data)#
</cfif>
	

</cfoutput>	
	
<!--- // account: display contacts of company // --->
<cfif q_select_contact_data.contacttype IS 1>

	<cfsavecontent variable="a_str_sub_contacts">

		<table class="table table-hover">
			<cfoutput>
			<tr class="tbl_overview_header">
				<td width="25%">
					#GetLangval('cm_wd_name')#
				</td>
				<td width="25%">
					#GetLangVal('adrb_wd_position')#
				</td>
				<td width="25%">
					#GetLangVal('adrb_wd_activities')#
				</td>
				<td width="25%">
					#GetLangVal('adrb_wd_city')# /#GetLangVal('cm_wd_email')# / #GetLangVal('adrb_wd_telephone')#
				</td>
			</tr>
			</cfoutput>
			<cfoutput query="q_select_sub_items">
			<tr>
				<td>
					<a href="index.cfm?action=ShowItem&entrykey=#q_select_sub_items.entrykey#"><img src="/images/si/vcard.png" class="si_img" /> #htmleditformat(CheckZeroString(q_select_sub_items.displayname))#</a>
				</td>
				<td>
					#htmleditformat(q_select_sub_items.department)#<cfif Len(q_select_sub_items.department) GT 0 AND Len(q_select_sub_items.aposition) GT 0>,</cfif> #htmleditformat(q_select_sub_items.aposition)#
				</td>
				<td>
					<cfif q_select_sub_items.activity_count_salesprojects GT 0>
						<img src="/images/si/coins.png" class="si_img" />
					<cfelse>
						<img src="/images/space_1_1.gif" class="si_img" alt="" />
					</cfif>
					<cfif q_select_sub_items.activity_count_followups GT 0>
						<img src="/images/si/flag_red.png" class="si_img" />
					<cfelse>
						<img src="/images/space_1_1.gif" class="si_img" alt="" />
					</cfif>
				</td>
				<td>
					#htmleditformat(q_select_sub_items.b_city)#
					<cfif Len(q_select_sub_items.b_city) GT 0>/</cfif>
					<a href="##" onclick="OpenEmailPopup('#jsstringformat(q_select_sub_items.entrykey)#', '#jsstringformat(q_select_sub_items.email_prim)#');return false;">#htmleditformat(q_select_sub_items.email_prim)#</a>
					<cfif Len(q_select_sub_items.b_telephone) GT 0>
						/
						<a href="javascript:OpenCallPopup('#q_select_sub_items.entrykey#', '#jsstringformat(q_select_sub_items.b_telephone)#');">#htmleditformat(q_select_sub_items.b_telephone)#</a>
					</cfif>
				</td>
			</tr>
			</cfoutput>
		</table>
						
	</cfsavecontent>
	
	<cfsavecontent variable="a_str_buttons">
		<cfoutput>
		<input type="button" onclick="GotoLocHref('index.cfm?Action=createnewitem&datatype=0&parentcontactkey=#url.entrykey#');" value="#GetLangVal('cm_wd_new')#" class="btn btn-primary">
		&nbsp;
		<input type="button" class="btn" onclick="GotoLocHref('index.cfm?action=ShowOrganigramm&accountkey=#url.entrykey#');" value="#GetLangVal('crm_wd_organigram')#" /> 
		</cfoutput>
	</cfsavecontent>

	<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_contacts') & ' (' & q_select_sub_items.recordcount & ')', a_str_buttons, a_str_sub_contacts)#</cfoutput>
</cfif>
	
<!--- go ahead with CRM data ... --->
	<cfinclude template="crm/dsp_inc_show_item_data_ex.cfm">
	<br /> 
	<cfinclude template="crm/dsp_inc_history.cfm">

  

  <cfsavecontent variable="a_str_contact_further_data_and_properties">
	<cfoutput>
	
	<table class="table_details">
	  
		  <cfif Len(q_select_contact_data.notice) GT 0>
		  <tr>
			<td class="field_name">#GetLangVal('adrb_wd_notices')#</td>
			<td colspan="3">#ReplaceNoCase(Trim(q_select_contact_data.notice), chr(13), '<br />', 'ALL')#</td>
		  </tr>
		  </cfif>
		  
		  <cfif Len(a_str_contact_own_comment) GT 0>
		  	<tr>
		  		<td class="field_name">#GetLangVal('adrb_ph_private_notices')#</td>
				<td colspan="3">
					#ReplaceNoCase(Trim(a_str_contact_own_comment), chr(13), '<br />', 'ALL')#
				</td>
			</tr>
	  	</cfif>
	  <tr>
	  	<td colspan="4" class="addinfotext">
		  	
			#GetLangVal('cm_wd_created')#: #DateFormat(q_select_contact_data.dt_created, request.stUserSettings.default_dateformat)#
			#GetLangVal('cm_wd_by')# #application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_contact_data.createdbyuserkey)#
			
			<cfif IsDate(q_select_contact_data.dt_lastmodified)>
				/
				
				#GetLangVal('adrb_ph_last_edited')#: #DateFormat(q_select_contact_data.dt_lastmodified, request.stUserSettings.default_dateformat)# (#TimeFormat(q_select_contact_data.dt_lastmodified, request.stUserSettings.default_timeformat)#)
					#GetLangVal('cm_wd_by')# #application.components.cmp_user.GetShortestPossibleUserIDByEntrykey(q_select_contact_data.lasteditedbyuserkey)#
			</cfif>
			
			<cfif IsDate(q_select_contact_data.dt_remoteedit_last_update)>
				/
				#GetLangVal('adrb_ph_dt_last_remote_edit')#: #DateFormat(q_select_contact_data.dt_lastmodified, request.stUserSettings.default_dateformat)#
			</cfif>
		
		</td>
	  </tr>
	  
	</table>
	
	
	</td>
  </tr>
</table></cfoutput>
  </cfsavecontent>
  
<!--- <cfoutput>#WriteSimpleHeaderDiv(GetLangVal('adrb_ph_further_data_and_properties'))#</cfoutput> --->
<cfoutput>#a_str_contact_further_data_and_properties#</cfoutput>
<!--- <cfoutput>#WriteNewContentBox(GetLangVal('adrb_ph_further_data_and_properties'), '', a_str_contact_further_data_and_properties)#</cfoutput> --->
  

	
