<h4>Rechnungen</h4>
<!---
<cfquery name="q_select_invoices">
SELECT
	invoicenumber,
	companykey,
	dt_created,
	entrykey,
	dt_due
FROM
	invoices
;
</cfquery>

<cfdump var="#q_select_invoices#">

<cfloop query="q_select_invoices">
	
	<cfset a_dt_due = DateAdd('d', 10, q_select_invoices.dt_created)>

	<cfquery name="q_update">
	UPDATE
		invoices
	SET
		dt_due = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_due)#">
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_invoices.entrykey#">
	;
	</cfquery>

</cfloop>--->
<cfif IsDefined("url.frmshowcustomer")>
	<!--- check the customerid --->
	<cfquery name="q_select_companykey">
	SELECT
		entrykey
	FROM
		companies
	WHERE
		customerid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(url.frmcustomerid)#">
	;
	</cfquery>
</cfif>

<cfquery name="q_select_invoices">
SELECT
	invoicenumber,
	companykey,
	dt_created,
	entrykey,
	paid,
	dt_due,
	invoicetotalsum,
	invoicevatpercent,
	comment,
	dunninglevel,
	cancelled
FROM
	invoices
WHERE
	(1=1)
<cfif IsDefined("url.frmshowcancelled")>
	AND
	(cancelled = 1)	
<cfelse>
	AND
	(cancelled = 0)
</cfif>	
<cfif IsDefined("url.frmshownotpaid")>
	AND
	(paid = 0)
</cfif>
<cfif IsDefined("url.frmshowoverdue")>
	AND
	(paid = 0)
	AND
	(dt_due <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">)
</cfif>
<cfif IsDefined('url.frmdunninglevel1')>
	AND
	(dunninglevel = 1)
	AND
	(paid = 0)
</cfif>
<cfif IsDefined('url.frmdunninglevel2')>
	AND
	(dunninglevel = 2)
	AND
	(paid = 0)	
</cfif>
<cfif IsDefined("url.frmshowpaid")>
	AND
	(paid = 1)
</cfif>
<cfif IsDefined("url.frmshowinvoice")>
	AND
	(invoicenumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.frminvoiceid#">)
</cfif>
<cfif IsDefined("url.frmshowcustomer")>
	AND
	(companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_companykey.entrykey#">)
</cfif>
ORDER BY
	id
;
</cfquery>

<form action="index.cfm">
<input type="hidden" name="action" value="invoices">

		<input type="submit" name="frmshownotpaid" value="Unbezahlte Rechnungen anzeigen">
		<br>
		<input type="submit" name="frmshowoverdue" value="&Uuml;berf&auml;llige Rechnungen anzeigen (alle)">
		<br>
		<input type="submit" name="frmdunninglevel1" value="&Uuml;berf&auml;llige Rechnungen anzeigen (Mahnstufe 1)">
		<br>
		<input type="submit" name="frmdunninglevel2" value="&Uuml;berf&auml;llige Rechnungen anzeigen (Mahnstufe 2)">
		<br>
		<input type="submit" name="frmshowcancelled" value="Stornierte Rechnungen anzeigen">
		<br>		
		<input type="submit" name="frmshowpaid" value="Bezahlte Rechnungen anzeigen">
		<br>
		Rechnungsnummer anzeigen: <input type="text" name="frminvoiceid" size="10"> <input type="submit" value="Anzeigen" name="frmshowinvoice">
		<br>
		Kundennummer anzeigen: <input type="text" name="frmcustomerid" size="10"> <input type="submit" value="Anzeigen" name="frmshowcustomer">
</form>
<br>
<cfoutput>#q_select_invoices.recordcount#</cfoutput> Treffer

<table border="0" cellspacing="0" cellpadding="5">
  <tr bgcolor="#CCCCCC">
    <td>Nummer</td>
    <td>erstellt</td>
	<td>f&auml;llig</td>
	<td>Mahnstufe</td>
    <td>Kunde</td>
    <td>bezahlt?</td>
	<td>Anmerkung</td>
    <td>Summe (netto)</td>
    <td>PDF</td>
  </tr>
  <cfoutput query="q_select_invoices">
  

	<cfquery name="q_select_company">
	SELECT
		companyname,resellerkey,entrykey
	FROM
		companies
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_invoices.companykey#">
	;
	</cfquery>
	  
  <tr>
    <td class="bb">
	#q_select_invoices.invoicenumber#
	</td>
    <td class="bb">
	#lsdateformat(q_select_invoices.dt_created, 'dd.mm.yy')#
	</td>
	<td class="bb">
	#lsdateformat(q_select_invoices.dt_due, 'dd.mm.yy')#
	<cfif q_select_invoices.dunninglevel IS 0> [<a href="act_edit_dt_due.cfm?entrykey=#urlencodedformat(q_select_invoices.entrykey)#&companykey=#q_select_invoices.companykey#">edit</a>]</cfif>
	<cfif q_select_invoices.dunninglevel IS 1> [<a href="act_edit_dt_due_dunning1.cfm?entrykey=#urlencodedformat(q_select_invoices.entrykey)#&companykey=#q_select_invoices.companykey#">edit</a>]</cfif>	
	<cfif q_select_invoices.dunninglevel IS 2> [<a href="index.cfm?action=editinvoice&companykey=#q_select_company.entrykey#&entrykey=#urlencodedformat(q_select_invoices.entrykey)#">editieren</a>]</cfif>
	</td>

	<td class="bb" align="center" <cfif q_select_invoices.dunninglevel IS 1>bgcolor="##FFCC66"</cfif> <cfif q_select_invoices.dunninglevel IS 2>bgcolor="##FF6633"</cfif>>
	#q_select_invoices.dunninglevel#
	</td>
    <td class="bb">
	
	<a href="../index.cfm?action=customerproperties&companykey=#q_select_company.entrykey#&resellerkey=#q_select_company.resellerkey#" target="_blank">#CheckZeroString(q_select_company.companyname)#</a>
	
	</td>
    <td align="center" class="bb">
	#YesNoFormat(q_select_invoices.paid)#
	</td>
	<td class="bb">
	#q_select_invoices.comment#&nbsp;
	</td>
    <td align="right" class="bb">
	#DecimalFormat(q_select_invoices.invoicetotalsum)#
	</td>
    <td class="bb">
	<a href="dl_invoice.cfm?entrykey=#urlencodedformat(q_select_invoices.entrykey)#" target="_blank">anzeigen ...</a>
	&nbsp;&nbsp;
	<cfif q_select_invoices.paid IS 0>
		<a href="index.cfm?action=setinvoicepaid&entrykey=#urlencodedformat(q_select_invoices.entrykey)#">bezahlt setzen</a>
		&nbsp;
		<a href="act_storno.cfm?entrykey=#urlencodedformat(q_select_invoices.entrykey)#&companykey=#q_select_company.entrykey#">stornieren</a>
	<cfelse>
		<a href="index.cfm?action=editinvoice&companykey=#q_select_company.entrykey#&entrykey=#urlencodedformat(q_select_invoices.entrykey)#">editieren</a>
	</cfif>
	</td>
  </tr>
  </cfoutput>
</table>