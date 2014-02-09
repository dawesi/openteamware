<!--- //

	Module:		Address Book / CRM
	Action:		ShowItem
	Description:Display the history of an item
	
// --->


<cfsavecontent variable="a_str_box">


	<cfset tmp = StartNewTabNavigation() />
	<!--- <cfset tmp = AddTabNavigationItem(GetLangVal('cm_wd_overview'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''overview'', GetCurrentCRMHistoryDays());', '') />
	 --->
	 <cfset tmp = AddTabNavigationItem(GetLangVal('adrb_wd_activities'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''activities'', GetCurrentCRMHistoryDays());', '') />
	<cfset tmp = AddTabNavigationItem(GetLangVal('crm_wd_telephone_calls'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''telephonecalls'', GetCurrentCRMHistoryDays());', '') />		
	<cfset tmp = AddTabNavigationItem(GetLangVal('cm_wd_email') & '/' & GetLangVal('cm_wd_fax'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''emailfaxsms'', GetCurrentCRMHistoryDays());', '') />
	<cfset tmp = AddTabNavigationItem(GetLangVal('crm_wd_follow_ups'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''followups'', GetCurrentCRMHistoryDays());', '') />
	<cfset tmp = AddTabNavigationItem(GetLangVal('cm_wd_events'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''appointments'', GetCurrentCRMHistoryDays());', '') />
	<cfset tmp = AddTabNavigationItem(GetLangVal('cm_wd_tasks'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''tasks'', GetCurrentCRMHistoryDays());', '') />
	<cfset tmp = AddTabNavigationItem(GetLangVal('cm_wd_mailings'), 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''newsletter'', GetCurrentCRMHistoryDays());', '') />
	
	<!--- history tab ... for admin only --->
	<cfif request.stSecurityContext.iscompanyadmin IS 1>
		<cfset tmp = AddTabNavigationItem('Admin', 'javascript:ShowActivitiesData(''' & jsstringformat(url.entrykey) & ''', ''admin'', GetCurrentCRMHistoryDays());', '') />
	</cfif>
	
	<cfoutput>#BuildTabNavigation('id_content_output_activities', false)#</cfoutput>
</cfsavecontent>
	
<cfsavecontent variable="a_str_buttons">
<cfoutput>
	<form style="margin:0px;" name="form_set_crm_history_days">
		<input class="btn" type="button" style="width:auto;" onclick="call_new_item_for_contact('#jsstringformat(url.entrykey)#', 'history');return false;" value="#GetLangVal('crm_ph_record_event')#" />			
	
		<cfif a_struct_object.rights.delete>
			<input type="button" class="btn2" value="#MakeFirstCharUCase(GetLangVal('cm_wd_edit'))#" onclick="ShowActivitiesData('#jsstringformat(url.entrykey)#', 'activities', GetCurrentCRMHistoryDays(), true);" />
		</cfif>
		
		<div style="display:none;">
		&nbsp;&nbsp;
	
		#GetLangVal('cal_wd_timeframe')#:
		<select name="frmdays" onChange="ShowActivitiesData('#jsstringformat(url.entrykey)#', a_current_history_area, this.value);">
			<option value="30">30</option>
			<option selected value="90">90</option>
			<option value="360">360</option>
			<option value="0">alle</option>
		</select>
		#GetLangVal('cm_wd_days')#
		</div>
	</form> 
</cfoutput>
	<!--- <input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'history');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_edit'))#</cfoutput> " class="btn">
 --->

</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_wd_history'), a_str_buttons, a_str_box)#</cfoutput>

<cfset tmp = AddJSToExecuteAfterPageLoad('ShowActivitiesData(''#jsstringformat(url.entrykey)#'', ''activities'', ''30'')', '') />


<!--- other linked contacts --->
<cfset a_struct_filter_linked_contacts = StructNew()>
<cfset a_struct_filter_linked_contacts.statusonly = 0>

<cfinvoke component="#application.components.cmp_crmsales#" method="GetItemActivitiesAndData" returnvariable="a_struct_linked_contacts">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkeys" value="#url.entrykey#">
	<cfinvokeargument name="filter" value="#a_struct_filter_linked_contacts#">
	<cfinvokeargument name="type" value="linked_items">
</cfinvoke>

<cfif a_struct_linked_contacts.recordcount GT 0>
	
	<cfsavecontent variable="a_str_buttons">
		<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'contact_links');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_edit'))#</cfoutput> " class="btn">
		<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'contact_links');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn">
	</cfsavecontent>
	
	<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_links'), a_str_buttons, a_struct_linked_contacts.a_str_content, 'id_div_fieldset_contacts_linked_to')#</cfoutput>
</cfif>
