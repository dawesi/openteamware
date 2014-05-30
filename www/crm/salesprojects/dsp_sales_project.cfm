<!--- //

	Module:			CRM
	Action:			ShowSalesProject
	Description:	Show details for one Sales project
	

// --->	
<cfparam name="url.entrykey" type="string" default="">

<cfset a_cmp_crm_sales = CreateObject('component', request.a_str_component_crm_sales)>

<cfinvoke component="#a_cmp_crm_sales#" method="GetSalesProject" returnvariable="a_struct_sales_project">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfset q_select_sales_project = a_struct_sales_project.q_select_sales_project>
<cfset q_select_contacts_assigned_to_sales_project = a_struct_sales_project.q_select_contacts_assigned_to_sales_project>
<cfset q_select_sales_project_stage_trends = a_struct_sales_project.q_select_sales_project_stage_trends>

<cfif q_select_sales_project.recordcount IS 0>
	No data found.
	<cfexit method="exittemplate">
</cfif>

<cfset tmp = SetHeaderTopInfoString(GetLangVal('crm_ph_sales_project') & ' ' & htmleditformat(q_select_sales_project.title))>

<cfset a_cmp_addressbook = CreateObject('component', request.a_str_component_addressbook)>
<cfset a_cmp_users = CreateObject('component', request.a_str_component_users)>

<br/>

<!--- sales projects ... --->
<cfsavecontent variable="a_str_buttons">

	<input onClick="location.href= 'index.cfm?action=EditOrNewSalesProject&entrykey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>';" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_edit'))#</cfoutput> " class="btn btn-primary">
	<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'sales_projects');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
	<input type="button" value="<cfoutput>#GetLangVal('crm_ph_close_deal')#</cfoutput>" class="btn btn-primary" onClick="alert('2do');">
	
</cfsavecontent>

<cfsavecontent variable="a_str_content">
<cfoutput query="q_select_sales_project">
	<table cellspacing="0" class="table_details">
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_title')#
		</td>
		<td style="font-weight:bold;">
			#htmleditformat(q_select_project.title)#
		</td>
		<td class="field_name">
			#GetLangVal('cm_wd_stage')#
		</td>
		<td>
			#GetLangVal('crm_wd_sales_stage_' & q_select_project.stage)#
		</td>
	</tr>
	<tr>
		<td class="td_title field_name" width="25%">
			#GetLangVal('cm_wd_contact')#
		</td>
		<td width="25%">
			<a href="/addressbook/?action=ShowItem&entrykey=#q_select_project.contactkey#">#a_cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_sales_project.contactkey)#</a>
		</td>
		<td class="td_title field_name" width="25%">
			#GetLangVal('crm_ph_expected_sales')#
		</td>
		<td width="25%">
			#val(q_select_sales_project.sales)# #q_select_sales_project.currency#
		</td>			
	</tr>
	<tr>
		<td class="td_title field_name">
			#GetLangVal('cm_wd_responsible_person')#
		</td>
		<td>
			#a_cmp_users.GetFullNameByentrykey(q_select_sales_project.responsibleuserkey)#
		</td>
		<td class="td_title field_name">
			#GetLangVal('crm_ph_closing_date')#
		</td>
		<td>
			<cfif IsDate(q_select_sales_project.dt_closing)>
				#LSDateFormat(q_select_sales_project.dt_closing, request.stUserSettings.default_dateformat)#
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			#GetLangVal('cm_wd_description')#
		</td>
		<td colspan="3" width="75%">
			#htmleditformat(q_select_sales_project.comment)#
		</td>
	</tr>
	<tr>
		<td class="td_title field_name">
			#GetLangVal('cm_wd_type')#
		</td>
		<td>
			<cfswitch expression="#q_select_sales_project.project_type#">
				<cfcase value="0">
					#GetLangVal('crm_ph_deal_totally_new')#
				</cfcase>
				<cfcase value="1">
					#GetLangVal('crm_ph_deal_totally_followup')#
				</cfcase>
			</cfswitch>
		</td>
		<td class="td_title field_name">
			#GetLangVal('cm_ph_probability')#
		</td>
		<td>
			#val(q_select_sales_project.probability)#%
		</td>
	</tr>
	<tr>
		<td class="td_title field_name">
			#GetLangVal('crm_ph_lead_source')#
		</td>
		<td>
			#GetLangVal('crm_ph_leadsource_' & q_select_sales_project.lead_source)#
			
			<cfif Len(q_select_sales_project.lead_source_id) GT 0>
				(#htmleditformat(q_select_sales_project.lead_source_id)#)
			</cfif>			
		</td>
		<!--- internal name for source ... --->
		<td class="td_title field_name">
			
		</td>
		<td>
			
		</td>		
	</tr>
	<!---
	<tr>
		<td class="td_title field_name">
			#GetLangVal('crm_ph_offer_made')#
		</td>
		<td>
			#q_select_sales_project.offer_made#
		</td>
		<td class="td_title field_name">
			#GetLangVal('cm_wd_date')#
		</td>
		<td>
			#q_select_sales_project.dt_offer_made#
		</td>
	</tr>--->
	
	<cfif IsDate(q_select_sales_project.dt_project_start) OR IsDate(q_select_sales_project.dt_project_end)>
	<tr>
		<td class="td_title field_name">
			#GetLangVal('crm_ph_project_start')#
		</td>
		<td>
			#q_select_sales_project.dt_project_start#
		</td>
		<td class="td_title field_name">
			#GetLangVal('crm_ph_project_end')#
		</td>
		<td>
			#q_select_sales_project.dt_project_end#
		</td>
	</tr>
	</cfif>
	</table>
</cfoutput>
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangval('crm_ph_sales_project') & ' ' & htmleditformat(q_select_sales_project.title), a_str_buttons, a_str_content, 'id_div_fieldset_contacts_sales_projects')#</cfoutput>
<br/>

