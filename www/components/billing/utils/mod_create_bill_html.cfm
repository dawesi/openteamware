<!--- //

	Component:	Billing
	Function:	
	Description:Create the HTML for the billing ...
	

// --->
	

<cfparam name="attributes.invoicekey" type="string" default="">





<!--- load all open entries ... --->

<cfprocessingdirective pageencoding="ISO-8859-1">



<cfset SelectInvoiceRequest.entrykey = attributes.invoicekey>

<cfinclude template="queries/q_select_invoice.cfm">



<cfinvoke component="/components/management/customers/cmp_customer" method="GetCustomerData" returnvariable="q_select_customer">

	<cfinvokeargument name="entrykey" value="#q_select_invoice.companykey#">

</cfinvoke>

<cfset a_cmp_translation = application.components.cmp_lang>
<cfset iLangNo = q_select_customer.language>

<!--- load reseller data --->

<cfinvoke component="/components/management/resellers/cmp_reseller" method="LoadResellerData" returnvariable="q_select_reseller">

	<cfinvokeargument name="entrykey" value="#q_select_customer.resellerkey#">

</cfinvoke>



<cfinvoke component="/components/billing/cmp_billing" method="GetVatRateForCustomer" returnvariable="a_struct_vat_info">

	<cfinvokeargument name="entrykey" value="#q_select_invoice.companykey#">

</cfinvoke>



<cfset a_int_totalamount = 0>	



<cfsavecontent variable="a_str_content">

<html>

	<head>

		<style>

			td,body,p,none,div{font-family:Verdana,Arial;font-size:11px;}

		</style>

<!--- HEADER LEFT " " --->

<!-- HEADER LEFT "�sterreich<br>Kontonummer: 28977<br>" -->

<!-- FOOTER CENTER " " -->

<!-- HEADER CENTER " " -->

<!-- MEDIA TOP 5mm --> 

<!-- MEDIA LEFT 0mm --> 

<!-- FOOTER RIGHT "&nbsp;" -->

<!-- FOOTER LEFT " " -->		

		<META NAME="AUTHOR" CONTENT="Billing">


		<META NAME="SUBJECT" CONTENT="<cfoutput>#a_cmp_translation.GetLangValExt(langno = q_select_customer.language, entryid='adm_ph_billing_invoice_no')#</cfoutput> <cfoutput>#q_select_invoice.invoicenumber#</cfoutput>">		

		<title></title>

	</head>

<body>



<table width="100%" border="0" cellspacing="0" cellpadding="2">

  <tr>

    <td valign="top">

	

	<br><br><br><br><br><br>

	<!--- load company data ... --->
	
	<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td width="40px;">&nbsp;</td>
		<td nowrap>
		<font face="Arial">
	
		<cfoutput query="q_select_customer">
		
		<cfif Len(trim(q_select_customer.billingcontact)) GT 0>
			<!--- use the given address --->
			#ReplaceNoCase(q_select_customer.billingcontact, chr(13), '<br>', 'ALL')#
		<cfelse>
				
			<b>#htmleditformat(q_select_customer.companyname)#</b><br>
			#htmleditformat(q_select_customer.street)#<br>
			#htmleditformat(q_select_customer.zipcode)# #htmleditformat(q_select_customer.city)#<br>
		
			<cfinvoke component="/components/tools/cmp_tools" method="GetFullCountryNameFromISOCode" returnvariable="a_str_countryname">
				<cfinvokeargument name="isocode" value="#q_select_customer.countryisocode#">
			</cfinvoke>
		
			#htmleditformat(a_str_countryname)#
		</cfif>
	
		</cfoutput>
		</font>
		</td>
	
	</tr>
	</table>

	</td>

    <td valign="top" align="right">

	<!---<img src="http://securemail.openTeamware.com/images/logo-vorschlag.png"><br>---->

	<img src="http://localhost/images/img_inboxcc_logo_top.png"><br>

	<font face="Arial">

YOUR PARTNER

	<br>

	

	<!--- load reseller ... avaliable and not head company --->	

	<cfif (q_select_reseller.recordcount is 1) AND (q_select_reseller.entrykey neq "5872C37B-DC97-6EA3-E84EC482D29FC169")>

	<font size="-1"><cfoutput>#a_cmp_translation.GetLangValExt(langno = q_select_customer.language, entryid='adm_ph_billing_your_rep')#</cfoutput>:</font><br>

	<cfoutput>

	#htmleditformat(q_select_reseller.companyname)#<font size="-1">

	<br>

	#htmleditformat(q_select_reseller.emailadr)#</font>

	</cfoutput>

	</cfif>

	



	<br><br>

	<cfoutput>#a_cmp_translation.GetLangValExt(langno = q_select_customer.language, entryid='adm_ph_your_customer_id')#</cfoutput>: <cfoutput>#q_select_customer.customerid#</cfoutput>

	

	<cfif len(q_select_customer.uidnumber) gt 0>

	<br><cfoutput>#a_cmp_translation.GetLangValExt(langno = q_select_customer.language, entryid='adm_ph_your_uid_no')#</cfoutput>: <cfoutput>#q_select_customer.uidnumber#</cfoutput>

	</cfif>

	

	</font>

	</td>

  </tr>

