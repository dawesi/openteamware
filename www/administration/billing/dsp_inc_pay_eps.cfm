
<h4>Bezahlen per EPS</h4>

<cfset a_str_random_key = CreateUUID()>

<cfinvoke component="/components/billing/eps/cmp_eps" method="GetEPSSessionID" returnvariable="stReturn">
	<cfinvokeargument name="uniqueid" value="#a_str_random_key#">
	<cfinvokeargument name="orderid" value="Rechnung #q_select_open_invoice.invoicenumber#">
	<cfinvokeargument name="amount" value="#Int(q_select_open_invoice.invoicetotalsum_gross)#">
</cfinvoke>

<cfset a_str_session_id = stReturn["session_id"]>
<!---<cfdump var="#stReturn#">--->


<script type="text/javascript">
	function OpenEPS()
		{
		location.href = "https://banking.raiffeisen.at/html/service;jsessionid=<cfoutput>#trim(a_str_session_id)#</cfoutput>?smi.lib=paycontinue";
		}
</script>

<form method="post" name="formeps" action="https://banking.raiffeisen.at/html/service;jsessionid=<cfoutput>#trim(a_str_session_id)#</cfoutput>?smi.lib=paycontinue" target="_blank">
<input type="submit" name="frmSubmit" value="<cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput>">
</form>

<script type="text/javascript">
	document.formeps.submit();
</script>