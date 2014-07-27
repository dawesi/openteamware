<!--- //

	Module:		Address Book
	Function:	GetContact
	Description:Set various display data for certain fields (e.g. criteria name instead of IDs)
				Generate data for "virtual" database fields (like workgroup shares)
	

// --->

<!--- assigned users ... --->
<cfif arguments.loadmetainformations>
	<cfset QuerySetCell(q_select_contact, 'virtual_assignedusers_data', ValueList(stReturn.q_select_assigned_contacts.userkey), 1) />
	<cfset QuerySetCell(q_select_contact, 'virtual_assignedusers_data_displayvalue', ValueList(stReturn.q_select_assigned_contacts.displayname), 1) />
	
	<cfset QuerySetCell(q_select_contact, 'virtual_workgroupshares_data', ValueList(stReturn.q_select_workgroup_shares.workgroupkey), 1) />
	<cfset QuerySetCell(q_select_contact, 'virtual_workgroupshares_data_displayvalue', ValueList(stReturn.q_select_workgroup_shares.workgroupname), 1) />

</cfif>

<!--- set NACE value to empty string if "0" is the value ... --->
<cfif val(q_select_contact.nace_code) IS 0>
	<cfset QuerySetCell(q_select_contact, 'nace_code', '', 1) />
</cfif>

<!--- industry ... --->
<cfif val(q_select_contact.nace_code) GT 0>
	<!--- get name of industry ... --->
	
	<cfset a_str_industry_name = application.components.cmp_Addressbook.ReturnIndustryNameByNACECode(nace_code = q_select_contact.nace_code,
									language = arguments.usersettings.language) />
	
	<cfset QuerySetCell(q_select_contact, 'nace_code_displayvalue', a_str_industry_name, 1) />
</cfif>

<cfif Len(q_select_contact.superiorcontactkey) GT 0>

	<cfset a_str_superiorcontactname = application.components.cmp_Addressbook.GetContactDisplayNameData(entrykey = q_select_contact.superiorcontactkey) />
	
	<cfset QuerySetCell(q_select_contact, 'superiorcontactkey_displayvalue', a_str_superiorcontactname, 1) />	

</cfif>

<!--- in case of "0" value, set empty fields ... --->
<cfif q_select_contact.criteria IS '0'>
	<cfset QuerySetCell(q_select_contact, 'criteria', '', 1) />
</cfif>

<!--- criteria ... --->
<cfif Len(q_select_contact.criteria) GT 0>
	
	<cfset a_str_criteria_displayvalue = application.components.cmp_crmsales.GetCriteriaNamesByIDs(securitycontext = arguments.securitycontext,
									ids = q_select_contact.criteria) />

	<cfset QuerySetCell(q_select_contact, 'criteria_displayvalue', a_str_criteria_displayvalue, 1) />
</cfif>

<!--- parentcompanyname ... --->
<cfif Len(q_select_contact.parentcontactkey) GT 0>
	
	<cfset a_str_criteria_displayvalue = '' />

	<cfset QuerySetCell(q_select_contact, 'parentcontactkey_displayvalue', q_select_parent_contact.company, 1) />
</cfif>

