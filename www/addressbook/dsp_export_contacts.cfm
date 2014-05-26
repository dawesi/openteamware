<cfoutput>#WriteMainContentTopHeaderLine(GetLAngVal('adrb_ph_actions_export'))#</cfoutput>

<cfif NOT IsDefined('session.a_struct_temp_data.addressbook_selected_entrykeys')>
	<cflocation addtoken="no" url="index.cfm">
</cfif>


<br><br>
<form action="utils/act_export.cfm" method="post" target="_blank" style="margin:0px; ">
<input type="hidden" name="frmentrykeys" value="<cfoutput>#session.a_struct_temp_data.addressbook_selected_entrykeys#</cfoutput>">
<table border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td>
		<cfoutput>#GetLangVal('cm_wd_contacts')#</cfoutput>:
	</td>
    <td>
		<cfoutput>#ListLen(session.a_struct_temp_data.addressbook_selected_entrykeys)#</cfoutput>
	</td>
  </tr>
  <tr>
    <td>
		Format:
	</td>
    <td>
		<select name="frmformat">
			<option value="csv">CSV (Textdatei)</option>
		</select>
	</td>
  </tr>

  <tr>
    <td>
		Trennzeichen:
	</td>
    <td>
		<select name="frmdelimeterchar" disabled>
			<option value=";">;</option>
			<option value=",">,</option>
		</select>
	</td>
  </tr>
  <tr>
  	<td>
		Codierung:
	</td>
	<td>
		<select name="frmencoding">
			<option value="iso-8859-1">ISO-8859-1</option>
			<option value="utf-8">UTF-8</option>			
		</select>
	</td>
  </tr>
  <!---<tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>--->
  <tr>
    <td>&nbsp;</td>
    <td>
		<input type="submit" value="Export">
	</td>
  </tr>
</table>
</form>




