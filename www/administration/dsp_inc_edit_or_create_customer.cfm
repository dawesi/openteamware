<!--- //

	Module:		
	Action:		create or edit a customer
	Description:// --->

<cfinclude template="utils/inc_check_security.cfm">

<cfparam name="CreateorEditCustomer.action" type="string" default="create">
<cfparam name="CreateOrEditCustomer.Formaction" type="string" default="act_new_customer.cfm">

<!--- the query with the data (or empty) --->
<cfparam name="CreateorEditCustomer.Query" type="query" default="#QueryNew("language,billingcontact,domains,rating,contactperson,status,shortname,resellerkey,companyname,entrykey,description,customheader,domain,customertype,street,zipcode,telephone,fax,uidnumber,countryisocode,city,fbnumber,email,industry,settlement_type")#">

<cfif CreateorEditCustomer.Query.recordcount is 0>
	<cfset tmp = QueryAddRow(CreateorEditCustomer.Query, 1)>
</cfif>

<!--- do we have already a reseller key and are we in the create action? --->
<cfif (CreateorEditCustomer.action is "create") AND (StructKeyExists(url, "resellerkey"))>
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "resellerkey", url.resellerkey, 1) />
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "domain", "openTeamware.com", 1) />
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "domains", "openTeamware.com", 1) />
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "status", "1", 1) />
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "rating", "3", 1) />
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "language", "0", 1) />
</cfif>

<!--- do we have a single reseller (only one entry)? than no selection is necessary ... --->
<!--- <cfif (request.q_select_reseller.recordcount is 1)>
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "resellerkey", request.q_select_reseller.entrykey, 1)>
</cfif> --->


<!--- select the properties of the current reseller --->
<cfquery name="q_select_current_reseller" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateorEditCustomer.Query.resellerkey#">
;
</cfquery>

<!--- set default settlement type if action = create --->
<cfif CreateorEditCustomer.action is "create">
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "settlement_type", q_select_current_reseller.default_settlement_type, 1) />
	<cfset tmp = QuerySetCell(CreateorEditCustomer.query, "domain", ListGetAt(q_select_current_reseller.domains, 1), 1) />
</cfif>

<form name="frmneworeditcustomer" action="<cfoutput>#CreateOrEditCustomer.Formaction#</cfoutput>" method="post">

<cfoutput query="CreateorEditCustomer.Query">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(CreateorEditCustomer.Query.entrykey)#</cfoutput>" />

