<cfparam name="url.data" type="string" default="">

<cfinclude template="/common/scripts/script_utils.cfm">

<cfset a_str_name = ''>
<cfset a_str_surname = ''>
<cfset a_str_firstname = ''>
<cfset a_str_email = ExtractEmailAdr(url.data)>

<cfif FindNoCase('"', url.data) GT 0>
	<cfset a_arr_name = ReFindNoCase('"[^"]*', url.data, 1, true)>
	
	<cfif a_arr_name.len[1] GT 0>
		<cfset a_str_name = Mid(url.data, a_arr_name.pos[1], a_arr_name.len[1])>
		<cfset a_str_name = Trim(ReplaceNoCase(a_str_name, '"', '', 'ALL'))>
		
		<cfif (Len(a_str_name) GT 0) AND FindNoCase(' ', a_str_name) GT 0>
			<cfset a_str_firstname = Mid(a_str_name, 1, FindNoCase(' ', a_str_name)-1)>
			<cfset a_str_surname = Mid(a_str_name, FindNoCase(' ', a_str_name)+1, Len(a_str_name))>
		</cfif>
	</cfif>
</cfif>

<form name="frm_simpleadd_address" onSubmit="ExecuteSimpleAddAddressbookDialog();CloseSimpleModalDialog();return false;" method="post" style="margin:0px; ">
<table border="0" cellspacing="0" cellpadding="4" class="table table_details table_edit_form">
  <tr>
   <td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>
	</td>
    <td>
		<input type="text" name="frmfirstname" size="40" value="<cfoutput>#htmleditformat(a_str_firstname)#</cfoutput>">
	</td>
  </tr>
  <tr>
   <td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>
	</td>
    <td>
		<input type="text" name="frmsurname" size="40" value="<cfoutput>#htmleditformat(a_str_surname)#</cfoutput>">
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>
	</td>
    <td>
		<input type="text" name="frmcompany" size="40">
	</td>
  </tr>  
  <tr>
    <td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_email')#</cfoutput>
	</td>
    <td>
		<input type="text" name="frmemail" size="40" value="<cfoutput>#htmleditformat(a_str_email)#</cfoutput>">
	</td>
  </tr>
  <tr>
    <td class="field_name">
		<input type="checkbox" name="frm_cb_remote_edit" value="true" class="noborder" style="width:auto;" />
	</td>
    <td>
		<cfoutput>#GetLangVal('adrb_ph_quickadd_enable_remotedit')#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" class="btn btn-primary" value="<cfoutput>#GetLangVal('cm_wd_save_button_caption')#</cfoutput>" />
	</td>
  </tr>
</table>
</form>