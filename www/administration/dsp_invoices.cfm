
<cfinclude template="dsp_inc_select_company.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">

<cfif (q_select_company_data.settlement_type NEQ 0) AND NOT (request.a_bol_is_reseller)>
	<!--- this customer is not allwed to order in the shop, has to order at the reseller --->
	
	<!--- check if shop url has been provided ... --->
	<cfset a_struct_links = application.components.cmp_customize.GetCustomStyleData(entryname = 'links', usersettings = session.stUserSettings)>

	<cfset a_str_shop_url = a_struct_links.shop>
	
	<cfif Len(a_str_shop_url) IS 0>
		<!--- forward to feedback form ... --->
		<cflocation addtoken="no" url="default.cfm?action=partnerfeedbackform&reason=shop">		
	<cfelse>
		<h4><a target="_blank" href="<cfoutput>#a_str_shop_url#</cfoutput>">Bitte klicken Sie hier um den Shop zu oeffnen ...</a></h4>
	</cfif>
	
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="/components/billing/cmp_billing" method="GetBills" returnvariable="q_select_invoices">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfquery name="q_select_open_invoices" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	paid = 0
	AND
	cancelled = 0
;
</cfquery>

<cfquery name="q_select_paid_invoices" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	paid = 1
	AND
	cancelled = 0
;
</cfquery>

<!---<cfdump var="#q_select_invoices#">--->

<h4>Verrechnung &amp; Archiv</h4>


<!---

	generate bill

--->

<fieldset>
	<legend><b>Offene Rechnungen (<cfoutput>#q_select_open_invoices.recordcount#</cfoutput>)</b></legend>


<table border="0" cellspacing="0" cellpadding="8">
  <tr bgcolor="#EEEEEE">
    <td>Rechnungsnummer</td>
    <td>erstellt</td>
	<td>faellig</td>
	<td>Mahnstufe</td>
    <td align="right">Summe (Netto)</td>
	<td align="right">Summe (Brutto)</td>
    <td>&nbsp;</td>
  </tr>
  <cfoutput query="q_select_open_invoices">
  <tr>
    <td align="center">
		<b>#q_select_open_invoices.invoicenumber#</b>
	</td>
    <td>
		#lsdateformat(q_select_open_invoices.dt_created, 'dd.mm.yy')#		
	</td>
	<td>
		<cfset a_int_days_diff = DateDiff('d', q_select_open_invoices.dt_created, Now())>
		
		<cfif a_int_days_diff LT 10>
		
			<cfset a_dt_due = DateAdd('d', 10, q_select_open_invoices.dt_created)>
			
			#DateFormat(a_dt_due, 'dd.mm.yy')#
			
		<cfelse>
			<b style="color:red;">ueberfaellig</b>
		</cfif>
	</td>
	<td>
		#q_select_open_invoices.dunninglevel#
	</td>
    <td align="right">
		#DecimalFormat(q_select_open_invoices.invoicetotalsum)# EUR
	</td>
    <td align="right">
		#DecimalFormat(q_select_open_invoices.invoicetotalsum_gross)# EUR
	</td>	
    <td>&nbsp;</td>
  </tr>
  <tr>
  	<td align="center" class="bb">
		<a target="_blank" href="tools/dl_invoice.cfm?entrykey=#urlencodedformat(q_select_open_invoices.entrykey)##WriteURLTags()#">#si_img('page_white_acrobat')#
		<br />
		anzeigen</a>
	</td>
	<td colspan="4" class="bb">
		bezahlen via <a href="default.cfm?action=paybill&method=wp#WriteURLTags()#&invoicekey=#q_select_open_invoices.entrykey#">Kreditkarte/ELV</a> | <a href="default.cfm?action=paybill&method=moneytransfer#WriteURLTags()#&invoicekey=#q_select_open_invoices.entrykey#">Ueberweisung</a> <!--- | <a href="default.cfm?action=paybill&method=eps#WriteURLTags()#&invoicekey=#q_select_open_invoices.entrykey#">EPS (Telebanking)</a> --->
	</td>
  </tr>
  </cfoutput>
</table>
</fieldset>

<br><br>

<fieldset>
	<legend>Archiv</legend>
<div><br>
<br>

<table border="0" cellspacing="0" cellpadding="8">
  <tr>
    <td class="addinfotext bb bt">Rechnungsnummer</td>
    <td class="addinfotext bb bt">erstellt</td>
    <td class="addinfotext bb bt" align="right">Summe (netto)</td>
    <td class="addinfotext bb bt">&nbsp;</td>
  </tr>
  <cfoutput query="q_select_paid_invoices">
  <tr>
    <td align="center">
	<a target="_blank" href="tools/dl_invoice.cfm?entrykey=#urlencodedformat(q_select_paid_invoices.entrykey)##WriteURLTags()#">#si_img('page_white_acrobat')# anzeigen ...</a> <b>#q_select_paid_invoices.invoicenumber#</b>
	</td>
    <td>
		#lsdateformat(q_select_paid_invoices.dt_created, 'dd.mm.yy')#
	</td>
    <td align="right">
		#DecimalFormat(q_select_paid_invoices.invoicetotalsum)# EUR
	</td>
    <td>&nbsp;</td>
  </tr>
  </cfoutput>
</table>
</div>
</fieldset>
<br><br>
<font class="addinfotext">Unterstuetzte Zahlungsformen:</font><br>
	<img src="/images/shop/card_logos.gif" align="absmiddle"> / ELV / EPS / <b>Ueberweisung (Deutsches &amp; &ouml;sterreichisches Konto)</b>

