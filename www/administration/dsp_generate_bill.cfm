<!--- //
	create a bill ...
	// --->
	
<cfinclude template="dsp_inc_select_company.cfm">
	
<cfparam name="url.frmcomment" type="string" default="">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfinvoke component="/components/management/customers/cmp_customer" method="IsUserCompanyAdmin" returnvariable="a_bol_return_is_company_admin">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<h4><cfoutput>#GetLangVal('adm_ph_shop_order_finished')#</cfoutput></h4>

<!--- check if we now have to set a contract end (none set until now?) --->
<cfinvoke component="/components/management/customers/cmp_customer" method="GetCustomerData" returnvariable="q_select_customer">
	<cfinvokeargument name="entrykey" value="#url.companykey#">
</cfinvoke>

<cfif isDate(q_select_customer.dt_contractend) is false>
	<!--- set new contract end for --->
	<!--- ONE year from now on ... --->
	<cfset a_dt_contract_end = DateAdd("yyyy", 1, now())+1>
	
	<!--- attention if settlement_type > 0 ... --->
	
	<cfinvoke component="/components/management/customers/cmp_customer" method="SetContractEnd">
		<cfinvokeargument name="entrykey" value="#url.companykey#">
		<cfinvokeargument name="contractend" value="#a_dt_contract_end#">	
	</cfinvoke>

</cfif>

<cfif q_select_company_data.settlement_type IS 1>
	<!--- just update the licence status, do NOT generate a bill ... --->
	
	<cfinvoke component="/components/billing/cmp_billing" method="UpdateLicenceStatusOnlyAndDoNotCreateAnInvoice" returnvariable="a_bol_return">
		<cfinvokeargument name="companykey" value="#url.companykey#">
	</cfinvoke>
	
	
	<cfoutput>#GetLangVal('adm_ph_licence_status_updated')#</cfoutput>

<cfelse>
	<!--- default ... create invoice, mail it to customer and so on ... --->
	
	<!--- create the invoice record ... --->
	<cfinvoke component="/components/billing/cmp_billing" method="CreateInvoiceFromOpenRecords" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#url.companykey#">
		<cfinvokeargument name="type" value="bill">
		<cfinvokeargument name="comment" value="#url.frmcomment#">
		<cfinvokeargument name="invoicetype" value="0">
		<!--- who has created this bill? --->
		<cfif a_bol_return_is_company_admin>
			<!--- company admin? --->
			<cfinvokeargument name="createdbytype" value="0">
		<cfelse>
			<!--- service partner --->
			<cfinvokeargument name="createdbytype" value="1">
		</cfif>
	</cfinvoke>
	
	<cfset a_str_invoicenumber = stReturn.invoicenumber>
	<cfset a_str_invoicekey = stReturn.entrykey>
	
	<cfinvoke component="/components/billing/cmp_billing" method="CreateBillOutput" returnvariable="stReturn">
		<cfinvokeargument name="entrykey" value="#stReturn.entrykey#">
	</cfinvoke>
	
	<cfinvoke component="/components/tools/cmp_pdf" method="CreatePDFofHTMLContent" returnvariable="sFilename">
		<cfinvokeargument name="htmlcontent" value="#stReturn.htmlcontent#">
	</cfinvoke>
	
	<!--- save this PDF file online for the user ... --->
	<cfinvoke component="/components/billing/cmp_billing" method="SaveInvoicePDF" returnvariable="a_bol_return">
		<cfinvokeargument name="pdffilename" value="#sFilename#">
		<cfinvokeargument name="entrykey" value="#a_str_invoicekey#">
	</cfinvoke>
	
	<cfif q_select_customer.status IS 1>
		<!--- customer was in trial phase ... update now the accounts in the way the user has selected it to do --->
		
		<cfinclude template="utils/inc_update_trial_accounts_types.cfm">
		
	</cfif>
	
	<hr>
	<br>
	<cfoutput>#GetLangVal('adm_ph_shop_thank_your_for_your_order')#</cfoutput>
	<br><br>
	<cfoutput>#GetLangVal('adm_ph_shop_thank_your_for_your_order_2')#</cfoutput>
	<br><br>
	<br><br><br>
	<a href="default.cfm?action=invoices&<cfoutput>#WriteURLTags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_shop_goto_invoices')#</cfoutput></a>
	
	<cfset request.a_cmp_lang = application.components.cmp_lang>
	
	<!--- mail invoice to customer ... --->
	<cfinvoke component="#request.a_cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_include_path">
		<cfinvokeargument name="langno" value="#client.langno#">
		<cfinvokeargument name="section" value="emails">
		<cfinvokeargument name="template_name" value="billing_autoorder_text">
	</cfinvoke>
	
	<cftry>
	<cfmail charset="utf-8" to="#q_select_customer.email#" bcc="#request.appsettings.properties.NotifyEmail#" from="openTeamWare.com Billing <office@openTeamWare.com>" subject="Rechnung ###a_str_invoicenumber#" mimeattach="#sFilename#">
	<cfinclude template="#a_str_include_path#">
	</cfmail>
	<cfcatch type="any"> </cfcatch></cftry>

</cfif>