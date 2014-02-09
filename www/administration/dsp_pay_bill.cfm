
<cfinclude template="dsp_inc_select_company.cfm">

<cfparam name="url.invoicekey" type="string" default="">

<cfparam name="url.method" type="string" default="moneytransfer">


<cfset SelectOpenInvoiceRequest.entrykey = url.invoicekey>
<cfinclude template="queries/q_select_open_invoice.cfm">


<cfswitch expression="#url.method#">
	
	<cfcase value="eps">
	<cfinclude template="billing/dsp_inc_pay_eps.cfm">
	</cfcase>
	
	<cfcase value="wp">
	<cfinclude template="billing/dsp_inc_pay_worldpay.cfm">
	</cfcase>
	
	<cfcase value="moneytransfer">
	<cfinclude template="billing/dsp_inc_pay_moneytransfer.cfm">
	</cfcase>
</cfswitch>