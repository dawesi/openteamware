<!--- //

	Module:		Billing
	Action:		
	Description:	
	

// --->
<cfcomponent output=false>

	<cfinclude template="/common/app/app_global.cfm">
	<cfinclude template="/common/scripts/script_utils.cfm">
	
	<cffunction access="public" name="GetHTMLBillingCoreContent" output="false" returntype="string" hint="return the html of the billing (core content)">
		<cfargument name="invoicekey" type="string" required="yes" hint="entrykey of invoice">
		
		<cfset var sReturn = ''>
		
		<cfinclude template="utils/inc_extract_core_html_content.cfm">
		
		<cfreturn sReturn>
	
	</cffunction>
	
	<cffunction access="public" name="UpdateLicencingInformation" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true"
			hint="entrykey of the company">
		
		<cfset var SelectOpenRecordsRequest = StructNew() />
		
		<!--- load open records ... --->
		<cfset SelectOpenRecordsRequest.companykey = arguments.entrykey>
		<cfinclude template="queries/q_select_open_records.cfm">
		
		<cfoutput query="q_select_open_records">
			<!--- add product --->
			
			<cfmodule template="utils/mod_update_licencing.cfm"
				companykey=#arguments.entrykey#
				productkey=#q_select_open_records.productkey#
				quantity=#q_select_open_records.quantity#>
			
		</cfoutput>
	
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetBill" output="false" returntype="query">
		<!---<cfargument name="companykey" type="string" required="true">--->
		<cfargument name="entrykey" type="string" required="true">
		
		<cfinclude template="queries/q_select_invoice.cfm">
		
		<cfreturn q_select_invoice>
	</cffunction>
	
	<cffunction access="public" name="CancelBill" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true">
		<cfargument name="reason" type="string" required="true">
		<cfargument name="cancelledbyuserkey" type="string" required="true">
		
		<cfinclude template="queries/q_update_bill_cancel.cfm">
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="GetBills" output="false" returntype="query">
		<cfargument name="companykey" type="string" required="true">
		<!---
		
			0 = open ... 1 = paid; -1 = all
			
			--->
		<cfargument name="type" type="numeric" default="-1" required="false">
		
		<cfinclude template="queries/q_select_invoices.cfm">
		
		<cfreturn q_select_invoices>
		
	</cffunction>
	
	<!--- dummy function, has to be enhances --->
	<cffunction access="public" name="AddToBasket" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="yes">
		<cfargument name="companykey" type="string" required="yes">
		<cfargument name="productkey" type="string" required="yes">
		<cfargument name="totalamount" type="numeric" required="yes">
		<cfargument name="productname" type="string" required="yes">
		<cfargument name="quantity" type="numeric" default="1" required="no">
		<cfargument name="unit" type="string" default="1" required="no">
		
		<cfinclude template="queries/q_insert_into_basket.cfm">
		
		<cfreturn true>
		
	</cffunction>
	
	<cffunction access="public" name="GetHighestAvailablePromocode" output="false" returntype="numeric">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfset var a_int_return = 0>
		
		<cfinclude template="queries/q_select_highest_available_promocode.cfm">
		
		<cfreturn a_int_return>
	</cffunction>
	
	<!--- return the percent number --->
	<cffunction access="public" name="GetAvailableKeyword" output="false" returntype="numeric">
		<cfargument name="companykey" type="string" required="yes">
		
		<cfinclude template="queries/q_select_available_keyword.cfm">
		
		<cfreturn val(q_select_available_keyword.percent)>
	</cffunction>
	
	<!---// Update the licence status without create an invoice //--->
	<cffunction access="public" name="UpdateLicenceStatusOnlyAndDoNotCreateAnInvoice" output="false" returntype="boolean">
		<cfargument name="companykey" 	type="string" 	required="yes" hint="entrykey of company">
		
		<cfset var tmp = false />
		<cfset var UpdateOpenRecordsRequest = StructNew() />
		
		<cfset UpdateLicencingInformation(entrykey = arguments.companykey)>
		
		<cfset UpdateOpenRecordsRequest.companykey = arguments.companykey>
		<cfinclude template="queries/q_update_open_records.cfm">		
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="CreateInvoiceFromOpenRecords" output="false" returntype="struct">
		<!--- the entrykey of the company ... --->
		<cfargument name="entrykey"		type="string"	default=""		required="true"		hint="entrykey of company">
		<!---
		
			bill or offert?
			
			--->
		<cfargument name="type" 		type="string" 	default="bill" 	required="true">
		<cfargument name="comment" 		type="string" 	default="" 		required="false">
		
		<!--- is this the very first bill or a renewal --->
		<cfargument name="renewal" 		type="boolean" 	default="false" required="false">
		
		<!--- invoicetype
			0 = normal bill; 1 = renewal --->
		<cfargument name="invoicetype" 	type="numeric" 	default="0" 	required="false">
		
		<!--- who has created this invoice?
			a) company itself = 0
			b) the servicepartner = 1
			c) automatically created = 2--->
		<cfargument name="createdbytype" type="boolean" required="false" default="false">
		 
		<!--- first of all ... check open promocodes ... --->
		<cfset var a_bol_add_basket = false />
		<cfset var a_int_promocode_value = 0 />
		<cfset var SelectOpenRecordsRequest = StructNew() />
		<cfset var a_struct_vat = StructNew() />
		<cfset var InsertInvoiceRequest = StructNew() />
		<cfset var stReturn = StructNew() />
		<cfset var UpdateOpenRecordsRequest = StructNew() />
		<cfset var a_bol_return = false />
		
		<cfset a_int_promocode_value = GetHighestAvailablePromocode(companykey = arguments.entrykey)>
		
		<cfif a_int_promocode_value GT 0>
			<!--- insert promocode ... --->
			<cfset a_bol_add_basket = AddToBasket(entrykey = CreateUUID(), companykey = arguments.entrykey, productkey = '49B0981E-FE3C-8006-A09B0FC1550981EA', productname = 'Promocode (NUR GUELTIG FUER LIZENZGEBUEHREN!)', totalamount = -a_int_promocode_value, unit = 'x', quantity = 1)>
		</cfif>
		
		<!--- load open records ... --->
		<cfset SelectOpenRecordsRequest.companykey = arguments.entrykey>
		<cfinclude template="queries/q_select_open_records.cfm">
		
		<!--- load VAT percent ... --->
		<cfset a_struct_vat = GetVatRateForCustomer(arguments.entrykey)>
		
		<!--- ok, here we go now ... --->
		<cfset InsertInvoiceRequest.Entrykey = CreateUUID()>
		<cfset InsertInvoiceRequest.companykey = arguments.entrykey>
		<cfset InsertInvoiceRequest.q_open_records = q_select_open_records>
		<cfset InsertInvoiceRequest.VATPercent = a_struct_vat.rate>
		
		<cfinclude template="queries/q_insert_invoice.cfm">
		
		
		<cfset stReturn.invoicenumber = a_str_invoice_number>
		<cfset stReturn.Entrykey = InsertInvoiceRequest.Entrykey>
		
		<cfif arguments.type is 'bill'>
			<!--- insert commission ... --->
			
			<cfinvoke component="/components/commission/cmp_commission" method="CreateCommissionItem" returnvariable="a_bol_return">
				<cfinvokeargument name="invoicekey" value="#InsertInvoiceRequest.Entrykey#">
				<cfinvokeargument name="invoicenumber" value="#a_str_invoice_number#">
				<cfinvokeargument name="companykey" value="#arguments.entrykey#">
			</cfinvoke>
			
			<cfif NOT arguments.renewal>
			
				<!--- update licence ... --->
				<cfinvoke component="cmp_billing" method="UpdateLicencingInformation" returnvariable="a_bol_return">
					<cfinvokeargument name="entrykey" value="#arguments.entrykey#">
				</cfinvoke>
			
			</cfif>
			
		</cfif>
		
		<!--- set records now to "closed", not open --->
		<!--- update records and set paid to 1 (...) --->
		<cfset UpdateOpenRecordsRequest.companykey = arguments.entrykey>
		<cfinclude template="queries/q_update_open_records.cfm">
		
		<cfreturn stReturn>
	
	</cffunction>
	
	<!--- return the number of open records ... --->	
	<cffunction access="public" name="GetOpenRecords" output="false" returntype="numeric">
		
		
		<cfreturn 0>
	</cffunction>
	
	<!--- return if this customer pays VAT or not --->
	<cffunction access="public" name="GetVatRateForCustomer" output="false" returntype="struct">
		<!--- entryid of the customer ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset var a_return_struct = StructNew() />
		
		<!--- load company data ... --->
		<cfset var cmp_customer = CreateObject("component", "/components/management/customers/cmp_customer") />
		
		<cfset var q_customer_data = cmp_customer.GetCustomerData(arguments.entrykey) />
		
		<cfif CompareNoCase(q_customer_data.countryisocode, "at") is 0>
			
				<!--- company/private from austria ... --->
				<cfset a_return_struct.rate = 20>
				<cfset a_return_struct.text = ''>
			
		<cfelseif (ListFindNoCase('de,uk,fi', q_customer_data.countryisocode) gt 0)
					AND
				  (Len(q_customer_data.uidnumber) gt 0)>
				  
				  <!--- EU with UID --->
				  <cfset a_return_struct.rate = 0>
				  <cfset a_return_struct.text = 'In Oesterreich nicht steuerbar gem. Paragraph 3a Abs.9 UStG'>

		<cfelseif (ListFindNoCase('de,uk,fi', q_customer_data.countryisocode) gt 0)
				  	AND
				  (Len(q_customer_data.uidnumber) is 0)>
				 
				 <!--- EU without UID Number --->
				  <cfset a_return_struct.rate = 20>
				  <cfset a_return_struct.text = ''>				  

		<cfelse>
				<!--- foreign country / customer ... --->
				  <cfset a_return_struct.rate = 0>
				  <cfset a_return_struct.text = 'In Oesterreich nicht steuerbar gem. Paragraph 3a Abs.9 UStG'>
		</cfif>
		
		
		<cfreturn a_return_struct>
	
	</cffunction>
	
	<!--- create the bill (pdf and html ... ) --->
	<cffunction access="public" name="CreateBillOutput" output="false" returntype="struct">
		<!--- entrykey of the invoice ... --->
		<cfargument name="entrykey" type="string" default="" required="true">
		
		<cfset var stReturn = StructNew()>
	
		<cfmodule template="utils/mod_create_bill_html.cfm" invoicekey=#arguments.entrykey#>
				
		<cfset stReturn.HTMLContent = a_str_content>
		<cfreturn stReturn>		
	</cffunction>
	
	<cffunction access="public" name="SendInvoiceByEmail" output="false" returntype="boolean">
		<cfargument name="entrykey" type="string" required="true" hint="entrykey of invoice">
		
		<cfreturn true>
	</cffunction>
	
	<!--- load and insert a PDF ... --->
	<cffunction access="public" name="SaveInvoicePDF" output="false" returntype="boolean">
		<!--- the invoice key ... --->
		<cfargument name="entrykey" type="string" required="true">
		<!--- the location of the PDF file --->
		<cfargument name="pdffilename" type="string" required="true">
		
		<cfset var q_update_invoice_pdf = 0 />
		<cfset var a_str_data = '' />
		
		<cffile action="readbinary" file="#pdffilename#" variable="a_str_data">
		
		<cfinclude template="queries/q_update_invoice_pdf.cfm">
		
		<cfreturn true>
	
	</cffunction>
	
	<cffunction access="public" name="GetTotalAmountOfBill" output="false" returntype="numeric">
		<cfargument name="entrykey" type="string" required="true">
		
		<!--- load invoice ... --->
		<cfinclude template="queries/q_select_invoice.cfm">
		
		<cfreturn q_select_invoice.invoicetotalsum>
	
	</cffunction>
	
	<cffunction access="public" name="SetInvoicePaid" output="false" returntype="boolean">
		<cfargument name="invoicekey" type="string" required="true">
		<cfargument name="method" type="string" required="true">
		<cfargument name="fraudalert" type="boolean" default="false" required="false">
		
		<cfset var q_select_invoice = 0 />
		<cfset var q_select_customer_data = 0 />
		
		<!--- update ... --->
		<cfinclude template="queries/q_update_bill_paid.cfm">
		
		<!---// check if we've got to call an affiliate code ... //--->
		<cfset q_select_invoice = GetBill(entrykey = arguments.invoicekey)>
		
		<!--- load company data ... --->
		<cfset q_select_customer_data = application.components.cmp_customer.GetCustomerData(entrykey = q_select_invoice.companykey)>
		
		<cfinclude template="utils/mod_check_affiliate.cfm">				
		
		<cfreturn true>
	</cffunction>
	
	<!--- update due date ... --->
	<cffunction access="public" name="ChangeDueDate" output="false" returntype="boolean">
		<cfargument name="invoicekey" type="string" required="true">
		<cfargument name="dt_due" type="date" required="true">
		
		<cfinclude template="queries/q_update_dt_due.cfm">
		
		<cfreturn true>
	</cffunction>
	
	<cffunction access="public" name="ChangeCreationDateOfFirstDunningLetter" output="false" returntype="boolean">
		<cfargument name="invoicekey" type="string" required="true">
		<cfargument name="dt" type="date" required="true">
		
		<cfinclude template="queries/q_update_creation_date_of_first_dunning_letter.cfm">
		
		<cfreturn true>
	</cffunction>

</cfcomponent>