<!--- tasks --->
<cfsavecontent variable="a_str_content">
	content
</cfsavecontent>

<cfsavecontent variable="a_str_js_to_exec_on_load">
	function DisplayTasksAndAppointmentsAssignedToContacts(editmode) {
		var a_editmode = false;
		var a_simple_get = new cBasicBgOperation();
		
		if (editmode) {
			a_editmode = editmode;
			}
		
		a_simple_get.url = '/addressbook/crm/utils/inc_load_contacts_data_tasks_appointments.cfm?salesprojectkey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>&entrykeys=<cfoutput>#urlencodedformat(q_select_sales_project.contactkey)#</cfoutput>&editmode=' + a_editmode + '&r=' + escape(Math.random());
		a_simple_get.callback_function = processReqDisplayTasksAndAppointments;
		a_simple_get.doOperation();
		}

	function processReqDisplayTasksAndAppointments(responseText) {
		obj1 = findObj('id_div_crm_show_contact_tasks_and_appointments');										
		obj1.innerHTML = responseText;	
		
		if (responseText == '') {
			obj1.innerHTML = 'no data found';
			// findObj('id_fieldset_tasks_appointments_followups').style.display = 'none';
			}
		}
		
	<cfoutput>
	var a_pop_further_actions_evnt_tsk = new cActionPopupMenuItems();
	a_pop_further_actions_evnt_tsk.AddItem('#GetLangValJS('crm_wd_follow_up')#','javascript:call_new_item_for_contact(\'<cfoutput>#jsstringformat(q_select_sales_project.contactkey)#</cfoutput>\', \'followup\');','','','','');
	a_pop_further_actions_evnt_tsk.AddItem('#GetLangValJS('cm_wd_task')#','javascript:call_new_item_for_contact(\'<cfoutput>#jsstringformat(q_select_sales_project.contactkey)#</cfoutput>\', \'task\')','','','','');
	a_pop_further_actions_evnt_tsk.AddItem('#GetLangValJS('cm_wd_appointment')#','javascript:call_new_item_for_contact(\'<cfoutput>#jsstringformat(q_select_sales_project.contactkey)#</cfoutput>\', \'appointment\')','','','','');
	</cfoutput>
	
</cfsavecontent>

<cfscript>
	AddJSToExecuteAfterPageLoad('DisplayTasksAndAppointmentsAssignedToContacts()', a_str_js_to_exec_on_load);
</cfscript>

<cfsavecontent variable="a_str_buttons">
	<input onClick="call_edit_contact('<cfoutput>#jsstringformat(q_select_sales_project.contactkey)#</cfoutput>', 'tasksappointmentsfollowups', '<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_edit'))#</cfoutput> " class="btn btn-primary">
	<input id="id_btn_call_tsk_evnt_actions" onClick="ShowHTMLActionPopup('id_btn_call_tsk_evnt_actions', a_pop_further_actions_evnt_tsk);return false;" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
</cfsavecontent>

<!--- write --->
<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_follow_ups') & ', ' & GetLangVal('cm_wd_tasks') & ' & ' & GetLangVal('cm_wd_events'), a_str_buttons, GenerateSimpleDivWithID('id_div_crm_show_contact_tasks_and_appointments'), 'id_fieldset_tasks_appointments_followups')#</cfoutput>
	
<br/>

