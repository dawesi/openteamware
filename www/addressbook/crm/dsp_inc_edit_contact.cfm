<cfset a_cmp_crm_sales = application.components.cmp_crmsales />

<cfinvoke component="#a_cmp_crm_sales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) IS 0>
	<cfexit method="exittemplate">
</cfif>

<cfset a_int_criteria_count = a_cmp_crm_sales.GetCriteriaCount(companykey = request.stSecurityContext.mycompanykey)>

<cfif a_int_criteria_count GT 0>
<tr>
	<td class="b_all">
		<div class="bb" style="padding:4px;"><b>Attribute</b></div>
		
		<cfoutput>
		<input type="hidden" name="frmcriteria" value="#htmleditformat(EditOrCreateContact.query.criteria)#" size="50">
				
		<div id="id_div_display_criteria"></div>
				
		<div style="padding-left:20px; ">
		<a href="javascript:OpenCriteriaPopup(document.formcreateeditcontact.value);">#GetLangVal('crm_ph_criteria_edit')#</a>
		</div>
		
		<!--- display available criteria ... --->
		<cfsavecontent variable="a_str_disp_criterias">
			DisplayCriteriaData('<cfoutput>#jsstringformat(EditOrCreateContact.query.criteria)#</cfoutput>');
		</cfsavecontent>	
		
		<cfscript>
			AddJSToExecuteAfterPageLoad('DisplayCriteriaData(''#jsstringformat(EditOrCreateContact.query.criteria)#'');', '');
		</cfscript>
		
		</cfoutput>
			
	</td>
</tr>
</cfif>

<tr>
	<td class="b_all">
	<div class="bb" style="padding:4px;">
	<b><cfoutput>#GetLangVal('crm_ph_own_fields')#</cfoutput></b>
	</div>
	
	
	<cfset ShowCoreData.action = 'EditRecord'>
	<cfset ShowCoreData.table_entrykey = a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY>
	<cfset ShowCoreData.viewmode = 'single'>
	<cfset ShowCoreData.orderby = 'ASC'>
	<cfset ShowCoreData.enable_search = 0>
	<cfset ShowCoreData.enable_adddata = 0>
	<cfset ShowCoreData.enable_showempty = 1>
	<cfset ShowCoreData.startrow = 1>
	<cfset ShowCoreData.filterfieldname = 'addressbookkey'>
	<cfset ShowCoreData.ORDERBYFILTERVALUES = ''>
	
	<cfset ShowCoreData.filtervalue = EditOrCreateContact.query.entrykey>
	
	<cfset ShowCoreData.DisplaySource = 'addressbook'>
	<cfset ShowCoreData.SHOW_FORM = false>
	<cfset ShowCoreData.form_name = 'formcreateeditcontact'>
	
	<cfinclude template="../../database/inc_data_display_load.cfm">
	<cfset ShowCoreData.record_entrykey = a_struct_tabledata.origquery.entrykey>	
	
	<cfinclude template="../../database/inc_data_display_edit.cfm">
	
	</td>
</tr>