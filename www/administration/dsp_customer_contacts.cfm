<!--- //

	Module:		Admin
	Action:		Customercontacts
	Description:display the customer contacts concerning business and technical issues

// --->


<cfinclude template="dsp_inc_select_company.cfm">

<cfset SelectCustomerContacts.entrykey = url.companykey>
<cfinclude template="queries/q_select_customer_contacts.cfm">

<h4><cfoutput>#GetLangVal('adm_ph_administrative_contacts')#</cfoutput></h4>

<table class="table table-hover">
  <tr class="tbl_overview_header">
    <td><b><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput></b></td>
    <td>Level</td>
    <td><cfoutput>#GetLangVal('cm_wd_action')#</cfoutput></td>
  </tr>
  <cfoutput query="q_select_customer_contacts">

  <!--- load username ... --->
	<cfset a_str_username = application.components.cmp_user.getusernamebyentrykey(q_select_customer_contacts.userkey) />

  <cfif a_str_username IS ''>
  	user does not exist
  </cfif>
  <tr>
    <td>
		<a href="index.cfm?action=userproperties&entrykey=#urlencodedformat(q_select_customer_contacts.userkey)##WriteURLTags()#">#a_str_username#</a>

		<cfloop list="#q_select_customer_contacts.permissions#" delimiters="," index="a_str_index">
		<li>#a_str_index#</li>
		</cfloop>
	</td>

    <td>#q_select_customer_contacts.user_level#</td>
    <td>
	<a href="index.cfm?action=editcompanyadmin&userkey=#urlencodedformat(q_select_customer_contacts.userkey)##writeurltags()#"><img src="/images/si/pencil.png" class="si_img" /></a>
	&nbsp;&nbsp;
	<a onClick="return confirm('Sind sie sicher?');" href="user/act_remove_company_admin.cfm?userkey=#urlencodedformat(q_select_customer_contacts.userkey)##writeurltags()#"><span class="glyphicon glyphicon-trash"></span></a>

	</td>
  </tr>
  </cfoutput>
</table>
<br />

<cfset SelectAccounts.CompanyKey = url.companykey>
<cfinclude template="queries/q_select_accounts.cfm">

<!--- select all contacts which are not already administrators ... --->
<cfquery name="q_select_accounts" dbtype="query">
SELECT * FROM q_select_accounts
WHERE entrykey NOT IN
(<cfloop query="q_select_customer_contacts">'#q_select_customer_contacts.userkey#',</cfloop>'');
</cfquery>

<cfif q_select_accounts.recordcount IS 0>
	Keine weiteren Konten vorhanden.
	<cfexit method="exittemplate">
</cfif>

<form action="act_new_customer_contact.cfm" method="post">
<input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
<b>Hinzufuegen ...</b>
<table class="table table_details table_edit_form">
  <tr>
    <td class="field_name"><cfoutput>#GetLangVal('cm_wd_user')#</cfoutput>:</td>
    <td>
	<select name="frmuserkey">
		<cfoutput query="q_select_accounts">
		<option value="#htmleditformat(q_select_accounts.entrykey)#">#q_select_accounts.surname#, #q_select_accounts.firstname# (#q_select_accounts.username#)</option>
		</cfoutput>
	</select>
	</td>
  </tr>
  <tr>
    <td class="field_name">Typ:</td>
    <td>
	<select name="frmtype">
		<option value="0">technisch</option>
		<option value="1">kaufmaennisch</option>
	</select>
	</td>
  </tr>
  <tr>
  	<td class="field_name">Berechtigungen:</td>
	<td valign="top">
	<input type="checkbox" name="frmcbpermissions" value="editmasterdata"> Stammdaten editieren<br>
	<input type="checkbox" name="frmcbpermissions" value="order"> Erweiterungen/Produkte bestellen<br>
	<input type="checkbox" name="frmcbpermissions" value="resetpassword"> Passwort zuruecksetzen<br>
	<input type="checkbox" name="frmcbpermissions" value="useradministration"> Benutzerverwaltung<br>
	<input type="checkbox" name="frmcbpermissions" value="groupadministration"> Gruppenverwaltung<br>
	<input type="checkbox" name="frmcbpermissions" value="securityadministration"> Sicherheitsverwaltung<br>
	<input type="checkbox" name="frmcbpermissions" value="newsadministration"> Newsverwaltung<br>
	<input type="checkbox" name="frmcbpermissions" value="viewlog"> Logbuch einsehen<br>
	<input type="checkbox" name="frmcbpermissions" value="viewusercontent"> Benutzerdaten einsehen (nicht private)
	</td>
  </tr>
  <tr>
  	<td class="field_name">Level:</td>
	<td>
		<input type="text" name="frmlevel" value="100" size="4"> (100 = alle Rechte; 0 = Standard)
	</td>
  </tr>
  <tr>
  	<td class="field_name"></td>
	<td>
		Wenn Sie die 0 belassen gelten nur die oben ausgew&auml;hlten Rechte
	</td>
  </tr>
  <tr>
    <td class="field_name"></td>
    <td><input type="submit" name="frmsubmit" class="btn btn-primary" value="Hinzufuegen ..."></td>
  </tr>
</table>
</form>


