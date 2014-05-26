
<cfif request.a_bol_is_company_admin is false>
	<cfabort>
</cfif>



<h4>Verrechnung</h4>


<cfif (request.q_company_admin.recordcount gt 1) AND (StructKeyExists(url, "companykey") is false)>
	<!--- display list ... --->
	<form action="index.cfm" method="get">
	<input type="hidden" name="action" value="billing">
	
	<select name="companykey">
		<cfoutput query="request.q_company_admin">
		<option value="#htmleditformat(request.q_company_admin.companykey)#">#htmleditformat(request.q_company_admin.companyname)#</option>
		</cfoutput>
	</select>
	<input type="submit"  value="Anzeigen ...">
	</form>
	<cfexit method="exittemplate">
</cfif>



<cfset url.companykey = request.q_company_admin.companykey>

<cfquery name="q_select_company" dbtype="query">
SELECT * FROM request.q_company_admin
WHERE companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">;
</cfquery>


<cfset SelectInvoicesRequest.companykey = url.companykey>
<cfinclude template="queries/q_select_open_invoices.cfm">

<cfif q_select_open_invoices.recordcount is 0>
	<b>Keine offenen Rechnungen</b>
	<cfexit method="exittemplate">
</cfif>

<b><cfoutput>#q_select_open_invoices.recordcount#</cfoutput> offene Rechnungen</b>
<table border="0" cellspacing="0" cellpadding="8">
  <tr class="lightbg">
    <td>Rechnungsnummer</td>
    <td>bestellt</td>
    <td>Summe</td>
	<td>&nbsp;</td>
  </tr>
  <cfoutput query="q_select_open_invoices">
  <tr>
  	<td>#q_select_open_invoices.invoicenumber#</td>
  	<td>#q_select_open_invoices.dt_created#</td>
	<td>#q_select_open_invoices.invoicetotalsum# &euro;</td>
	<td>
	
	<a href="index.cfm?action=accounting">Details ...</a>
	</td>
  </tr>
  </cfoutput>
</table>

<br>
<br>
<b>Bitte waehlen Sie die gewuenschte Zahlungsmethode:</b>
<table border="0" cellspacing="0" cellpadding="8">
  <tr>
    <td>&nbsp;</td>
    <td>
	<b><a href="index.cfm?action=paybill&method=transfer&invoicekey=<cfoutput>#urlencodedformat(q_select_open_invoices.entrykey)#</cfoutput>">&Uuml;berweisung</a></b>
	</td>
  </tr>
  <cfif q_select_company.countryisocode is "at">
  <tr>
    <td>&nbsp;</td>
    <td>
	<b><a href="index.cfm?action=paybill&method=eps&invoicekey=<cfoutput>#urlencodedformat(q_select_open_invoices.entrykey)#</cfoutput>">Telebanking (EPS)</a></b>
	</td>
  </tr>
  <cfelse>
  <tr>
  	<td>&nbsp;</td>
	<td>
	Telebanking (EPS) - leider nicht verfuegbar
	</td>
  </tr>
  </cfif>
  
  <cfif q_select_company.countryisocode is "de">
  <tr>
    <td>&nbsp;</td>
    <td>
	Lastschrift
	</td>
  </tr>
  <cfelse>
  <tr>
  	<td>&nbsp;</td>
	<td>Lastschrift - leider nur in D verf&uuml;gbar</td>
  </tr>
  </cfif>
  <tr>
    <td>&nbsp;</td>
    <td>
	Kreditkarte
	</td>
  </tr>
</table>