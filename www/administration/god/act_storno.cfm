<!--- //

	storno
	
	// --->
<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="#request.a_str_component_billing#" method="GetBill" returnvariable="q_select_bill">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfoutput>
<h4>Rechnung Nummer #q_select_bill.invoicenumber# stornieren</h4>
</cfoutput>

<cfif IsDefined('url.reason')>

	<!--- do storno ... --->
	<cfinvoke component="#request.a_str_component_billing#" method="CancelBill" returnvariable="a_bol_return">
		<cfinvokeargument name="entrykey" value="#url.entrykey#">
		<cfinvokeargument name="reason" value="#url.reason#">
		<cfinvokeargument name="cancelledbyuserkey" value="#request.stSecurityContext.myuserkey#">
	</cfinvoke>
	
	Storno wurde durchgef�hrt.
<cfelse>
	
	<form action="act_storno.cfm" method="get">
		<input type="hidden" name="entrykey" value="<cfoutput>#url.entrykey#</cfoutput>">
		<input type="hidden" name="companykey" value="<cfoutput>#url.companykey#</cfoutput>">
		Grund: <input type="text" name="reason" size="40">
		&nbsp;
		<input type="submit" value="Stornieren">
	</form>

</cfif>