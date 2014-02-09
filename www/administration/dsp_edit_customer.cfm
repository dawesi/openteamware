<!--- //

	edit a customer ...
	
	// --->

<cfinclude template="dsp_inc_select_company.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfif q_select_company_data.recordcount is 0>
	no such company found
	<cfexit method="exittemplate">
</cfif>
	
<h4><cfoutput>#GetLangVal('adm_ph_edit_customer')#</cfoutput> (<cfoutput>#q_select_company_data.companyname#</cfoutput>)</h4>

<cfset CreateorEditCustomer.Query = q_select_company_data>
<cfset CreateOrEditCustomer.Formaction = "act_edit_customer.cfm">
<cfset CreateOrEditCustomer.action = "edit">
<cfinclude template="dsp_inc_edit_or_create_customer.cfm">