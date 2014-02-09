<cfprocessingdirective pageencoding="ISO-8859-1">

<cfinvoke component="/components/billing/cmp_billing" method="GetBill" returnvariable="q_select_invoices">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="entrykey" value="#url.invoicekey#">
</cfinvoke>

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<h4><cfoutput>#GetLangVal('adm_ph_billing_pay_per_transfer')#</cfoutput></h4>


<b><cfoutput>#GetLangVal('adm_ph_billing_pay_per_transfer_description')#</cfoutput></b>
<br><br>
<div style="border:darkred solid 1px;padding:6px;background-color:orange;width:300px;">
<b>
<cfoutput>#GetLangVal('adm_ph_billing_invoice_number')#</cfoutput>: <cfoutput>#q_select_invoices.invoicenumber#</cfoutput>
<br>
<cfoutput>#GetLangVal('adm_ph_billing_customer_number')#</cfoutput>: <cfoutput>#q_select_company_data.customerid#</cfoutput>
</b>
</div>
<br>
<br>
<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="admintool">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="billing_banktransfer_account_data">
</cfinvoke>

<cfinclude template="#a_str_page_include#">