</table>



<br><br>



<table width="100%" border="0" cellspacing="0" cellpadding="0">

  <tr>

    <td>
	
	<font face="Arial, Helvetica, sans-serif" size="4"><b><cfoutput>#a_cmp_translation.GetLangValExt(langno = q_select_customer.language, entryid='adm_ph_billing_invoice_no')#</cfoutput> <cfoutput>#q_select_invoice.invoicenumber#</cfoutput></b></font>

	</td>

    <td align="right">
	
	<cfset a_str_loc_date = a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_loc_date')>
	<cfset a_str_loc_date = ReplaceNoCase(a_str_loc_date, '%DATE%', dateformat(now(), "dd.mm.yy"))>

	<font face="Arial, Helvetica, sans-serif" size="-1"><cfoutput>#a_str_loc_date#</cfoutput></font>

	</td>

  </tr>

</table>



<font face="Arial" style="font-family:Verdana, Arial, Helvetica, sans-serif; " size="-1"><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_thank_you_positions')#</cfoutput>:</font>


<!-- %INVOICE_TABLE_START% -->

<table border="0" width="100%" cellspacing="0" cellpadding="3">
  <tr>
    <td  bgcolor="#EEEEEE" align="right" width="40" style="border-bottom:silver solid 1px;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase;background-color:white;">

	<font size="-1" face="Arial, Helvetica, sans-serif" style="font-family:Verdana, Arial, Helvetica, sans-serif;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase; "><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_amount')#</cfoutput></font>

	</td>

	<td bgcolor="#EEEEEE" style="border-bottom:silver solid 1px;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase;background-color:white;">&nbsp;</td>

    <td  bgcolor="#EEEEEE" style="border-bottom:silver solid 1px;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase;background-color:white;">

	<font face="Arial, Helvetica, sans-serif" size="-1" style="font-family:Verdana, Arial, Helvetica, sans-serif;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase; "><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_productname')#</cfoutput></font>

	</td>

	<td align="right"  bgcolor="#EEEEEE" style="border-bottom:silver solid 1px;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase;background-color:white;">

	<font face="Arial, Helvetica, sans-serif" size="-1" style="font-family:Verdana, Arial, Helvetica, sans-serif;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase; "><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_price')#</cfoutput></font>

	</td>

    <td  align="right" bgcolor="#EEEEEE" style="border-bottom:silver solid 1px;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase;background-color:white;">

	<font face="Arial, Helvetica, sans-serif" size="-1" style="font-family:Verdana, Arial, Helvetica, sans-serif;font-weight:bold;font-size:10px;color:gray;text-transform:uppercase; "><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_sum')#</cfoutput></font>

	</td>

  </tr>

  <cfloop index="a_Str_order_entrykey" list="#q_select_invoice.bookedservices#" delimiters=",">

  

  <cfset SelectBookedService.entrykey = a_Str_order_entrykey>

  <cfinclude template="queries/q_select_booked_service.cfm">

  

  <cfif q_select_booked_service.recordcount is 1>

	  <cfoutput>

	  <tr>

		<td valign="top" align="right">
			
			<font face="Arial" style="font-family:Verdana, Arial, Helvetica, sans-serif;">#q_select_booked_service.quantity#</font>
		
		</td>

		<td valign="top">

			<font face="Arial, Helvetica, sans-serif" style="font-family:Verdana, Arial, Helvetica, sans-serif;">#htmleditformat(q_select_booked_service.unit)#</font>

		</td>

		<td valign="top">

			<font face="Arial" style="font-family:Verdana, Arial, Helvetica, sans-serif;">#htmleditformat(q_select_booked_service.productname)#</font>

		<cfif len(q_select_booked_service.comment) gt 0>

			<br><font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;">#htmleditformat(q_select_booked_service.comment)#</font>

		</cfif>

		<!--- if ongoing ... --->

		</td>

		<cfset a_int_single_price = q_select_booked_service.totalamount / q_select_booked_service.quantity>

		<td valign="top" align="right">

		<font face="Arial"  style="font-family:Verdana, Arial, Helvetica, sans-serif;">#DecimalFormat(a_int_single_price)# #q_select_booked_service.currency#</font>

		</td>

		<td valign="top" align="right">

		<font face="Arial"  style="font-family:Verdana, Arial, Helvetica, sans-serif;">#DecimalFormat(q_select_booked_service.totalamount)# #q_select_booked_service.currency#</font></td>

	  </tr>

	  </cfoutput>

	  

	  <cfset a_int_totalamount = a_int_totalamount + val(q_select_booked_service.totalamount)>

  </cfif>

  </cfloop>

  <tr>

  	<td></td>

	<td colspan="4">

	<cfset a_str_text = a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_contract_end')>
	<cfset a_str_text = ReplaceNoCase(a_str_text, '%DATE%', dateformat(q_select_customer.dt_contractend, "dd.mm.yy"))>
	
	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;">  <cfoutput>#a_str_text#</cfoutput></font>

	</td>

  </tr>

  <tr>

    <td colspan="5"><hr size="0.5" noshade></td>

  </tr>

  <tr>

    <td colspan="4" align="right">

	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_sum_netto')#</cfoutput></font>

	</td>

    <td align="right">

	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><cfoutput>#DecimalFormat(a_int_totalamount)#</cfoutput> <cfoutput>#q_select_invoice.currency#</cfoutput></font>

	</td>

  </tr>

  <!--- do we have a var free invoice? --->

  <cfif a_struct_vat_info.rate is 0>

  	<cfset a_int_vat_percent = 0>

	<cfset a_int_vat_factor = 0>

  <cfelse>

  	<cfset a_int_vat_percent = 20>  

	<cfset a_int_vat_factor = 0.2>	

  </cfif>

  <tr>

  	<td colspan="4" align="right">
	
	
	<cfset a_str_text = a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_plus_vat')>
	<cfset a_str_text = ReplaceNoCase(a_str_text, '%VATRATE%', a_int_vat_percent)>

	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><cfoutput>#a_str_text#</cfoutput>:</font>

	</td>

	<td align="right">

	<cfset a_int_vat = a_int_totalamount * a_int_vat_factor>

	

	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><cfoutput>#DecimalFormat(a_int_vat)#</cfoutput> <cfoutput>#q_select_invoice.currency#</cfoutput></font>

	</td>

  </tr>

  <tr>

  	<td align="right" colspan="4">

	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><b><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_total_amount')#</cfoutput>:</b></font>

	</td>

	<td align="right">

	<cfset a_int_sum = a_int_vat + a_int_totalamount>

	<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><b><cfoutput>#DecimalFormat(a_int_sum)#</cfoutput> <cfoutput>#q_select_invoice.currency#</cfoutput></b></font>

	</td>

  </tr>

