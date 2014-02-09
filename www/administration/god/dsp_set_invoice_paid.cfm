<cfparam name="url.entrykey" type="string" default="">

<cfif cgi.REQUEST_METHOD IS 'POST'>

<!--- set paid --->


				<cfinvoke component="/components/billing/cmp_billing" method="SetInvoicePaid" returnvariable="a_bol_return">
					<cfinvokeargument name="invoicekey" value="#url.entrykey#">
					<cfinvokeargument name="method" value="#form.frmmethod#">
				</cfinvoke>
Done.
<cfelse>

<form action="<cfoutput>#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#</cfoutput>" method="POST">
Methode: <input type="text" name="frmmethod" value="Rechnung">&nbsp;&nbsp;
<input type="submit" value="Speichern">
</form>

</cfif>