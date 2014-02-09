
<cfif q_select_is_company_admin.recordcount IS 1>
	<div style="border:orange solid 2px;padding:4px;line-height:18px;">
	
		<img src="/images/settings/img_customize_32x32.gif" alt="Administration" align="left" vspace="4" hspace="4">
		
		<b style="text-transform:uppercase;font-size:10px;"><cfoutput>#GetLangVal('start_ph_admin_you_are_the_boss')#</cfoutput></b>
		
		<br>
		
		<cfoutput>#GetLangVal('start_ph_admin_you_are_the_boss_body')#</cfoutput>
		
		<a href="/administration/?action=shop&username=<cfoutput>#urlencodedformat(request.stSecurityContext.myusername)#</cfoutput>" target="_blank" style="text-transform:uppercase;font-size:10px;font-weight:bold; "><font color="#CC0000" style="font-size:13px;font-weight:bold; ">&raquo;</font> <cfoutput>#GetLangVal('start_ph_admin_you_are_the_boss_link_to_admintool')#</cfoutput></a>
	
	</div>
	<br>
</cfif>

<cfif Len(a_struct_load_userdata.query.surname) IS 0>
	<div style="border:orange solid 2px;padding:4px;line-height:18px;">
		
		
		
		<table border="0" cellspacing="0" cellpadding="4" width="100%" class="mischeader">
		<form action="/settings/act_save_name_edit_startpage.cfm" method="post">
			<tr>
				<td align="center" valign="middle">
					<img src="/images/admin/img_flash_32x32.gif" width="32" height="32" border="0">
				</td>
				<td>
					<b><cfoutput>#GetLangVal('start_ph_data_correct')#</cfoutput></b>
				</td>
			</tr>
		  <tr>
			<td align="right">
			</td>
			<td>
				<select name="frmsex">
					<option value="1"><cfoutput>#GetLangVal('cm_wd_female')#</cfoutput></option>
					<option value="0"><cfoutput>#GetLangVal('cm_wd_male')#</cfoutput></option>
				</select>
			</td>
		  </tr>		
		  <tr>
			<td align="right">
				<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmfirstname" value="<cfoutput>#htmleditformat(a_struct_load_userdata.query.firstname)#</cfoutput>" size="20">
			</td>
		  </tr>
		  <tr>
			<td align="right">
				<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmsurname" value="<cfoutput>#htmleditformat(a_struct_load_userdata.query.surname)#</cfoutput>" size="20">
			</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
			<td>
				<input type="submit" value="<cfoutput>#GetLangVal('start_wd_correct_data_save')#</cfoutput>">
			</td>
		  </tr>
		 </form>
		</table>
		
	</div>
	<br>
</cfif>