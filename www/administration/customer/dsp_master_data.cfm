<!--- //

	Module:		Admintool
	Action:		masterdata
	Description:Let the user edit the master data
	
// --->


<cfinclude template="../dsp_inc_select_company.cfm">

<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfset CreateorEditCustomer.Query = q_select_company_data />


<br /><br />  
<table class="table_details table_edit_form">
<form action="customer/act_edit_masterdata.cfm" method="post">


<cfoutput query="CreateorEditCustomer.Query">
<input type="hidden" name="frm_resellerkey" value="#htmleditformat(q_select_company_data.resellerkey)#">
<input type="hidden" name="frmcompanykey" value="#url.companykey#">


<tr>
  	<td class="field_name">#GetLangVal('adm_wd_type')#:</td>
	<td>
	<select name="frmtype">
		<option value="1" #writeselectedelement(CreateorEditCustomer.Query.customertype, 1)#>#GetLangVal('adm_wd_type_organization')#</option>
		<option value="0" #writeselectedelement(CreateorEditCustomer.Query.customertype, 0)#>#GetLangVal('adm_wd_type_private')#</option>
	</select>
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('adm_wd_name_company_private')#:</td>
    <td><input type="text" name="frmcompanyname" size="50" value="#htmleditformat(CreateorEditCustomer.Query.companyname)#"> <b>[R]</b></td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('cm_wd_description')#:</td>
    <td><input type="text" name="frmdescription" size="50" value="#htmleditformat(CreateOrEditCustomer.query.description)#"></td>
  </tr>  
  <tr>
  	<td class="field_name">#GetLangVal('adm_ph_responsible_persons')#:</td>
	<td>
	<input type="text" name="frmcontactperson" size="50" value="#htmleditformat(CreateOrEditCustomer.query.contactperson)#">
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('adm_wd_address')#:</td>
    <td><input type="text" name="frmcompanystreet" size="50" value="#htmleditformat(CreateorEditCustomer.Query.street)#"> <b>[R]</b></td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('adrb_wd_zipcode')#:</td>
    <td><input type="text" name="frmcompanyzipcode" size="10" value="#htmleditformat(CreateorEditCustomer.Query.zipcode)#"> <b>[R]</b></td>
  </tr>    
  <tr>
    <td class="field_name">#GetLangVal('adrb_wd_city')#:</td>
    <td><input type="text" name="frmcompanycity" size="50" value="#htmleditformat(CreateorEditCustomer.Query.city)#"> <b>[R]</b></td>
  </tr>   
  <tr>
  	<td class="field_name">#GetLangVal('adrb_wd_country')#:</td>
	<td>
	<select name="frmcompanycountry">
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'at')# value="at">&Ouml;sterreich</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'de')# value="de">Deutschland</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'ch')# value="ch">Schweiz</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'pl')# value="ch">Polen</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'cz')# value="ch">Czech Republic</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'sk')# value="ch">Slovakia</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'fr')# value="ch">France</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'ro')# value="ro">Romania</option>		
	</select> <b>[R]</b>
	</td>
  </tr> 
  <tr>
    <td class="field_name">#GetLangVal('adm_ph_telephone_numer')#:</td>
    <td><input type="text" name="frmcompanytelephone" size="50" value="#htmleditformat(CreateorEditCustomer.Query.telephone)#"></td>
  </tr>    
  <tr>
    <td class="field_name">#GetLangVal('adrb_wd_fax')#:</td>
    <td><input type="text" name="frmcompanyfax" size="50" value="#htmleditformat(CreateorEditCustomer.Query.fax)#"></td>
  </tr>    
  <tr>
    <td class="field_name">#GetLangVal('cm_wd_email')#:</td>
    <td><input type="text" name="frmcompanyemail" size="50" value="#htmleditformat(CreateorEditCustomer.Query.email)#"></td>
  </tr>    
  <tr>
    <td class="field_name">#GetLangVal('adm_ph_uid_number')#:</td>
    <td><input type="text" name="frmcompanyuidnumber" size="50" value="#htmleditformat(CreateorEditCustomer.Query.uidnumber)#"></td>
  </tr>    
  <!---<tr>
    <td align="right">FB-Nummer:</td>
    <td><input type="text" name="frmfbnumber" size="50" value="#htmleditformat(CreateorEditCustomer.Query.fbnumber)#"></td>
  </tr>  --->
  <tr>
  	<td class="field_name">#GetLangVal('adm_ph_invoice_address')#:</td>
	<td>
		<textarea name="frmbillingcontact" rows="4" style="font-family:Verdana;font-size:11px;" cols="50">#htmleditformat(CreateorEditCustomer.Query.billingcontact)#</textarea><br><font color="gray">#GetLangVal('adm_ph_invoice_address_empty')#r</font>
	</td>
  </tr>
  <tr>
  	<td class="field_name"></td>
	<td>
		<input type="submit" value="#GetLangVal('cm_wd_save')#" class="btn btn-primary" />
	</td>
  </tr>
</cfoutput>
</form>
</table>