<table class="table_details table_edit">

  <tr class="mischeader">
    <td colspan="2">#GetLangVal('adm_ph_nav_account_data')#</td>
  </tr>
  <tr>
  	<td class="field_name">#GetLangVal('adm_wd_partner')#:</td>
	<td>
	<!--- select the reseller ...
	
		if none has been selected let the user decide which reseller should be used ... --->
		
	<cfif len(CreateorEditCustomer.query.resellerkey) GT 0>
		<input type="hidden" name="frmresellerkey" value="#htmleditformat(CreateorEditCustomer.query.resellerkey)#">
		
		<!--- display the reseller name ... --->
		
		<cfquery name="q_select_reseller_name" datasource="#request.a_str_db_users#">
		SELECT
			companyname
		FROM
			reseller
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateorEditCustomer.query.resellerkey#">
		;
		</cfquery>
		
		#htmleditformat(q_select_reseller_name.companyname)#
		
	<cfelse>
		<select name="frmresellerkey">
			<cfloop query="request.q_select_reseller">
			<option #writeselectedelement(request.q_select_reseller.entrykey, CreateorEditCustomer.Query.resellerkey)# value="#htmleditformat(request.q_select_reseller.entrykey)#"><cfloop from="1" to="#request.q_select_reseller.resellerlevel#" index="ii">&nbsp;</cfloop>#htmleditformat(request.q_select_reseller.companyname)#</option>
			</cfloop>
		</select>	
	</cfif>

	</td>
  </tr>
  <!--- no reseller for this customer has been selected yet ... --->
  <cfif Len(CreateorEditCustomer.Query.resellerkey) is 0>
  <tr>
  	<td class="field_name"></td>
	<td>
	<input type="button" name="frmbtn" value="#GetLangVal('adm_wd_proceed')#" onClick="Proceed();">
	</td>
  </tr>
  </form>
  <script type="text/javascript">
  	function Proceed()
		{
		location.href='default.cfm?action=newcustomer&resellerkey='+escape(document.frmneworeditcustomer.frmresellerkey.value);
		}
  </script>
  
  <cfexit method="exittemplate">
  </cfif>
  
  
  <tr>
  	<td class="field_name">#GetLangVal('cm_wd_domain')#:</td>
	<td valign="top">
	<!---<input type="radio" name="frmdomain" value="openTeamware.com" checked> openTeamWare.com/--->
	<!--- load the domains used by this special reseller ... --->
	
	<cfif CreateorEditCustomer.action is "create">
	
	<cfquery name="q_select_domains" dbtype="query">
	SELECT
		domains
	FROM
		request.q_select_reseller
	WHERE
		entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateorEditCustomer.Query.resellerkey#">
	;
	</cfquery>
	
	<cfif Len(q_select_domains.domains) IS 0>
		<cfset tmp = QuerySetCell(q_select_domains, 'domains', 'openTeamware.com', 1)>
	</cfif>
	
	<cfloop list="#q_select_domains.domains#" delimiters="," index="a_str_domain">
	<input class="noborder" #writecheckedelement(CreateorEditCustomer.query.domain, a_str_domain)# type="radio" name="frmdomain" value="#htmleditformat(a_str_domain)#"> #htmleditformat(a_str_domain)#
	</cfloop>
	&nbsp;&nbsp;
	<input type="Radio"  class="noborder" name="frmdomain" value="own"> <input type="Text" name="frmowndomain" value="" size="10">
	&nbsp;&nbsp;
	<!--- // check if domain is supported // --->
	
	<cfelse>
		<!--- edit operation ... --->
		<input type="text" name="frmdomain" value="#CreateorEditCustomer.query.domains#" size="50"> <b>[R]</b>
		<br>#GetLangVal('adm_ph_domains_sep_by_comma')#
	</cfif>
	</td>
  </tr>
  <tr>
  	<td class="field_name">#GetLangVal('cm_wd_status')#:</td>
	<td>
	<input type="radio" name="frmradiostatus" value="0" class="noborder" #Writecheckedelement(CreateorEditCustomer.query.status, 0)#> #GetLangVal('adm_wd_customer')#
	&nbsp;&nbsp;
	<input type="radio" name="frmradiostatus" value="1" class="noborder" #Writecheckedelement(CreateorEditCustomer.query.status, 1)#> #GetLangVal('adm_ph_interested_party')#	
	</td>
  </tr>
  <cfif CreateorEditCustomer.action IS 'create'>
  <tr>
  	<td class="field_name">#GetLangVal('adm_ph_end_of_trial_phase')#:</td>
	<td>
	<cfset a_dt_trial_end = DateAdd('d', 30, Now())>
	<input type="text" name="frmdt_trialphase_end" size="8" readonly="1" value="#DateFormat(a_dt_trial_end, 'dd.mm.yy')#"> <span id="f_trigger_c" style="cursor: pointer;"><img  src="/images/calendar/menu_neuer_eintrag.gif" width="19" height="19" alt="#GetLangVal('cal_ph_newedit_show_calendar_hint')# ..." align="absmiddle" vspace="2" hspace="2"></span> (#GetLangVal('adm_ph_trial_end_date_hint')#)
	</td>
  </tr>
  </cfif>
  
  
  	<cfif q_select_current_reseller.ALLOW_MODIFY_SETTLEMENT_TYPE IS 1>
  	<tr>
		<td class="field_name">
			#GetLangVal('adm_wd_settlement')#:
		</td>
		<td>
			<select name="frm_settlement_type">
				<option #WriteSelectedElement(CreateorEditCustomer.Query.settlement_type, 0)# value="0">#GetLangVal('adm_ph_settlement_type_0')#</option>
				<option #WriteSelectedElement(CreateorEditCustomer.Query.settlement_type, 1)# value="1">#GetLangVal('adm_ph_settlement_type_1')#</option>
				<option #WriteSelectedElement(CreateorEditCustomer.Query.settlement_type, 2)# value="2">#GetLangVal('adm_ph_settlement_type_2')#</option>
			</select>		
		</td>
	</tr>
	<cfelse>
		<!--- use default ... --->
		<input type="hidden" name="frm_settlement_type" value="0">
	</cfif>

  
  <tr>
  	<td class="field_name">#GetLangVal('adm_wd_type')#:</td>
	<td>
	<select name="frmtype">
		<option value="1" #writeselectedelement(CreateorEditCustomer.Query.customertype, 1)#>#GetLangVal('adm_wd_type_organization')#</option>
		<option value="0" #writeselectedelement(CreateorEditCustomer.Query.customertype, 0)#>#GetLangVal('adm_wd_type_private')#</option>
	</select>
	</td>
  </tr>
  <tR>
  	<td class="field_name">#GetLangVal('adm_wd_rating')#:</td>
	<td>
	<select name="frmrating">
		<option value="5" #writeselectedelement(CreateorEditCustomer.Query.rating, 5)#>#GetLangVal('adm_wd_rating_import')#</option>
		<option value="3" #writeselectedelement(CreateorEditCustomer.Query.rating, 3)#>#GetLangVal('adm_wd_rating_default')#</option>
		<option value="1" #writeselectedelement(CreateorEditCustomer.Query.rating, 1)#>#GetLangVal('adm_wd_rating_not_important')#</option>
	</select>
	</td>
  </tR>
  <tr>
  	<td class="field_name">#GetLangVal('cm_wd_industry')#:</td>
	<td>
	<select name="frmindustry">
		<option value="">- #GetLangVal('adm_wd_na')# -</option>
		<option value="AerospaceDefense" #writeselectedelement(CreateorEditCustomer.Query.industry, 'AerospaceDefense')#>#GetLangVal('cm_ph_industry_AerospaceDefense')#</option>
		<option value="ApparelFootwear" #writeselectedelement(CreateorEditCustomer.Query.industry, 'ApparelFootwear')#>#GetLangVal('cm_ph_industry_ApparelFootwear')#</option>
		<option value="Automotive" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Automotive')#>#GetLangVal('cm_ph_industry_Automotive')#</option>
		
		<option value="Banking" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Banking')#>#GetLangVal('cm_ph_industry_Banking')#</option>
		<option value="Brokerage" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Brokerage')#>#GetLangVal('cm_ph_industry_Brokerage')#</option>
		<option value="Chemicals" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Chemicals')#>#GetLangVal('cm_ph_industry_Chemicals')#</option>
		<option value="Communications" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Communications')#>#GetLangVal('cm_ph_industry_Communications')#</option>
		<option value="Consulting" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Consulting')#>#GetLangVal('cm_ph_industry_Consulting')#</option>
		<option value="ConsumerGoods" #writeselectedelement(CreateorEditCustomer.Query.industry, 'ConsumerGoods')#>#GetLangVal('cm_ph_industry_ConsumerGoods')#</option>
		<option value="Education" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Education')#>#GetLangVal('cm_ph_industry_Education')#</option>
		<option value="Electronics" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Electronics')#>#GetLangVal('cm_ph_industry_Electronics')#</option>
		<option value="Energy" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Energy')#>#GetLangVal('cm_ph_industry_Energy')#</option>
		
		<option value="Entertainment" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Entertainment')#>#GetLangVal('cm_ph_industry_Entertainment')#</option>
		<option value="Finance" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Finance')#>#GetLangVal('cm_ph_industry_Finance')#</option>
		<option value="Craft" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Craft')#>#GetLangVal('cm_ph_industry_Craft')#</option>
		<option value="Hardware" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Hardware')#>Hardware</option>
		<option value="Healthcare" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Healthcare')#>#GetLangVal('cm_ph_industry_Healthcare')#</option>
		<option value="HighTech" #writeselectedelement(CreateorEditCustomer.Query.industry, 'HighTech')#>#GetLangVal('cm_ph_industry_HighTech')#</option>
		<option value="Insurance" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Insurance')#>#GetLangVal('cm_ph_industry_Insurance')#</option>
		<option value="LifeSciences" #writeselectedelement(CreateorEditCustomer.Query.industry, 'LifeSciences')#>Life Sciences</option>
		<option value="Manufacturing" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Manufacturing')#>#GetLangVal('cm_ph_industry_Manufacturing')#</option>
		<option value="Media" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Media')#>#GetLangVal('cm_ph_industry_Media')#</option>
		
		<option value="Medical" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Medical')#>#GetLangVal('cm_ph_industry_Medical')#</option>
		<option value="Networking" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Networking')#>#GetLangVal('cm_ph_industry_Networking')#</option>
		<option value="Non-profit" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Non-profit')#>#GetLangVal('cm_ph_industry_Non-profit')#</option>
		<option value="Oil&Gas" #writeselectedelement(CreateorEditCustomer.Query.industry, 'oilgas')#>#GetLangVal('cm_ph_industry_oilgas')#</option>
		<option value="Other" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Other')#>#GetLangVal('cm_ph_industry_Other')#</option>
		<option value="Pharmaceutical" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Pharmaceutical')#>#GetLangVal('cm_ph_industry_Pharmaceutical')#</option>
		<option value="Process" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Process')#>#GetLangVal('cm_ph_industry_Process')#</option>
		<option value="PublicSector" #writeselectedelement(CreateorEditCustomer.Query.industry, 'PublicSector')#>#GetLangVal('cm_ph_industry_PublicSector')#</option>
		<option value="Retail" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Retail')#>#GetLangVal('cm_ph_industry_Retail')#</option>
		
		<option value="Software" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Software')#>Software</option>
		<option value="Transportation" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Transportation')#>#GetLangVal('cm_ph_industry_Transportation')#</option>
		<option value="Utilities" #writeselectedelement(CreateorEditCustomer.Query.industry, 'Utilities')#>#GetLangVal('cm_ph_industry_Utilities')#</option>
	</select> 
	</td>
  </tr>
  <tr>
    <td class="field_name">#GetLangVal('adm_wd_name_company_private')#:</td>
    <td><input type="text" name="frmcompanyname" size="50" value="#htmleditformat(CreateorEditCustomer.Query.companyname)#"> <b>[R]</b></td>
  </tr>
  <tr>
  	<td class="field_name">#GetLangVal('cm_wd_language')#:</td>
	<td>
		<select name="frmlanguage">
			<option value="0" #writeselectedelement(CreateorEditCustomer.Query.language, '0')#>DE</option>
			<option value="1" #writeselectedelement(CreateorEditCustomer.Query.language, '1')#>EN</option>
			<option value="2" #writeselectedelement(CreateorEditCustomer.Query.language, '2')#>CZ</option>
			<option value="3" #writeselectedelement(CreateorEditCustomer.Query.language, '3')#>SK</option>
			<option value="4" #writeselectedelement(CreateorEditCustomer.Query.language, '4')#>PL</option>
			<option value="5" #writeselectedelement(CreateorEditCustomer.Query.language, '5')#>RO</option>
		</select>
	</td>
  </tr>
  <!---<tr>
  	<td align="right">Kurzname (f&uuml;r URL):</td>
	<td>
	https://www.openTeamWare.com/go/<input type="Text" name="frmshortname" size="20" value="#htmleditformat(CreateorEditCustomer.query.shortname)#">/
	
	</td>
  </tr>--->
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
  	<td class="field_name">
		#GetLangVal('adrb_wd_country')#:
	</td>
	<td>
	<select name="frmcompanycountry">
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'at')# value="at">&Ouml;sterreich</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'de')# value="de">Deutschland</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'ch')# value="ch">Schweiz</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'pl')# value="pl">Polen</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'cz')# value="cz">Czech Republic</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'sk')# value="sk">Slovakia</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'fr')# value="fr">France</option>
		<option #writeselectedelement(CreateorEditCustomer.Query.countryisocode, 'ro')# value="ro">Romania</option>
	</select> <b>[R]</b>
		<!---
		<cfinvoke method="GetCountries" returnvariable="a_return" webservice="http://www.webservicex.net/country.asmx?wsdl"></cfinvoke>
		<cfdump var="#a_return#">
		
		<cfset a_xml_doc = XMLParse(a_return)>
		
		<cfdump var="#a_xml_doc#">--->
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
    <td><input type="text" name="frmcompanyemail" size="50" value="#htmleditformat(CreateorEditCustomer.Query.email)#"> [RC]</td>
  </tr>    
  <tr>
    <td class="field_name">#GetLangVal('adm_ph_uid_number')#:</td>
    <td><input type="text" name="frmcompanyuidnumber" size="50" value="#htmleditformat(CreateorEditCustomer.Query.uidnumber)#"></td>
  </tr>    
  <tr>
    <td class="field_name">#GetLangVal('adm_ph_fb_number')#:</td>
    <td><input type="text" name="frmfbnumber" size="50" value="#htmleditformat(CreateorEditCustomer.Query.fbnumber)#"></td>
  </tr>  
  <tr>
  	<td class="field_name">#GetLangVal('adm_ph_invoice_address')#:</td>
	<td>
		<textarea name="frmbillingcontact" rows="4" style="font-family:Verdana;font-size:11px;" cols="50">#htmleditformat(CreateorEditCustomer.Query.billingcontact)#</textarea><br><font color="gray">#GetLangVal('adm_ph_invoice_address_empty')#</font>
	</td>
  </tr>   
  <!---<tr>
  	<td align="right">Institut:</td>
	<td>
	<input type="text" name="frmbank" size="50">
	</td>
  </tr>
  <tr>
  	<td align="right">BLZ:</td>
	<td>
	<input type="text" name="frmbankblz" size="50">
	</td>
  </tr>
  <tr>
  	<td align="right">Konto-Nummer:</td>
	<td>
	<input type="text" name="frmbankaccountnumber" size="50">
	</td>
  </tr>--->
  
