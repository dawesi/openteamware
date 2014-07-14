<!--- //

	Module:		Addressbook
	Action:		ShowContacts
	Description:Display all contacts


// --->

<cfparam name="url.startchar" default="" type="string">
<!---<cfparam name="url.viewmode" type="string" default="box">--->
<cfparam name="url.startrow" type="numeric" default="1">
<!--- crm view key ... --->
<cfparam name="url.filterviewkey" type="string" default="">
<cfparam name="url.filterdatatype" type="numeric" default="0" />

<!--- load various preferences ... --->
<cfset a_int_max_rows_per_page = GetUserPrefPerson('addressbook', 'adressbook.maxrowsperpage', '50', 'url.maxrows', false) />
<cfset a_str_viewmode = GetUserPrefPerson('addressbook', 'display.viewmode', 'list', 'url.viewmode', true) />
<cfset a_str_filter_workgroupkey = GetUserPrefPerson('addressbook', 'display.filterworkgroupkey', '', 'url.filterworkgroupkey', false) />
<cfset a_str_filter_category = GetUserPrefPerson('addressbook', 'display.filtercategory', '', 'url.filtercategory', false) />

<cfset a_str_filter_category = urldecode(a_str_filter_category,'utf-8') />
<cfset a_str_display_data_type = GetUserPrefPerson('extensions.crm', 'addressbook.display_data_types', '0', 'url.filterdatatype', false) />
<cfset a_str_last_shown_entrykeys = GetUserPrefPerson('addressbook', 'lastshown.entrykeys#a_str_display_data_type#', '', '', false) />

<!--- only allow *one* datatype at a single time ... --->
<cfset a_str_display_data_type = Val(a_str_display_data_type) />

<cfset a_struct_filter = StructNew() />
<cfset a_struct_loadoptions = StructNew() />

<!--- set maxrows to 0 ... load all ... use startrow/rowsperage instead --->
<cfset a_struct_loadoptions.maxrows = 0 />
<cfset a_struct_loadoptions.startrow = url.startrow />
<cfset a_struct_loadoptions.rowsperpage = a_int_max_rows_per_page />

<!--- crm extensions enabled? --->
<cfset a_struct_loadoptions.loadmaincontactsonly = true />

<cfset a_struct_loadoptions.load_sub_contacts = true />

<cfswitch expression="#a_str_display_data_type#">
	<cfcase value="1">
	<!--- accounts ... --->
	<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_wd_accounts')) />
	<cfset sOrderBy = GetUserPrefPerson('addressbook', 'display.orderby_1', 'company,surname', 'url.orderby', true) />
	</cfcase>
	<cfcase value="2">
	<!--- leads --->
	<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_wd_leads')) />
	<cfset sOrderBy = GetUserPrefPerson('addressbook', 'display.orderby_2', 'lastdisplayed', 'url.orderby', true) />
	</cfcase>
	<cfcase value="3">
	<!--- archive/pool --->
	<cfset sOrderBy = GetUserPrefPerson('addressbook', 'display.orderby_3', 'surname,company', 'url.orderby', true) />
	</cfcase>
	<cfdefaultcase>
	<!--- contacts ... --->
	<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_contacts')) />
	<cfset sOrderBy = GetUserPrefPerson('addressbook', 'display.orderby_0', 'surname,company', 'url.orderby', true) />
	</cfdefaultcase>
</cfswitch>

<!--- set possible filters ... --->
<cfset a_struct_filter.startchar = trim(url.startchar) />
<cfset a_struct_filter.loadmodifieddatatimes = false />
<cfset a_struct_filter.category = a_str_filter_category />
<cfset a_struct_filter.workgroupkey = a_str_filter_workgroupkey />
<cfset a_struct_filter.contacttype = a_str_display_data_type />

<cfif StructKeyExists(request, 'a_str_filter_contactkeys')>
	<cfset a_struct_filter.entrykeys = request.a_str_filter_contactkeys />
</cfif>

<!--- parse and create crm filter struct for the database component ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="BuildCRMFilterStruct" returnvariable="a_struct_crm_filter">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="itemttype" value="#a_str_display_data_type#">
	<cfinvokeargument name="viewkey" value="#url.filterviewkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_addressbook#" method="GetAllContacts" returnvariable="stReturn">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="convert_lastcontact_utc" value="false">
	<cfinvokeargument name="loadoptions" value="#a_struct_loadoptions#">
	<cfinvokeargument name="orderby" value="#sOrderBy#">
	<cfinvokeargument name="filterdatatypes" value="#a_str_display_data_type#">
	<cfinvokeargument name="crmfilter" value="#a_struct_crm_filter#">
</cfinvoke>

<cfset q_select_contacts = stReturn.q_select_contacts />
<cfset a_int_contacts_recordcount = stReturn.a_int_recordcount />

<cfset session.adrb_display_list_entrykeys = ValueList(q_select_contacts.entrykey) />

<cfinclude template="crm/dsp_inc_show_all_top.cfm">

