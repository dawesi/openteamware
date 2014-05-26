<cfinclude template="../dsp_inc_select_company.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfif (q_select_company_data.settlement_type NEQ 0) AND NOT (request.a_bol_is_reseller)>
	<!--- this customer is not allwed to order in the shop, has to order at the reseller --->
	
	<!--- check if shop url has been provided ... --->
	<cfset a_struct_links = application.components.cmp_customize.GetCustomStyleData(entryname = 'links', usersettings = session.stUserSettings)>

	<cfset a_str_shop_url = a_struct_links.shop>
	
	<cfif Len(a_str_shop_url) IS 0>
		<!--- forward to feedback form ... --->
		<cflocation addtoken="no" url="index.cfm?action=partnerfeedbackform&reason=shop">		
	<cfelse>
		<h4><a target="_blank" href="<cfoutput>#a_str_shop_url#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_shop_open_click')#</cfoutput></a></h4>
	</cfif>
	
	<cfexit method="exittemplate">
</cfif>


<br>
<cfinclude template="queries/q_select_promocodes.cfm">


<table border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td class="bb"><cfoutput>#GetLangVal('adm_ph_promocode_code')#</cfoutput></td>
    <td class="bb"><cfoutput>#GetLangVal('adm_ph_promocode_value')#</cfoutput></td>
    <td class="bb"><cfoutput>#GetLangVal('adm_ph_promocode_used')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_promocodes">
  <tr>
    <td>
		<cfset a_int_diff = 6 - Len(q_select_promocodes.promocode)>
		<cfloop from="1" to="#a_int_diff#" index="ii">0</cfloop>#q_select_promocodes.promocode#
	</td>
    <td>
		#q_select_promocodes.codevalue#
	</td>
    <td>
		#YesNoFormat(q_select_promocodes.deducted)#
	</td>
  </tr>
  </cfoutput>
</table>
<br><br>
<cfoutput>#GetLangVal('adm_ph_promocode_hint')#</cfoutput>
<br>
<form action="shop/act_add_promocode.cfm" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
<input type="text" name="frmpromocode" value="" size="6">&nbsp;<input type="submit" value="<cfoutput>#GetLangVal('adm_ph_promocode_add_code')#</cfoutput>">
</form>