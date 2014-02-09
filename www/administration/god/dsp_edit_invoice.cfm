<cfparam name="url.entrykey" type="string">


<!--- edit the invoice ... --->


<cfinvoke component="#request.a_str_component_billing#" method="GetBill" returnvariable="q_select_bill">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfoutput>
<h4>Rechnung Nummer #q_select_bill.invoicenumber# editieren</h4>
</cfoutput>

<!---<cfdump var="#q_select_bill#">--->

<cfoutput query="q_select_bill">
<table border="0" cellspacing="0" cellpadding="4">
<form action="act_edit_invoice.cfm" method="post">
<input type="hidden" name="frmentrykey" value="#url.entrykey#">
<input type="hidden" name="frmcompanykey" value="#url.companykey#">

  <tr>
    <td>Nummer:</td>
    <td>
		#q_select_bill.invoicenumber#
	</td>
  </tr>
  <tr>
    <td>Bezahlt:</td>
    <td>
		<input type="checkbox" name="frmpaid" value="1" #writecheckedelement(q_select_bill.paid, 1)#>
	</td>
  </tr>
  <tr>
    <td>Mahnstufe:</td>
    <td>
		<input disabled type="text" name="frmdunninglevel" value="#q_select_bill.DUNNINGLEVEL#" size="4">
	</td>
  </tr>
  <tr>
    <td>Faellig (Standard):</td>
    <td>
		<input disabled type="text" name="frmdt_due" value="#q_select_bill.DT_DUE#" size="30">
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="Speichern">
	</td>
  </tr>
</form>
</table>
</cfoutput>