<cfif a_str_viewmode is 'list'>
	<!--- start edit form ... --->
	<form onSubmit="ShowLoadingStatus();" action="index.cfm?action=DoMultiSelectAction" method="post" name="formcontacts" style="margin:0px; ">
	<input type="hidden" name="frmdisplaydatatype" value="<cfoutput>#a_str_display_data_type#</cfoutput>" />
</cfif>

<!--- TODO: rewrite text ... --->
<cfif a_int_contacts_recordcount IS 0>
	<br>
		<div class="mischeader b_all" style="padding:4px;">
		<b><cfoutput>#GetLangVal('adrb_ph_no_contacts_created_search_without_results')#</cfoutput></b>
		<br><br>
		<a href="index.cfm?action=createnewitem"><cfoutput>#GetLangVal('adrb_ph_click_here_to_create_new_contact')#</cfoutput></a>
		<br><br>
		<cfoutput>#GetLangVal('adrb_ph_already_used_outlooksync')#</cfoutput>
		<br>
		<a href="../download/"><cfoutput>#GetLangVal('adrb_ph_outlooksync_click_here')#</cfoutput></a>
		</div>
	<br>
	<cfexit method="exittemplate">
</cfif>


<!---

<cfif StructKeyExists(session, 'adrb_display_list_entrykeys') AND ListLen(session.adrb_display_list_entrykeys) GT 1>
		<div class="divleftnavpanelactions">

		<div class="divleftnavpanelheader"><cfoutput>#a_str_title_left#</cfoutput></div>

			<ul class="divleftpanelactions" >

					<cfset a_int_list_index = ListFind(session.adrb_display_list_entrykeys, url.entrykey) />

					<!--- next or previous --->
					<cfif a_int_list_index GT 1>
						<li><a href="index.cfm?action=ShowItem&entrykey=<cfoutput>#ListGetat(session.adrb_display_list_entrykeys, (a_int_list_index - 1))#</cfoutput>"><cfoutput>#MakeFirstCharUCase(GetLangVal('adrb_ph_previous_contact'))#</cfoutput></a></li>
					</cfif>

					<cfif ListLen(session.adrb_display_list_entrykeys) GT a_int_list_index>
						<li>
						<a href="index.cfm?action=ShowItem&entrykey=<cfoutput>#ListGetat(session.adrb_display_list_entrykeys, (a_int_list_index + 1))#</cfoutput>"><cfoutput>#MakeFirstCharUCase(GetLangVal('adrb_ph_next_contact'))#</cfoutput></a>
						</li>
					</cfif>
			</ul>
		</div>

	</cfif>
 --->


<!--- <cfif len(url.search) gt 0>
  <!--- hinweis zum suchergebnis ... --->
  <br>
 	<div class="bt mischeader" style="padding:4px;">
  		<b><img src="../images/addressbook/menu_suchen.gif" width="19" height="19" hspace="2" vspace="2" border="0" align="absmiddle"><cfoutput>#ReplaceNoCase(GetLangVal('adrb_ph_searchresult_for'), '%TERM%', url.search)#</cfoutput></b>: <cfoutput>#a_int_contacts_recordcount#</cfoutput> <cfoutput>#GetLangVal('adrb_wd_hits')#</cfoutput> &nbsp;&nbsp; <a href="index.cfm"><cfoutput>#GetLangVal('adrb_ph_search_show_all_items_again')#</cfoutput></a>
	</div>

</cfif> --->

<cfinvoke component="#application.components.cmp_tools#" method="GeneratePageScroller" returnvariable="a_str_page_scroller">
	<cfinvokeargument name="servicekey" value="#request.sCurrentServiceKey#">
	<cfinvokeargument name="current_url" value="#cgi.QUERY_STRING#">
	<cfinvokeargument name="url_tag_name" value="startrow">
	<cfinvokeargument name="step" value="#a_int_max_rows_per_page#">
	<cfinvokeargument name="recordcount" value="#a_int_contacts_recordcount#">
	<cfinvokeargument name="current_record" value="#url.startrow#">
</cfinvoke>

<cfoutput>#a_str_page_scroller#</cfoutput>

<cfset request.a_str_page_scroller = a_str_page_scroller />

	<!--- list --->
	<cfset begin = GetTickCount()>
	<cfinclude template="dsp_show_all_list.cfm">

<cfif a_int_contacts_recordcount GT a_int_max_rows_per_page>
	<!--- display scroller ... --->
	<cfoutput>#request.a_str_page_scroller#</cfoutput>
</cfif>

<cfif a_str_viewmode IS 'list'>

	<div class="bt" style="padding:6px; ">
		<input type="hidden" name="frmselectaction" value="" />
		<input class="btn" onClick="ShowCommonContactsActionOptions();" type="button" value="<cfoutput>#GetLangVal('cm_ph_show_common_action_options')#</cfoutput>" />

		<cfif a_int_contacts_recordcount GT a_int_max_rows_per_page>
			<input type="button" class="btn" onclick="GotoLocHref('index.cfm?<cfoutput>#ReplaceOrAddURLParameter(cgi.query_string, 'maxrows', 9999)#</cfoutput>');" value="<cfoutput>#GetLangVal('crm_ph_show_all_applying_data_at_once')#</cfoutput>" />
		</cfif>
	</div>
	</form>
