<!--- //

	Module:		Preferences
	Action:		Extensions.crm
	Description: 
	

// --->

<cfprocessingdirective pageencoding="utf-8">

<cfparam name="url.saved" type="numeric" default="0">
	
<!--- start view --->
<cfset a_str_show_products_history_always = GetUserPrefPerson('extensions.crm', 'products.history.show.always', '0', '', false) />
<cfset a_str_cal_viewmode_web = GetUserPrefPerson('extensions.crm', 'calendar.contactdata.viewmode.web', 'short', '', false) />
<cfset a_str_hide_empty_areas = GetUserPrefPerson('extensions.crm', 'common.hide_empty_areas', '1', '', false) />
<cfset a_str_hide_private_data = GetUserPrefPerson('extensions.crm', 'common.hide_private_address_if_business_data_available', '1', '', false) />
<cfset a_str_cal_viewmode_print = GetUserPrefPerson('extensions.crm', 'calendar.contactdata.viewmode.print', 'full', '', false) />
<cfset a_int_display_email_addressbook = GetUserPrefPerson('extensions.crm', 'addressbook.displayemailaddress', '1', '', false) />
<cfset a_int_autoupdate_lastcontact_on_product_add = GetUserPrefPerson('extensions.crm', 'products.autoupdate_lastupdate_on_add', '0', '', false) />
	
<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_crm')) />

<cfif url.saved IS 1>
	<div class="b_all" style="padding:6px;font-weight:bold;">
		<cfoutput>#GetLangVal('prf_ph_settings_saved')#</cfoutput>
	</div>
	<br>
</cfif>

<form action="actions/act_save_extension_crm.cfm" method="post" style="margin:0px; ">
<table class="table_details table_edit_form">
  <tr>
    <td class="field_name">
		Kontaktdatendarstellung Kalender:
	</td>
    <td>
		
		<select name="frm_cal_view_web">
			<cfoutput>
			<option #writeselectedElement(a_str_cal_viewmode_web, 'short')# value="short">Kurz (Name)</option>
			<option #writeselectedElement(a_str_cal_viewmode_web, 'middle')# value="middle">Zusammenfassung</option>
			<option #writeselectedElement(a_str_cal_viewmode_web, 'full')# value="full">Alles</option>
			</cfoutput>
		</select>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<input value="1" class="noborder" name="frmdb_hide_empty_areas" type="checkbox" <cfoutput>#WriteCheckedElement(a_str_hide_empty_areas, 1)#</cfoutput>>
	</td>
	<td>
		<cfoutput>#GetLangVal('crm_ph_hide_empty_areas')#</cfoutput>
	</td>
  </tr>
  <tr>
  	<td class="field_name">
		<input value="1" class="noborder" name="frmdb_hide_private_data" type="checkbox" <cfoutput>#WriteCheckedElement(a_str_hide_private_data, 1)#</cfoutput>>
	</td>
	<td>
		<cfoutput>#GetLangVal('crm_ph_hide_private_data_if_business_available')#</cfoutput>
	</td>
  </tr>  
  <tr style="display:none;">
  	<td class="field_name">
		<input <cfoutput>#WriteCheckedElement(a_int_display_email_addressbook, 1)#</cfoutput> type="checkbox" name="frmcb_display_email_addressbook" value="1" class="noborder">
	</td>
  	<td>
		E-Mail Adresse im Adressbuch als eigene Spalte
	</td>
  </tr>
	<tr>
		<td class="field_name">
			<input value="1" type="checkbox" name="frm_show_products_history_always" <cfoutput>#WriteCheckedElement(a_str_show_products_history_always, 1)#</cfoutput> />
		</td>
		<td>
			Produktentwicklung immer zur Gänze anzeigen
		</td>
	</tr>
  <tr>
  <tr>
	<td class="field_name">
		<input type="checkbox" value="1" name="frm_autoupdate_lastcontact_on_product_add" <cfoutput>#WriteCheckedElement( a_int_autoupdate_lastcontact_on_product_add, 1 )#</cfoutput> class="noborder" />
	</td>
	<td>
		LetztKontakt automatisch bei Produktzuweisungen updaten		
	</td>
  </tr>
    <td class="field_name"></td>
    <td>
		<input class="btn" type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>" name="frmsubmit" class="btn" />
	</td>
  </tr>
</table>
</form>