</table>



<br>

<font face="Arial, Helvetica, sans-serif"  style="font-family:Verdana, Arial, Helvetica, sans-serif;">
<cfset a_int_day_diff_whole_contract = DateDiff('d', Now(), q_select_customer.dt_contractend)>
<cfset a_int_day_diff_this_year = DateDiff('d', Now(), CreateDate(Year(now()), 12, 31))>

<cfset a_int_day = a_int_totalamount / a_int_day_diff_whole_contract>

<cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_share_this_year')#</cfoutput>: <cfoutput>#DecimalFormat(a_int_day * a_int_day_diff_this_year)#</cfoutput> EUR<br>
<cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_share_next_periods')#</cfoutput>: <cfoutput>#DecimalFormat(a_int_totalamount - (a_int_day * a_int_day_diff_this_year))#</cfoutput> <cfoutput>#q_select_invoice.currency#</cfoutput>
<br><br>
<b><cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_payment_conditions')#</cfoutput>:</b> <cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_payment_conditions_10_days')#</cfoutput><br>



<cfif Len(a_struct_vat_info.text) gt 0>

<font face="Arial, Helvetica, sans-serif" size="-1"  style="font-family:Verdana, Arial, Helvetica, sans-serif;"><cfoutput>#a_struct_vat_info.text#</cfoutput></font><br>

</cfif>

<cfif Len(Trim(q_select_invoice.comment)) GT 0>
	<br>
	<cfoutput>#a_cmp_translation.GetLangValExt(langno = iLangNo, entryid='adm_ph_billing_comments')#</cfoutput>: <cfoutput>#q_select_invoice.comment#</cfoutput>
</cfif>

<!-- %INVOICE_TABLE_END% -->


<br>
<br>
<br>

<cfinvoke component="#request.a_str_component_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="emails">
	<cfinvokeargument name="langno" value="#iLangNo#">
	<cfinvokeargument name="template_name" value="billing_payment_information">
</cfinvoke>

<cfinclude template="#a_str_page_include#">

</body>
</html> 
</cfsavecontent>

<!--- insert the html output into the table for later use ... --->
<cfinclude template="queries/q_update_billing_html_content.cfm">

<cfset caller.a_str_content = a_str_content>

