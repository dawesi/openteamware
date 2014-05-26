

<cfinvoke component="/components/commission/cmp_commission" method="GetAllSales" returnvariable="q_select_all_sales">
	<cfinvokeargument name="resellerkey" value="#url.resellerkey#">
</cfinvoke>

<cfquery name="q_select_total_sum" dbtype="query">
SELECT
	SUM(q_select_all_sales.invoicetotalsum) AS total_sum
FROM
	q_select_all_sales
;
</cfquery>

<b>Umsaetze</b>

<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td align="right">Gesamt:</td>
    <td><cfoutput>#DecimalFormat(q_select_total_sum.total_sum)#</cfoutput> &euro;</td>
  </tr>
  <tr>
    <td align="right">&Oslash; pro Monat:</td>
    <td>
	
	<cfset a_int_months = DateDiff('m', request.q_select_reseller.dt_created, now())>
	
	<cfif a_int_months IS 0>
		<cfset a_int_months = 1>
	</cfif> 
	
	<cfset a_int_sales_per_day = val(q_select_total_sum.total_sum) / a_int_months>
	
	<cfoutput>#DecimalFormat(a_int_sales_per_day)#</cfoutput> &euro;
	</td>
  </tr>
  <tr>
    <td align="right">&Oslash; Umsatz/Kunde:</td>
    <td>
	<cftry>
	<cfoutput>#DecimalFormat(val(q_select_total_sum.total_sum) / q_select_companies.recordcount)#</cfoutput>
	<cfcatch></cfcatch>
	</cftry>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<b>Details zu den letzten Umsaetzen ...</b>

<table border="0" cellspacing="0" cellpadding="4">
  <tr bgcolor="#EEEEEE">
    <td class="bb">Kunde</td>
    <td class="bb">Umsatz</td>
    <td class="bb">Rechnungs-Nummer</td>
    <td class="bb">bezahlt?</td>
    <td class="bb">faellig</td>
    <td class="bb">&nbsp;</td>
  </tr>
  <cfoutput query="q_select_all_sales">
  <tr>
    <td>
	<cfinvoke component="/components/management/customers/cmp_customer" method="GetCustomerNameByEntrykey" returnvariable="a_str_company_name">
		<cfinvokeargument name="entrykey" value="#q_select_all_sales.companykey#">
	</cfinvoke>
	
	<a href="index.cfm?action=customerproperties&companykey=#htmleditformat(q_select_all_sales.companykey)#&resellerkey=#url.resellerkey#">#htmleditformat(a_str_company_name)#</a>
	</td>
    <td align="right">
	#q_select_all_sales.invoicetotalsum# &euro;
	</td>
    <td>
	#q_select_all_sales.invoicenumber#
	</td>
    <td>
	#q_select_all_sales.paid#
	</td>
    <td>
	#DateFormat(q_select_all_sales.dt_created, 'dd.mm.yy')#
	</td>
    <td>&nbsp;</td>
  </tr>
  </cfoutput>
</table>