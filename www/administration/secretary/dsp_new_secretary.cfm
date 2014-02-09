
<cfinclude template="../dsp_inc_select_company.cfm">

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="../queries/q_select_company_users.cfm">


<br>
<h4><cfoutput>#GetLangVal('adm_ph_secretary_new_entry')#</cfoutput></h4>

<form action="secretary/act_create_entry.cfm" method="post">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">


<table border="0" cellspacing="0" cellpadding="6">
  <tr>
  	<td></td>
	<td></td>
	<td><cfoutput>#GetLangVal('cm_wd_example')#</cfoutput></td>
  </tr>
  <tr>
    <td align="right"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:</td>
    <td>
	<select name="frmuserkey">
		<cfoutput query="q_select_company_users">
			<option value="#q_select_company_users.entrykey#">#htmleditformat(q_select_company_users.surname)#, #htmleditformat(q_select_company_users.firstname)# (#q_select_company_users.username#)</option>
		</cfoutput>
	</select>
	</td>
	<td>
		<cfoutput>#GetLangVal('adm_wd_secretary_boss')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right" class="bt"><cfoutput>#GetLangVal('adm_wd_secretary_assistant')#</cfoutput>:</td>
    <td class="bt">
	<select name="frmsecretarykey">
		<cfoutput query="q_select_company_users">
			<option value="#q_select_company_users.entrykey#">#htmleditformat(q_select_company_users.surname)#, #htmleditformat(q_select_company_users.firstname)# (#q_select_company_users.username#)</option>
		</cfoutput>	
	</select>
	</td>
	
		<td class="bt">
		<cfoutput>#GetLangVal('adm_wd_secretary_assistant')#</cfoutput>
		</td>

  </tr>
  <tr>
  	<td>&nbsp;</td>
	<td>
		<cfoutput>#GetLangVal('adm_wd_secretary_assistant_description')#</cfoutput>
	</td>
  </tr>
  <!--- permissions: --->
  <tr>
		<td align="right" valign="top">
			<cfoutput>#GetLangVal('cm_wd_permissions')#</cfoutput>:
		</td>
		<td valign="top">
			<select name="frmcb_permission">
				<option value="create"><cfoutput>#GetLangVal('adm_ph_sec_permissions_create')#</cfoutput></option>
				<option value="changecreatedbysecretary"><cfoutput>#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#</cfoutput></option>
				<option value="changeall"><cfoutput>#GetLangVal('adm_ph_sec_permissions_change_all')#</cfoutput></option>
				<option value="deletecreatedbysecretary"><cfoutput>#GetLangVal('adm_ph_sec_permissions_delete_created_by_secretary')#</cfoutput></option>
				<option value="deleteall"><cfoutput>#GetLangVal('adm_ph_sec_permissions_delete_all')#</cfoutput></option>
			</select>
			<br><br>
			<cfoutput>#GetLangVal('adm_ph_sec_permissions_description')#</cfoutput>
			
			<!---
			<input type="hidden" name="frmcb_permissions" value="create">
			<input type="checkbox" name="frmcb_permissions" value="create" class="noborder" disabled checked> <cfoutput>#GetLangVal('adm_ph_sec_permissions_create')#</cfoutput>
			<br>
			<input type="checkbox" name="frmcb_permissions" value="changecreatedbysecretary" class="noborder" checked> <cfoutput>#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#</cfoutput>
			<br>
			<input type="checkbox" name="frmcb_permissions" value="changeall" class="noborder" checked> <cfoutput>#GetLangVal('adm_ph_sec_permissions_change_all')#</cfoutput>
			<br>
			<input type="checkbox" name="frmcb_permissions" value="deletecreatedbysecretary" class="noborder" checked> <cfoutput>#GetLangVal('adm_ph_sec_permissions_delete_created_by_secretary')#</cfoutput>
			<br>
			<input type="checkbox" name="frmcb_permissions" value="deleteall" class="noborder" checked> <cfoutput>#GetLangVal('adm_ph_sec_permissions_delete_all')#</cfoutput>
			--->
		</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
	<input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('cm_wd_submit_btn_create')#</cfoutput>">
	</td>
	<td></td>
  </tr>
</form>
</table>