

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

<!--- single place... --->
<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="a_struct_single_licence">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
</cfinvoke>

<!--- groupware ... --->
<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="a_struct_groupware_licence">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
</cfinvoke>

<!--- fax number --->
<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="a_struct_fax_number_status">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="productkey" value="E22BF74F-0569-0D4A-E3969D0FB11D9C0D">
</cfinvoke>



<h4><cfoutput>#GetLangVal('adm_ph_licence_status')#</cfoutput></h4>
<a href="index.cfm?action=shop<cfoutput>#writeurltags()#</cfoutput>"><b><cfoutput>#GetLangVal('adm_ph_licence_status_add_goto_shop')#</cfoutput></b></a>
<br><br>
<cfoutput>
<b>#GetLangVal('adm_wd_licences')#</b>
<table class="table table-hover">
  <tr class="tbl_overview_header">
  	<td>#GetLangVal('cm_wd_product')#</td>
	<td>#GetLangVal('adm_ph_licence_total')#</td>
	<td>#GetLangVal('adm_ph_licence_available')#</td>
  </tr>
  <tr>
    <td>Mobile CRM</td>
    <td align="right">
		#val(a_struct_groupware_licence.totalseats)#	
	</td>
	<td align="right">
		#val(a_struct_groupware_licence.availableseats)#
	</td>
  </tr>
  <tr>
    <td>Mobile Office</td>
    <td align="right">
		#val(a_struct_single_licence.totalseats)#
	</td>
	<td align="right">
		#val(a_struct_single_licence.availableseats)#
	</td>
  </tr>
  <tr>
  	<td>#GetLangVal('adm_ph_licence_fax_number_intl')#</td>
	<td align="right">
		#val(a_struct_fax_number_status.totalseats)#
	</td>
	<td align="right">
		#val(a_struct_fax_number_status.availableseats)#
	</td>
  </tr>
</table>
</cfoutput>

<cfinvoke component="#request.a_str_component_licence#" method="GetAvailableQuota" returnvariable="a_int_quota">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfinvoke component="#request.a_str_component_licence#" method="GetAvailablePoints" returnvariable="a_int_points">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<br><br><br>
<b><cfoutput>#GetLangVal('adm_ph_licence_available_contingents')#</cfoutput> *</b><br>
<table class="table table-hover">
  <tr class="tbl_overview_header">
  	<td><cfoutput>#GetLangVal('cm_wd_product')#</cfoutput></td>
	<td><cfoutput>#GetLangVal('adm_ph_licence_available')#</cfoutput></td>
  </tr>
  <tr>
  	<td>
	<cfoutput>#GetLangVal('adm_ph_licence_points')#</cfoutput>
	</td>
	<td align="right">
	<cfoutput>#a_int_points#</cfoutput> <cfoutput>#GetLangVal('adm_ph_licence_points')#</cfoutput>
	</td>
  </tr>
  <tr>
  	<td><cfoutput>#GetLangVal('adm_ph_licence_space')#</cfoutput></td>
	<td align="right">
	<cfoutput>#a_int_quota#</cfoutput> MB
	</td>
  </tr>
</table>
<br><br>
* <cfoutput>#GetLangVal('adm_ph_licence_additional_to_base')#</cfoutput>