<!--- //

	Module:		Address Book
	Description:Display CRM data of contact / lead / contact ...
	
// --->

<cfset tmp = AddJSToExecuteAfterPageLoad('DisplayActivitiesAssignedToObject(''' & jsstringformat(url.entrykey) & ''')', '') />

<cfscript>
	StartNewJSPopupMenu('a_pop_act_evnt_tsk');
	AddNewJSPopupMenuItem(GetLangValJS('crm_wd_follow_up'), 'javascript:call_new_item_for_contact(\''#jsstringformat(url.entrykey)#\'', \''followup\'');');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_task'), 'javascript:call_new_item_for_contact(\''#jsstringformat(url.entrykey)#\'', \''task\'');');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_appointment'), 'javascript:call_new_item_for_contact(\''#jsstringformat(url.entrykey)#\'', \''appointment\'');');
	AddNewJSPopupMenuItem(GetLangValJS('cm_wd_project'), 'javascript:call_new_item_for_contact(\''#jsstringformat(url.entrykey)#\'', \''project\'');');
	AddNewJSPopupMenuToPage();
</cfscript>
	
<cfsavecontent variable="a_str_buttons">
	<input id="id_btn_call_tsk_evnt_actions" onClick="ShowHTMLActionPopup('id_btn_call_tsk_evnt_actions', a_pop_act_evnt_tsk);return false;" type="button" value="<cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput>" class="btn btn-primary" />
	<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'activities');" type="button" value="<cfoutput>#htmleditformat(MakeFirstCharUCase(GetLangVal('cm_wd_edit')))#</cfoutput>" class="btn" />
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('adrb_wd_activities'), a_str_buttons, GenerateSimpleDivWithID('id_div_crm_show_contact_tasks_and_appointments'), 'id_fieldset_tasks_appointments_followups', 'hidden')#</cfoutput>

<!--- assigned products ... --->
<cfinvoke component="#application.components.cmp_products#" method="DisplayProductsOfContact" returnvariable="a_str_products_of_contact">
	<cfinvokeargument name="securitycontext" value="#request.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#request.stUserSettings#">
	<cfinvokeargument name="contactkey" value="#url.entrykey#">
</cfinvoke>

<cfif Len(a_str_products_of_contact) GT 0>

<cfsavecontent variable="a_str_buttons">
	<input onclick="GotoLocHref('/crm/index.cfm?action=addProductToContact&contactkey=<cfoutput>#url.entrykey#</cfoutput>');" type="button" value="<cfoutput>#GetLangVal('cm_wd_new')#</cfoutput>" class="btn btn-primary" />
	<input onclick="GotoLocHref('/crm/index.cfm?action=addMultipleProductsToContact&contactkey=<cfoutput>#url.entrykey#</cfoutput>');" type="button" value="<cfoutput>#GetLangVal('cm_wd_new_multiple')#</cfoutput>" class="btn btn-primary" />
	<input onclick="GotoLocHref('/crm/index.cfm?action=showProductsOfContact&contactkey=<cfoutput>#url.entrykey#</cfoutput>&editmode=true');" type="button" value="<cfoutput>#GetLangVal('crm_ph_products_history')#</cfoutput>" class="btn" />	
</cfsavecontent>

<cfoutput>#WriteNewContentBox(GetLangVal('crm_ph_products'), a_str_buttons, a_str_products_of_contact, 'id_div_fieldset_contacts_products')#</cfoutput>
</cfif>

<!--- attached files --->
<cfif Len(request.stSecurityContext.crmsales_bindings.USERKEY_DATA) GT 0>					
		
	<!--- buttons --->
	<cfsavecontent variable="a_str_buttons">
		<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'files');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_edit'))#</cfoutput> " class="btn btn-primary">
		<input onClick="call_edit_contact('<cfoutput>#jsstringformat(url.entrykey)#</cfoutput>', 'files');" type="button" value=" <cfoutput>#htmleditformat(GetLangVal('cm_wd_new'))#</cfoutput> " class="btn btn-primary">
	</cfsavecontent>
	
	<!--- write --->
	<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_files'), a_str_buttons, GenerateSimpleDivWithID('id_div_crm_show_contact_files'), 'id_div_fieldset_files_assigned_to_user')#</cfoutput>
	
	<cfscript>
		AddJSToExecuteAfterPageLoad('DisplayFilesAttachedToContact("#jsstringformat(url.entrykey)#", "")', '', false);
	</cfscript>

</cfif>