<cfif CreateorEditCustomer.action is "create">
<!---  <tr class="lightbg">
    <td colspan="2">Kaufm&auml;nnischer Ansprechpartner</td>
  </tr>
  <tr>
    <td align="right">Name:</td>
    <td><input type="text" name="frmbusinesscontactname" size="50"></td>
  </tr>
  <tr>
    <td align="right">Telefon:</td>
    <td><input type="text" name="frmbusinesscontacttelephone" size="50"></td>
  </tr>    
  <tr>
    <td align="right">E-Mail:</td>
    <td><input type="text" name="frmbusinesscontactemail" size="50"></td>
  </tr>  
  <tr class="lightbg">
    <td colspan="2">Technischer Ansprechpartner</td>
  </tr>  
  <tr>
  	<td colspan="2" align="center">
	<input type="radio" name="frmtechnicalcontact" value="customer" checked> Kunde
	&nbsp;&nbsp;
	<input type="radio" name="frmtechnicalcontact" value="reseller"> Wiederverk&auml;ufer
	</td>
  </tr>
  <tr>
    <td align="right">Firma:</td>
    <td><input type="text" name="frmtechnicalcontactcompany" size="50"></td>
  </tr>  
  <tr>
    <td align="right">Name:</td>
    <td><input type="text" name="frmtechnicalcontactname" size="50"></td>
  </tr>  
  <tr>
    <td align="right">Telefon:</td>
    <td><input type="text" name="frmtechnicalcontacttelephone" size="50"></td>
  </tr>    
  <tr>
    <td align="right">E-Mail:</td>
    <td><input type="text" name="frmtechnicalcontactemail" size="50"></td>
  </tr>   --->
  <!---<tr class="lightbg">
    <td colspan="2"><b>Bestellung</b></td>
  </tr>    
  <tr>
    <td align="right">Laufzeit:</td>
    <td>
	<select name="frmperiod">
		<option value="6">6 Monate</option>
		<option value="12">ein Jahr</option>
		<option value="18">18 Monate</option>
		<option value="24">2 Jahre</option>
		<option value="36">3 Jahre</option>
	</select>
	</td>
  </tr>
  <tr>
    <td align="right">Konten:</td>
    <td>
	<input type="text" name="frmaccounts" size="5" value="5">
	</td>
  </tr>
  <tr>
  	<td align="right">Domain:</td>
	<td>
	<input type="radio" name="frmdomain" checked value="inboxcc"> openTeamWare.com
	&nbsp;&nbsp;
	<input type="radio" name="frmdomain" value="own"> eigene
	</td>
  </tr>--->
</cfif>
  <tr>
    <td class="field_name">&nbsp;</td>
    <td><input type="submit" name="frmsubmit" value="#GetLangVal('adm_ph_btn_save_edit')#" class="btn" /></td>
  </tr>
  <tr>
  	<td class="field_name">&nbsp;</td>
	<td>
	<b>[R]</b> = required (#GetLangVal('adm_wd_required')#)
	<br>
	<b>[RC]</b> = recommended (#GetLangVal('adm_wd_recommended')#)
	</td>
  </tr>
 </form>
</cfoutput>
</table>


<script type="text/javascript">
<!--//
// initialize the qForm object
objForm = new qForm("frmneworeditcustomer");

// make these fields required
objForm.required("frmcompanyname, frmcompanystreet, frmcompanycity, frmcompanycountry, frmcompanyzipcode, frmdomain");

// make sure the "Email" field appears syntatically correct
//objForm.Email.validateEmail();
//-->
</SCRIPT>


