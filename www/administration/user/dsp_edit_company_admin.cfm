<!--- //


	// --->


<cfinclude template="../dsp_inc_select_company.cfm">

<cfset SelectCustomerContacts.entrykey = url.companykey>
<cfinclude template="../queries/q_select_customer_contacts.cfm">

<cfquery name="q_select_customer_contact" dbtype="query">
SELECT
	*
FROM
	q_select_customer_contacts
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.userkey#">
;
</cfquery>

<cfinvoke component="#application.components.cmp_user#" method="Getusernamebyentrykey" returnvariable="a_str_username">
	<cfinvokeargument name="entrykey" value="#url.userkey#">
</cfinvoke>


<h4><cfoutput>#GetLangVal('adm_ph_edit_administrator')#</cfoutput> (<cfoutput>#a_str_username#</cfoutput>)</h4>

<table border="0" cellspacing="0" cellpadding="4">
<form action="user/act_edit_company_admin.cfm" method="post">
<input type="hidden" name="frmuserkey" value="<cfoutput>#url.userkey#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#url.companykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
<input type="hidden" name="frmtype" value="0">
<cfoutput query="q_select_customer_contact">
  <!---<tr>
    <td align="right">
		Typ:
	</td>
    <td>
	<select name="frmtype">
		<option value="0" #WriteSelectedElement(q_select_customer_contact.contacttype, 0)#>technisch</option>
		<option value="1" #WriteSelectedElement(q_select_customer_contact.contacttype, 1)#>kaufmaennisch</option>
	</select>
	</td>
  </tr>--->
  <tr>
  	<td align="right">
		<cfoutput>#GetLangVal('adm_ph_edit_administrator_level')#</cfoutput>:
	</td>
	<td>
		<input type="text" name="frmlevel" value="#q_select_customer_contact.user_level#"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_level_description')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right" valign="top">
		<cfoutput>#GetLangVal('adm_ph_edit_administrator_rights')#</cfoutput>:
	</td>
    <td valign="top">
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'editmasterdata') GT 0>checked</cfif> value="editmasterdata"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_rights_edit_masterdata')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'order') GT 0>checked</cfif> value="order"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_rights_shop')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'resetpassword') GT 0>checked</cfif> value="resetpassword"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_reset_password')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'useradministration') GT 0>checked</cfif> value="useradministration"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_user_admin')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'groupadministration') GT 0>checked</cfif> value="groupadministration"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_group_admin')#</cfoutput><br>	
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'securityadministration') GT 0>checked</cfif> value="securityadministration"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_security')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'newsadministration') GT 0>checked</cfif> value="newsadministration"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_news')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'viewlog') GT 0>checked</cfif> value="viewlog"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_logbook')#</cfoutput><br>
	<input type="checkbox" name="frmcbpermissions" <cfif ListFind(q_select_customer_contact.permissions, 'viewusercontent') GT 0>checked</cfif> value="viewusercontent"> <cfoutput>#GetLangVal('adm_ph_edit_administrator_read_user_data')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>">
	</td>
  </tr>
</form>
</cfoutput>
</table>