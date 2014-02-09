<!--- //

	create a new role
	
	// --->
	
	
<cfparam name="url.workgroupkey" type="string" default="">

<h4><img src="/images/img_security_key.png" width="32" height="32" border="0" align="absmiddle"><cfoutput>#GetLangVal("adm_ph_create_new_role")#</cfoutput></h4>
Geben Sie bitte den gewuenschten Rollennamen, eine kurze Beschreibung sowie optional eine Vorgabe an:

<table border="0" cellspacing="0" cellpadding="4">
<form action="act_new_role.cfm" method="post">
<input type="hidden" name="frmworkgroupkey" value="<cfoutput>#htmleditformat(url.workgroupkey)#</cfoutput>">
  <tr>
    <td align="right"><cfoutput>#GetLangVal("cm_wd_name")#</cfoutput>:</td>
    <td>
	<input type="text" name="frmname" size="30">
	</td>
  </tr>
  <tr>
    <td align="right"><cfoutput>#GetLangVal("cm_wd_description")#</cfoutput>:</td>
    <td>
	<input type="text" name="frmdescription" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">Standard-Vorgaben:</td>
    <td>
	<select name="frmstandardtype">
		<option value="">keine</option>
		<option value="guest">Gast - nur lesen</option>
		<option value="member" selected>Mitglied - erstellen/editieren</option>
		<option value="admin">Hauptmitglied - erstellen/editieren/l&ouml;schen</option>
		<option value="none">keine</option>
	</select>
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="Erstellen"></td>
  </tr>
</form>
</table>
