<!--- //

	return to this page
	
	// --->
	
<cfinvoke component="/components/billing/cmp_billing" method="GetBill" returnvariable="q_select_invoices">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="entrykey" value="#url.invoicekey#">
</cfinvoke>

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfset sEntrykey = CreateUUID()>

	
<h4><cfoutput>#GetLangVal('adm_ph_billing_pay_per_cc')#</cfoutput></h4>

<form action="https://select.worldpay.com/wcc/transaction" method=POST name="formwp">
<input type=hidden name="instId" value="55372">
<input type=hidden name="authMode" value="A">
<input type=hidden name="cartId" value="<cfoutput>#htmleditformat(url.invoicekey)#</cfoutput>">
<input type=hidden name="amount" value="<cfoutput>#htmleditformat(q_select_invoices.invoicetotalsum_gross)#</cfoutput>">
<input type=hidden name="currency" value="EUR">
<input type=hidden name="desc" value="openTeamWare.com <cfoutput>#GetLangVal('adm_wd_invoice')#</cfoutput> <cfoutput>#q_select_invoices.invoicenumber#</cfoutput>">

<!--- insert a temporary entry --->
<input type=hidden name="MC_orderid" value="<cfoutput>#htmleditformat(url.invoicekey)#</cfoutput>">
<input type="hidden" name="MC_producttype" value="1000">

<input type=hidden name="email" value="<cfoutput>#htmleditformat(q_select_company_data.email)#</cfoutput>">
<input type=hidden name="name" value="<cfoutput>#htmleditformat(q_select_company_data.companyname)#</cfoutput>">
<input type=hidden name="address" value="<cfoutput>#htmleditformat(q_select_company_data.street&chr(13)&chr(10)&q_select_company_data.zipcode&' '&q_select_company_data.city&chr(13)&chr(10)&q_select_company_data.country)# </cfoutput>">
<input type=hidden name="postcode" value="<cfoutput>#htmleditformat(q_select_company_data.zipcode)#</cfoutput>">
<input type=hidden name="country" value="<cfoutput>#q_select_company_data.country#</cfoutput>">
<input type=hidden name="tel" value="<cfoutput>#htmleditformat(q_select_company_data.telephone)#</cfoutput>">

<input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('adm_ph_billing_connect_to_payment_server')#</cfoutput>">
</form>
