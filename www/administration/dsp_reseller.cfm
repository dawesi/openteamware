<!--- // 



	list resellers ...



	// --->

	

<h4></4>

<br>

<table border="0" cellspacing="0" cellpadding="4">

  <tr class="lightbg">

    <td colspan="2">Unternehmen</td>

    <td>Typ</td>

    <td>&nbsp;</td>

  </tr>

  <cfoutput query="q_select_reseller">

  <tr>

    <td>

	<cfif request.q_select_reseller.resellerlevel gt 0>

	<cfloop index="ii" from="1" to="#request.q_select_reseller.resellerlevel#">&nbsp;&nbsp;&nbsp;&nbsp;</cfloop>

	</cfif>

	&gt; <a <cfif request.q_select_reseller.contractingparty IS 0>style="color:silver"</cfif> href="default.cfm?action=resellerproperties&resellerkey=#urlencodedformat(request.q_select_reseller.entrykey)#"><b>#request.q_select_reseller.companyname#</b></a>

	</td>
	
	<td>&nbsp;
			
	</td>

    <td>
	
	<cfif request.q_select_reseller.issystempartner IS 1>
		Systempartner
	</cfif>
	
	<cfif request.q_select_reseller.isdistributor IS 1>
		Distributor
	</cfif>
	
	<cfif request.q_select_reseller.isprojectpartner IS 1>
		Projekt-Partner
	</cfif>		
	

	<!---<a href="default.cfm?action=resellerproperties&subaction=sales&resellerkey=#urlencodedformat(q_select_reseller.entrykey)#">Ums&auml;tze/Performance anzeigen</a>

	<cfif q_select_reseller.delegaterights is 1>

	&nbsp;|&nbsp;&nbsp;<a href="default.cfm?action=customers&resellerkey=#urlencodedformat(q_select_reseller.entrykey)#">Kundenverwaltung</a>

	</cfif>--->

	</td>

    <td>&nbsp;</td>

  </tr>

  </cfoutput>

</table>

<br>

<a href="default.cfm?action=reseller.new"><b>Neuen Reseller anlegen ...</b></a>