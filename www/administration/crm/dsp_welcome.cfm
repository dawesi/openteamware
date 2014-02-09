<!--- //

	Module:		Admintool
	Action:		CRM
	Description: 
	
// --->

<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<h4>CRM</h4>

<table class="table_details table_edit_form">
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_database')#</cfoutput>
		</td>
		<td>
			<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) IS 0>
				<a href="default.cfm?action=crm&subaction=enablecrm_database<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_crm_enable_assign_database')#</cfoutput></a>
	
			<cfelse>
				<cfoutput>#GetLangVal('adm_ph_crm_database_is_assigned')#</cfoutput>
				<br /><br />
				<a href="default.cfm?action=crm&subaction=database_properties<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_edit_database_properties')#</cfoutput></b></a>  
				<br /><br />
				<a href="default.cfm?action=crm&subaction=reorganize<cfoutput>#WriteURLTags()#</cfoutput>">Reorganize and Check</a>  
			</cfif>
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('adm_ph_user_for_storing_crm_data')#</cfoutput>
		</td>
		<td>
			<cfoutput>#Application.Components.cmp_user.GetUsernameByEntrykey(a_struct_crmsales_bindings.userkey_data)#</cfoutput>
		</td>
	</tr>
</table>




