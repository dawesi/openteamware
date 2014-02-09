<cfinclude template="../dsp_inc_select_company.cfm">

<cfparam name="url.entrykey" type="string" default="">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

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

<h4><cfoutput>#GetLangVal('adm_ph_change_account_type')#</cfoutput></h4>


<table border="0" cellspacing="0" cellpadding="4">
<form action="user/act_change_account_type.cfm" method="post">
<input type="hidden" name="frmuserkey" value="<cfoutput>#url.entrykey#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>;
	</td>
    <td>
		<cfoutput>#stReturn.query.username#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_change_account_type_type_now')#</cfoutput>:
	</td>
    <td>
			<cfswitch expression="#stReturn.query.productkey#">
				<cfcase value="AD4262D0-98D5-D611-4763153818C89190">
					Mobile Office
				</cfcase>
				<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">
					Mobile CRM
				</cfcase>
			</cfswitch>
	</td>
  </tr>
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('adm_ph_change_account_type_new_type')#</cfoutput>:
	</td>
    <td>
		<cfset a_bol_licences_available = false>
		
		<select name="frmproductkey">
			<cfif stReturn.query.productkey IS 'AD4262D0-98D5-D611-4763153818C89190'>

				<cfif a_struct_groupware_licence.availableseats GT 0>
					<cfset a_bol_licences_available = true>			
					<option value="AE79D26D-D86D-E073-B9648D735D84F319">Mobile CRM</option>
				</cfif>
			</cfif>
			
			<cfif stReturn.query.productkey IS 'AE79D26D-D86D-E073-B9648D735D84F319'>
			
				<cfif a_struct_single_licence.availableseats GT 0>
					<cfset a_bol_licences_available = true>
				
					<option value="AD4262D0-98D5-D611-4763153818C89190">Mobile Office</option>
				</cfif>
				
			</cfif>
		</select>
	</td>
  </tr>
  <tr>
  	<td></td>
	<td>
	<cfif a_bol_licences_available>
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" name="frmsubmit">
	<cfelse>
		<br><br>
		<b><cfoutput>#GetLangVal('adm_ph_change_account_type_licences_needed')#</cfoutput><br><br><br>
		<a href="default.cfm?action=licence.status<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_nav_shop_display_licence_status')#</cfoutput></a>
		<br><br>
		<a href="default.cfm?action=shop<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_goto_shop')#</cfoutput></a>
		</b>
	</cfif>
	</td>
  </tr>
</form>
</table>



