<cfinclude template="../dsp_inc_select_company.cfm">

<cfinvoke component="#request.a_str_component_secretary#" method="GetAllSecretariesOfACompany" returnvariable="q_select_items">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>

<cfquery name="q_select_item" dbtype="query">
SELECT
	*
FROM
	q_select_items
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.entrykey#">
;
</cfquery>

<cfif q_select_item.recordcount IS 0>
	<cfabort>
</cfif>

<cfset a_cmp_user = application.components.cmp_user />

<br>
<fieldset class="default_fieldset">
<legend>Update</legend>
<form action="secretary/act_update.cfm" method="post" style="margin:0px; ">
<input type="hidden" name="frmentrykey" value="<cfoutput>#q_select_item.entrykey#</cfoutput>">
<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="6">
  <tr>
    <td align="right">
		<cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:
	</td>
    <td>
		<cfoutput>
		#a_cmp_user.getusernamebyentrykey(q_select_item.userkey)#
		</cfoutput>
	</td>
  </tr>
  <tr>
    <td align="right" class="bt">
		<cfoutput>#GetLangVal('adm_wd_secretary_assistant')#</cfoutput>:
	</td>
    <td class="bt">
		<cfoutput>
		#a_cmp_user.getusernamebyentrykey(q_select_item.secretarykey)#
		</cfoutput>	
	</td>
  </tr>
  <tr>
		<td align="right" valign="top">
			<cfoutput>#GetLangVal('cm_wd_permissions')#</cfoutput>:
		</td>
		<td valign="top">
			<select name="frmcb_permission">
				<option <cfoutput>#WriteSelectedElement('create', q_select_item.permission)#</cfoutput> value="create"><cfoutput>#GetLangVal('adm_ph_sec_permissions_create')#</cfoutput></option>
				<option <cfoutput>#WriteSelectedElement('changecreatedbysecretary', q_select_item.permission)#</cfoutput> value="changecreatedbysecretary"><cfoutput>#GetLangVal('adm_ph_sec_permissions_change_created_by_secretary')#</cfoutput></option>
				<option <cfoutput>#WriteSelectedElement('changeall', q_select_item.permission)#</cfoutput> value="changeall"><cfoutput>#GetLangVal('adm_ph_sec_permissions_change_all')#</cfoutput></option>
				<option <cfoutput>#WriteSelectedElement('deletecreatedbysecretary', q_select_item.permission)#</cfoutput> value="deletecreatedbysecretary"><cfoutput>#GetLangVal('adm_ph_sec_permissions_delete_created_by_secretary')#</cfoutput></option>
				<option <cfoutput>#WriteSelectedElement('deleteall', q_select_item.permission)#</cfoutput> value="deleteall"><cfoutput>#GetLangVal('adm_ph_sec_permissions_delete_all')#</cfoutput></option>
			</select>
			<br><br>
			<cfoutput>#GetLangVal('adm_ph_sec_permissions_description')#</cfoutput>
			</td>
  </tr>
  <tr>
  	<td></td>
	<td>
		<input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>">
	</td>
  </tr>
</table>
</form>
</fieldset>