</cfif>



<cfsavecontent variable="a_str_content">

<cfif a_str_display_data_type NEQ 1>
	<cfoutput>#WriteSimpleheaderDiv(GetLangVal('cm_wd_email'))#</cfoutput>

	<ul class="ul_nopoints">
		<li>
			<a href="javascript:SetContactsCommonAction('createmailing');"><cfoutput>#si_img('arrow_out')#</cfoutput> <cfoutput>#GetLangVal('crm_ph_create_new_mailing')#</cfoutput></a>
		</li>
		<li>
		<a href="javascript:SetContactsCommonAction('email');"><cfoutput>#si_img('email')#</cfoutput>  <cfoutput>#GetLangVal('adrb_ph_actions_email')#</cfoutput></a>
		</li>
	</ul>



</cfif>

<cfoutput>#WriteSimpleheaderDiv(MakeFirstCharUCase(GetLangVal('cm_ph_edit_together')))#</cfoutput>
<ul class="ul_nopoints">
	<li>
		<a href="javascript:SetContactsCommonAction('massaction');"><img src="/images/si/tag_red.png" class="si_img" /> <cfoutput>#GetLangVal('crm_wd_criteria')#</cfoutput></a>
	</li>
	<li>
		<a href="javascript:SetContactsCommonAction('massaction');"><img src="/images/si/user_add.png" class="si_img" /> <cfoutput>#GetLangVal('crm_wd_filter_element_assignedto')#</cfoutput></a>
	</li>
	<li>
		<a href="javascript:SetContactsCommonAction('massaction');"><img src="/images/si/group_add.png" class="si_img" /> <cfoutput>#GetLangVal('cm_wd_workgroups')#</cfoutput></a>
	</li>
</ul>

<cfoutput>#WriteSimpleheaderDiv(GetLangVal('cm_wd_administration'))#</cfoutput>
<ul class="ul_nopoints">
	<cfif a_str_display_data_type IS 0>
	<li>
		<a href="javascript:SetContactsCommonAction('remoteedit');"><img alt="" src="/images/space_1_1.gif" class="si_img" /> <cfoutput>#GetLangVal('adrb_ph_actions_remoteedit')#</cfoutput></a>
	</li>
	</cfif>
	<li>
		<a href="javascript:SetContactsCommonAction('export');"><img alt="" src="/images/space_1_1.gif" class="si_img" /> <cfoutput>#GetLangVal('adrb_ph_actions_export')#</cfoutput></a>
	</li>
	<li>
		<a href="javascript:SetContactsCommonAction('forward');"><img alt="" src="/images/space_1_1.gif" class="si_img" /> <cfoutput>#GetLangVal('adrb_ph_actions_forward')#</cfoutput></a>
	</li>
	<li>
		<a href="javascript:SetContactsCommonAction('delete');"><img alt="" src="/images/si/delete.png" class="si_img" /> <cfoutput>#MakeFirstCharUCase(GetLangVal('cm_wd_delete'))#</cfoutput></a>
	</li>
</ul>

<cfoutput>#WriteSimpleheaderDiv(MakeFirstCharUCase(GetLangVal('cm_wd_further')))#</cfoutput>
<ul class="ul_nopoints">
	<cfif a_str_display_data_type NEQ 1>
	<li>
		<a href="javascript:SetContactsCommonAction('addtonewsletter');"><img alt="" src="/images/space_1_1.gif" class="si_img" /> <cfoutput>#GetLangVal('adrb_ph_actions_newsletter')#</cfoutput></a>
	</li>
	</cfif>
	<!--- <li>
		<a href="javascript:SetContactsCommonAction('advancedactions');"><img src="/images/si/report_add.png" class="si_img" />GENERATE REPORT WITH THESE DATA</a>
	</li>
	<cfif a_str_display_data_type IS 0>
	<li>
		<a href="javascript:SetContactsCommonAction('join_and_create_account');"><img src="/images/space_1_1.gif" class="si_img" />JOIN AND CREATE ACCOUNT</a>
	</li>
	</cfif> --->
</ul>





</cfsavecontent>

<cfsavecontent variable="a_str_js">
	var a_str_content = '<cfoutput>#jsstringformat(a_str_content)#</cfoutput>';
	function ShowCommonContactsActionOptions() {
		var a_simple_modal_dialog = new cSimpleModalDialog();
		a_simple_modal_dialog.type = 'custom';
		a_simple_modal_dialog.customtitle = '<cfoutput>#jsstringformat(GetLangValJS('cm_ph_please_select_option'))#</cfoutput>';
		a_simple_modal_dialog.customcontent = a_str_content;
		// show dialog
		a_simple_modal_dialog.ShowDialog();
		}


// set action and submit
function SetContactsCommonAction(action, parameter){
	document.forms.formcontacts.frmselectaction.value = action;
	document.forms.formcontacts.submit();
	}
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('', a_str_js) />
