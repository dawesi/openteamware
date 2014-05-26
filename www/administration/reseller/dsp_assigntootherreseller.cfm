<!--- assign a customer to another reseller --->

<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.assigntoresellerkey" type="string" default="">


<cfif Len(url.assigntoresellerkey) IS 0>
<br>

<table border="0" cellspacing="0" cellpadding="4">



  <cfoutput query="q_select_reseller">
  <form action="index.cfm" method="get">
  <tr>
  	<input type="hidden" name="action" value="assigntootherreseller">
  	<input type="hidden" name="companykey" value="#url.companykey#">
	<input type="hidden" name="resellerkey" value="#url.resellerkey#">
	<input type="hidden" name="assigntoresellerkey" value="#q_select_reseller.entrykey#">

    <td class="bb">

	<cfif request.q_select_reseller.resellerlevel gt 0>

	<cfloop index="ii" from="1" to="#request.q_select_reseller.resellerlevel#">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>

	</cfif>

	<b>#htmleditformat(q_select_reseller.companyname)#</b>
	<br>
	

	<cfif Compare(url.resellerkey, q_select_reseller.entrykey) NEQ 0>
	<input type="submit" value="Transfer">
	</cfif>
	</td>

  </tr>
  </form>

  </cfoutput>

</table>
<cfelse>
		
	<!--- transfer --->
	Transfer completed.
	
	<cfinvoke component="/components/management/resellers/cmp_reseller" method="TransferCustomer" returnvariable="a_bol_return">
		<cfinvokeargument name="companykey" value="#url.companykey#">
		<cfinvokeargument name="newresellerkey" value="#url.assigntoresellerkey#">
	</cfinvoke>

</cfif>