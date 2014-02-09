<!--- //

	Module:		Admintool
	action:		crm
	Description:enable crm database ...
	
// --->
	
<cfinvoke component="#application.components.cmp_crmsales#" method="GetCRMSalesBinding" returnvariable="a_struct_crmsales_bindings">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfif Len(a_struct_crmsales_bindings.ADDITIONALDATA_TABLEKEY) GT 0>
	already activated
	<cfexit method="exittemplate">
</cfif>

<cfset SelectCustomerContacts.entrykey = url.companykey />
<cfinclude template="../queries/q_select_customer_contacts.cfm">

<cfset SelectCompanyUsersRequest.companykey = url.companykey />
<cfinclude template="../queries/q_select_company_users.cfm">

<!--- use the first admin ... --->
<cfset a_str_userkey = q_select_customer_contacts.userkey />

<cfset a_cmp_database = CreateObject('component', request.a_str_component_database) />
<cfset sEntrykey_database = CreateUUID() />
<cfset sEntrykey_additional_data = CreateUUID() />

<!--- create securitycontext and usersettings (of admin) --->
<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stSecurityContext">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stUserSettings">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<cfinvoke
	component = "#a_cmp_database#"   
	method = "CreateDatabase"   
	returnVariable = "stReturn"   
	securitycontext="#stSecurityContext#"
	usersettings="#stUserSettings#"
	database_name="crmsales"
	database_description=""
	entrykey="#sEntrykey_database#">
</cfinvoke>
	
<cfdump var="#stReturn.result#">
	
<cfset sEntrykey_database = stReturn.entrykey />

<!--- additional data --->
<cfinvoke
	returnvariable="stReturn"
	component = "#a_cmp_database#"   
	method = "CreateTable"   
	securitycontext="#stSecurityContext#"
	usersettings="#stUserSettings#"
	table_name="additionaldata"
	table_description=""
	entrykey="#sEntrykey_additional_data#"
	database_entrykey="#sEntrykey_database#"
	template_tabletype = "crm_additionaldata">
</cfinvoke>
	
<cfdump var="#stReturn.result#">
	
<!--- update mapping ... --->
<cfinvoke component="#application.components.cmp_crmsales#" method="SetCRMSalesBinding" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="securitycontext" value="#session.stSecurityContext#">
	<cfinvokeargument name="databasekey" value="#sEntrykey_database#">
	<cfinvokeargument name="additionaldata_tablekey" value="#sEntrykey_additional_data#">
	<cfinvokeargument name="USERKEY_DATA" value="">
</cfinvoke>

<h4><cfoutput>#GetLangVal('cm_ph_action_executed_successfully')#</cfoutput></h4>