<!--- history --->
<cfsavecontent variable="a_str_buttons">
	<input onClick="call_new_item_for_contact('<cfoutput>#jsstringformat(q_select_sales_project.contactkey)#</cfoutput>', 'history', '<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
</cfsavecontent>

<cfset a_struct_filter = StructNew()>
<cfset a_struct_filter.salesprojectkey = q_select_sales_project.entrykey>

<cfinvoke component="#a_cmp_crm_sales#" method="DisplayHistoryItemsOfElement" returnvariable="a_str_content">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="filter" value="#a_struct_filter#">
	<cfinvokeargument name="servicekey" value="52227624-9DAA-05E9-0892A27198268072">
	<cfinvokeargument name="objectkey" value="#q_select_sales_project.contactkey#">
</cfinvoke>

<cfoutput>#WriteNewContentBox(GetLangval('crm_wd_history'), a_str_buttons, a_str_content)#</cfoutput>

<br/>

<!--- assigned contacts... --->
<cfsavecontent variable="a_str_buttons">
	<input onClick="location.href= 'index.cfm?action=AssignNewContactToSalesProject&salesprojectkey=<cfoutput>#urlencodedformat(url.entrykey)#</cfoutput>';" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
</cfsavecontent>

<cfsavecontent variable="a_str_content">

	<table class="table table-hover" cellspacing="0">
		<cfoutput>
		<tr class="tbl_overview_header">
			<td width="25%">
				#GetLangVal('cm_wd_name')#
			</td>
			<td width="25%">
				#GetLangVal('cm_wd_type')#
			</td>
			<td width="25%">
				#GetLangVal('crm_wd_role')#
			</td>
			<td width="25%">
				#GetLangVal('cm_wd_comment')#
			</td>
		</tr>
		</cfoutput>
		<cfoutput query="q_select_contacts_assigned_to_sales_project">
			<tr>
				<td width="25%">
					<!--- get name ... --->
					<cfif q_select_contacts_assigned_to_sales_project.internal_user IS 1>
						<!--- int user --->
						#a_cmp_users.GetFullNameByentrykey(q_select_contacts_assigned_to_sales_project.contactkey)#
					<cfelse>
						<!--- from address book --->
						<a href="/addressbook/?action=ShowItem&entrykey=#q_select_contacts_assigned_to_sales_project.contactkey#">#a_cmp_addressbook.GetContactDisplayNameData(entrykey = q_select_contacts_assigned_to_sales_project.contactkey)#</a>
					</cfif>
				</td>
				<td width="25%">
					<!--- mitarbeiter, partner, kunde, mitbewerber --->
					#GetLangVal('crm_ph_assigned_contact_type_' & q_select_contacts_assigned_to_sales_project.contact_type)#
				</td>
				<td width="25%">
					#GetLangVal('crm_ph_assigned_contact_role_' & q_select_contacts_assigned_to_sales_project.role_type)#
				</td>
				<td width="25%">
					#htmleditformat(q_select_contacts_assigned_to_sales_project.comment)#
				</td>
			</tr>
		</cfoutput>
	</table>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangval('crm_ph_assigned_contacts'), a_str_buttons, a_str_content)#</cfoutput>

<br/>


<cfsavecontent variable="a_str_content">

	<table class="table table-hover" cellspacing="0">
		<cfoutput>
		<tr class="tbl_overview_header">
			<td width="25%">
				#GetLangVal('crm_wd_stage')#
			</td>
			<td>
				#GetLangVal('crm_ph_expected_sales')#
			</td>
			<td>
				#GetLangVal('cm_ph_probability')# (%)
			</td>
			<td width="25%">
				#GetLangVal('crm_ph_closing_date')#
			</td>
			<td width="25%">
				#GetLangVal('cm_wd_created')#
			</td>
			
		</tr>
		</cfoutput>
		<cfoutput query="q_select_sales_project_stage_trends">
			<tr>
				<td>
					#GetLangVal('crm_wd_sales_stage_' & q_select_sales_project_stage_trends.stage)#
				</td>
				<td>
					#val(q_select_sales_project_stage_trends.sales)#
				</td>
				<td>
					#q_select_sales_project_stage_trends.probability#%
				</td>
				<td>
					<cfif IsDate(q_select_sales_project_stage_trends.dt_closing)>
						#LsDateFormat(q_select_sales_project_stage_trends.dt_closing, request.stUserSettings.default_dateformat)#
					</cfif>
				</td>
				<td>
					#LsDateFormat(q_select_sales_project_stage_trends.dt_created, request.stUserSettings.default_dateformat)#
				</td>
			</tr>
		</cfoutput>
	</table>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangval('crm_ph_stage_trends'), '', a_str_content)#</cfoutput>

