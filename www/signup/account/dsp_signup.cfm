<cfparam name="url.error" type="string" default="">
<cfparam name="url.source" type="string" default="">

<cfset a_str_include_header = application.components.cmp_customize.GetMailCustomHeader(style = request.appsettings.default_stylesheet, langno = 0)>

<form action="act_check_data.cfm" method="post" style="margin:0px; " name="formregistration">

<cfif request.a_bol_systempartner_has_been_provided>
	<!--- set hidden field ... --->
	<input type="hidden" name="frmsystempartnerkey" value="<cfoutput>#request.a_str_resellerkey#</cfoutput>" />
</cfif>

<!--- set empty value --->
<input type="hidden" name="frmdistributorkey" value="">

<cfif StructKeyExists(request, 'a_str_promocode')>
	<input type="hidden" name="frmpromocode" value="<cfoutput>#request.a_str_promocode#</cfoutput>" />
</cfif>

<input type="hidden" name="frmsource" value="<cfoutput>#htmleditformat(url.source)#</cfoutput>" />

<table border="0" cellspacing="0" cellpadding="16" class="bb" style="width:900px;background-color:white;">
<tr>
	<td colspan="2" class="bb" style="padding:10px;">
	
		<a href="/" target="_blank"><img src="/images/default_service_logo.png" alt="openTeamWare Logo" width="133" height="24" hspace="4" vspace="4" border="0"/></a>
	</td>
</tr>
	<!---
	<tr>
		<td colspan="2" style="font-weight:bold;color:white;background-color:gray;padding:8px;">
			&raquo; <cfoutput>#request.appsettings.description#</cfoutput> -  <cfoutput>#GetLangVal('snp_ph_subscribe_30_days_free_trial')#</cfoutput>
		</td>
	</tr>
  <tr>
  --->
  <tr>
  	<td colspan="2" class="bb bl br">
	
		<div class="status">
					
					<div style="font-size:17px;font-weight:bold; ">openTeamWare Signup</div>
					<p style="line-height:16px; ">
					Please enter your email address. We'll send you a link to the sign-up page
					</p>
					
					<p style="padding-left:20px;line-height:18px;padding-top:10px; ">
						<b><font color="white">00</font>0% Risiko</b> Kein Download, keine Installation, alles l&auml;uft im Browser
						<br/>
						<b>100% Chancen</b> Sie können sich in Ruhe von den Vorteilen des Produktes im täglichen Einsatz überzeugen.						
					</p>
		</div>
		
		
		
		
		<!---<p>
			<cfif url.product IS 'mobilecrm'>

			<cfelse>
			
			</cfif>
		</p>--->
		
		
		<!---
			<img src="/images/homepage/de/img_30days_trial.gif">
		--->
	</td>
  </tr>
    <td valign="top" width="600" class="bl">
	
	<cfif Len(url.error) GT 0>
	
	<cfoutput>#WriteSimpleHeaderDiv('123')#</cfoutput>
	
	<fieldset class="default_fieldset" style="border:red solid 2px; ">
		<legend><b><img src="/images/icon/img_help_32x32.png" align="absmiddle"> <cfoutput>#GetLangVal('snp_ph_please_check_your_input')#</cfoutput></b></legend>
		<div style="padding:20px;font-weight:bold; ">
			<cfswitch expression="#url.error#">
				<cfcase value="agbacceptmissing">
					<cfoutput>#GetLangVal('snp_ph_error_ctc_accept')#</cfoutput>
					<br>
					<cfoutput>#GetLangVal('snp_ph_please_agree_to_ctc')#</cfoutput>
				</cfcase>
				<cfcase value="tooshortfirstname">
					<cfoutput>#GetLangVal('snp_ph_error_firstname')#</cfoutput>
				</cfcase>
				<cfcase value="tooshortsurname">
					<cfoutput>#GetLangVal('snp_ph_error_surname')#</cfoutput>
				</cfcase>
				<cfcase value="tooshortusername">
					<cfoutput>#GetLangVal('snp_ph_error_username1')#</cfoutput>
				</cfcase>
				<cfcase value="atcharinusername">
					<cfoutput>#GetLangVal('snp_ph_error_username2')#</cfoutput>
				</cfcase>
				<cfcase value="invalidcharinusername">
					<cfoutput>#GetLangVal('snp_ph_erro_username3')#</cfoutput>
				</cfcase>
				<cfcase value="useralreadyexists">
					<cfoutput>#GetLangVal('snp_ph_error_username4')#</cfoutput>
				</cfcase>
				<cfcase value="invalidexternaladdress">
					<cfoutput>#GetLangVal('snp_ph_error_email')#</cfoutput>
				</cfcase>
				<cfcase value="passworderror">
					<cfoutput>#GetLangVal('snp_ph_error_password')#</cfoutput>
				</cfcase>
				<cfcase value="emptystreet">
					<cfoutput>#GetLangVal('snp_ph_error_street')#</cfoutput>
				</cfcase>
				<cfcase value="errorzipcode">
					<cfoutput>#GetLangVal('snp_ph_error_zipcode')#</cfoutput>
				</cfcase>
				<cfcase value="errorcity">
					<cfoutput>#GetLangVal('snp_ph_error_city')#</cfoutput>
				</cfcase>
				<cfdefaultcase>
					Ein allgemeiner Fehler ist aufgetreten - <cfoutput>#url.error#</cfoutput>
					<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="signup unhandled error" type="html">
						<cfdump var="#url#">
						<cfdump var="#session#">
					</cfmail>
				</cfdefaultcase>
			</cfswitch>
		</div>
	</fieldset>
	<br>
	</cfif>
	
	<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('snp_pg_your_profile'))#</cfoutput>
	
	<cfscript>
		function HideRowIfMobileOffice()
			{
			if (url.product IS 'mobileoffice') {
				writeOutput('style="display:none;"');
				}
			}
	</cfscript>
	
		<div>
		<table border="0" cellspacing="0" cellpadding="5">
		  <tr <cfoutput>#HideRowIfMobileOffice()#</cfoutput>>
			<td align="right"  style="width:140px; ">
				<cfoutput>#GetLangVal('adrb_wd_company')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmcompany" value="<cfoutput>#CheckDataStored('company')#</cfoutput>" size="35">
			</td>
			<td class="addinfotext">
				<cfoutput>#GetLangVal('snp_ph_leave_empty_if_not_apply')#</cfoutput>
			</td>
		  </tr>
		  <tr>
		  	<td align="right"  style="width:140px; ">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_Sex')#</cfoutput>:
			</td>
			<td>
				<select name="frmsex">
					<option value="0" <cfoutput>#WriteSelectedElement(CheckDataStored('sex'), 0)#</cfoutput>><cfoutput>#GetLangVal('snp_wd_sex_male')#</cfoutput></option>
					<option value="1" <cfoutput>#WriteSelectedElement(CheckDataStored('sex'), 1)#</cfoutput>><cfoutput>#GetLangVal('snp_wd_sex_female')#</cfoutput></option>
				</select>		
				&nbsp;&nbsp;
				<cfoutput>#GetLangVal('snp_wd_title')#</cfoutput>:
				<input type="text" name="frmtitle" value="<cfoutput>#CheckDataStored('title')#</cfoutput>" size="5">	
			</td>
		  </tr>
		  <tr>
			<td style="width:140px; " align="right">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>:
			</td>
			<td colspan="2">
				<input type="text" name="frmfirstname" value="<cfoutput>#CheckDataStored('firstname')#</cfoutput>" size="35">
			</td>
		  </tr>
		  <tr>
			<td align="right">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>:
			</td>
			<td colspan="2">
				<input type="text" name="frmsurname" value="<cfoutput>#CheckDataStored('surname')#</cfoutput>" size="35">
			</td>
		  </tr>
		  <tr>
			<td align="right">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_street')#</cfoutput>:
			</td>
			<td colspan="2">
				<input type="text" name="frmstreet" value="<cfoutput>#CheckDataStored('street')#</cfoutput>" size="35">
			</td>
		  </tr>		
		  <tr>
			<td align="right">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>:
			</td>
			<td colspan="2">
				<input type="text" name="frmzipcode" value="<cfoutput>#CheckDataStored('zipcode')#</cfoutput>" size="35">
			</td>
		  </tr>	
		  <tr>
			<td align="right">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput>:
			</td>
			<td colspan="2">
				<input type="text" name="frmcity" value="<cfoutput>#CheckDataStored('city')#</cfoutput>" size="35">
			</td>
		  </tr>		
		  <tr>
		  	<td align="right">
				<span class="reg_req">*</span><cfoutput>#GetLangVal('adrb_wd_country')#</cfoutput>:
			</td>
			<td colspan="2">
				<select name="frmcountry" size="1" style="width:200px; ">
				
					<option value="at" <cfoutput>#writeselectedelement(CheckDataStored('country'), 'at')#</cfoutput>>Oesterreich</option>				
					<option value="de" <cfoutput>#writeselectedelement(CheckDataStored('country'), 'de')#</cfoutput>>Deutschland</option>
					<option value="ch" <cfoutput>#writeselectedelement(CheckDataStored('country'), 'ch')#</cfoutput>>Schweiz</option>
					<cfinclude template="inc_countries.html">
				</select>
				
			</td>
		  </tr>
		  <tr>
		  	<td align="right">
				<cfoutput>#GetLangVal('snp_ph_telephone_number')#</cfoutput>:
			</td>
			<td>
				<input type="text" name="frmtelephone" value="<cfoutput>#CheckDataStored('telephone')#</cfoutput>" size="35">
			</td>
		  </tr>
			
		  <!---<tr>
			<td align="right">
				Handynummer:
			</td>
			<td>
				<input type="text" name="frmmobile" value="+43 676" size="35">
			</td>
			<td class="addinfotext">
				Für SMS & MobileSync
			</td>
		  </tr>		--->  
		  <tr style="display:none; ">
			<td align="right">
				<cfoutput>#GetLangVal('snp_wd_type_business_industry')#</cfoutput>:
			</td>
			<td>
						<select name="frmindustry" style="width:200px; ">
							<option value=""><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
							<option value="AerospaceDefense"><cfoutput>#GetLangVal('cm_wd_industry_AerospaceDefense')#</cfoutput></option>
							<option value="ApparelFootwear">Bekleidung und Schuhe</option>
							<option value="Automotive">Automobil</option>
							
							<option value="Banking">Bankgeschaeft</option>
							<option value="Brokerage">Maklergeschaeft</option>
							<option value="Chemicals">Chemie</option>
							<option value="Communications">Telekommunikation</option>
							<option value="Consulting">Beratung</option>
							<option value="ConsumerGoods">Konsumgueter</option>
							<option value="Education">Weiterbildung</option>
							<option value="Electronics">Elektronik</option>
							<option value="Energy">Energie</option>
							
							<option value="Entertainment">Unterhaltung</option>
							<option value="Finance">Finanzen</option>
							<option value="Craft">Handwerk</option>
							<option value="Hardware">Hardware</option>
							<option value="Healthcare">Gesundheitswesen</option>
							<option value="High Tech">Hochtechnologie</option>
							<option value="Insurance">Versicherungen</option>
							<option value="LifeSciences">Life Sciences</option>
							<option value="Manufacturing">Produktion</option>
							<option value="Media">Medien</option>
							
							<option value="Medical">Medizin</option>
							<option value="Networking">Netzwerk</option>
							<option value="Non-profit">Karitativ</option>
							<option value="Oil&Gas">Oel und Gas</option>
							<option value="Other">Sonstiges</option>
							<option value="Pharmaceutical">Pharmazeutischer Bereich</option>
							<option value="Process">Verarbeitung</option>
							<option value="PublicSector">Oeffentlicher Sektor</option>
							<option value="Retail">Einzelhandel</option>
							
							<option value="Software">Software</option>
							<option value="Transportation">Transport</option>
							<option value="Utilities">Energieversorgung</option></select> 
			</td>
			<td class="addinfotext">
				<cfoutput>#GetLangVal('snp_ph_leave_empty_if_not_apply')#</cfoutput>
			</td>				
		  </tr>			
		  <tr style="display:none; ">
			<td align="right">
				<cfoutput>#GetLangVal('snp_ph_company_size_employees')#</cfoutput>:
			</td>
			<td>
				<select name="frmcompany_size">
					<option value="0"><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
					<option value="1"><cfoutput>#GetLangVal('snp_ph_company_size_employees_single')#</cfoutput></option>
					<option value="10">2 - 10</option>
					<option value="50">11 - 50</option>
					<option value="100">51- 100</option>
					<option value="500">101 - 500</option>
					<option value="999">&gt; 500</option>
				</select>
			</td>
			<td class="addinfotext">
				<cfoutput>#GetLangVal('snp_ph_leave_empty_if_not_apply')#</cfoutput>
			</td>		
		  </tr>	
		  <tr>
		  	<td align="right">
				<cfoutput>#GetLangVal('snp_ph_quest_source')#</cfoutput>
			</td>
			<td>
				<select name="frmsource_2">
					<option value="" SELECTED><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
					<option value="searchengine"><cfoutput>#GetLangVal('snp_ph_source_searchengine')#</cfoutput></option>
					<option value="Press/Article"><cfoutput>#GetLangVal('snp_ph_source_press')#</cfoutput></option>
					<option value="Web"><cfoutput>#GetLangVal('snp_ph_source_web')#</cfoutput></option>
					<option value="Advertising"><cfoutput>#GetLangVal('snp_ph_source_ad')#</cfoutput></option>
					<option value="Telemarketing"><cfoutput>#GetLangVal('snp_ph_source_telemarketing')#</cfoutput></option>
					<option value="Event"><cfoutput>#GetLangVal('snp_ph_source_event')#</cfoutput></option>		
					<option value="Friend/Co-Worker"><cfoutput>#GetLangVal('snp_ph_source_recommended')#</cfoutput></option>
					<option value="Other"><cfoutput>#GetLangVal('snp_ph_source_other')#</cfoutput></option>
				</select>
			</td>
		  </tr>		    	  		       
		</table>
	
		</div>	
	
	<br/>
	
	<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('snp_ph_set_username_password'))#</cfoutput>
		
		<div>
		
		
		<table border="0" cellspacing="0" cellpadding="5" style="margin-top:8px; ">
			<tr>
				<td colspan="3">
					<cfoutput>#GetLangVal('snp_ph_welcome_select_username_password')#</cfoutput>
				</td>
			</tr>
			<tr>
				<td style="font-weight:bold;width:140px;" align="right">
					<span class="reg_req">*</span><cfoutput>#GetLangVal('snp_ph_desired_username')#</cfoutput>:
				</td>
				<td>
					<input title="Erlaubt: a-z, 0-9, - und _" type="text" name="frmusername" value="<cfoutput>#CheckDataStored('username')#</cfoutput>" size="35">
				</td>
				<td>
					@ <cfoutput>#request.appsettings.properties.defaultdomain#</cfoutput>				
				</td>
			</tr>
			<tr>
				<td align="right">
					<span class="reg_req">*</span><cfoutput>#GetLangVal('snp_ph_desired_password')#</cfoutput>:
				</td>
				<td>
					<input type="password" size="35" name="frmpassword1" value="<cfoutput>#CheckDataStored('password')#</cfoutput>">
				</td>
				<td>
					<font class="addinfotext"><cfoutput>#GetLangVal('snp_ph_password_hint')#</cfoutput></font>
				</td>
			</tr>
			<tr>
				<td align="right">
					<span class="reg_req">*</span><cfoutput>#GetLangVal('snp_ph_reenter_pwd')#</cfoutput>:
				</td>
				<td>
					<input type="password" size="35" name="frmpassword2" value="<cfoutput>#CheckDataStored('password')#</cfoutput>">
				</td>
				<td></td>
			</tr>
			<tr>
				<td align="right">
					<span class="reg_req">*</span><cfoutput>#GetLangVal('snp_ph_current_email_adr')#</cfoutput>:
				</td>
				<td>
					<input type="text" name="frm_external_email" size="35" value="<cfoutput>#CheckDataStored('external_email')#</cfoutput>">
				</td>
				<td>
					<!---
					<font class="addinfotext"><cfoutput>#GetLangVal('snp_ph_current_email_adr_description')#</cfoutput></font>
					--->
				</td>
			</tr>
		</table>
	
		</div>
		
	<br/>
	
	<fieldset class="default_fieldset" style="display:none; ">
		<legend><b><img src="/images/menu/img_heads_32x32.gif" align="absmiddle"> <cfoutput>#GetLangVal('snp_ph_groupware_project_group')#</cfoutput></b></legend>
		
		<div>
			<cfoutput>#GetLangVal('snp_ph_groupware_project_group_description')#</cfoutput>
	
	<table border="0" cellspacing="0" cellpadding="5">
	  <tr id="id_tr_team_name">
		<td align="right" style="width:140px; ">
			<cfoutput>#GetLangVal('snp_ph_team_or_groupname')#</cfoutput>:
		</td>
		<td>
			<input type="text" name="frmgroupname" size="35" value="<cfoutput>#CheckDataStored('groupname')#</cfoutput>">
		</td>
	  </tr>
	  <tr id="id_tr_team_description">
		<td align="right">
			<cfoutput>#GetLangVal('cm_wd_description')#</cfoutput>:
		</td>
		<td>
			<input type="text" name="frmgroupdescription" size="35" value="<cfoutput>#CheckDataStored('groupdescription')#</cfoutput>">
		</td>
	  </tr>
	  <tr id="id_tr_team_members">
		<td valign="top" align="right">
			<cfoutput>#GetLangVal('cm_wd_members')#</cfoutput>:
		</td>
		<td valign="top" style="padding-left:4px;padding-top:4px;">
		
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td>
				<cfoutput>#GetLangVal('snp_ph_create_group_enter_addresses')#</cfoutput>
			</td>
		  </tr>
		  <cfloop from="1" to="4" index="ii">
		  <tr>
			<td>
				<cfoutput>#GetLangVal('cm_wd_member')#</cfoutput> #<cfoutput>#ii#</cfoutput>: <input type="text" name="frmmember_<cfoutput>#ii#</cfoutput>" size="30" value="<cfoutput>#CheckDataStored('member_' & ii)#</cfoutput>">
			</td>
		  </tr>
		  </cfloop>
		  <tr>
		  	<td>
		  		<cfoutput>#GetLangVal('snp_ph_groupware_further_members_admintool')#</cfoutput>
			</td>
		  </tr>
		  <!---<tr>
		  	<td>
				Text der Einladung bearbeiten ...
			</td>
		  </tr>--->
		</table>
		
		</td>
	  </tr> 
		<tr>
			<td colspan="2">
				<label for="id_cb_create_no_group"><input onClick="changecreateteam(this.checked)" type="checkbox" value="1" name="frm_create_no_team" class="noborder" id="id_cb_create_no_group"> <cfoutput>#GetLangVal('snp_ph_create_group_no_group_yet')#</cfoutput></label>
			</td>
		</tr>	   	  
	</table>
	
	</div>	
	</fieldset>
	
	
	<!--- optional settings ... do not display any more --->
	<fieldset class="default_fieldset" style="display:none; ">
		<legend><b><cfoutput>#GetLangVal('snp_ph_optional_settings')#</cfoutput></b></legend>
		
		<div>
				
		<table border="0" cellspacing="0" cellpadding="4">
		  <tr>
			<td>
				<input type="radio" name="frm_options" onClick="SetOptionsCustomize(this.value);" checked value="default" class="noborder"> <cfoutput>#GetLangVal('snp_ph_optional_settings_default')#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td>
				<input type="radio" name="frm_options" onClick="SetOptionsCustomize(this.value);" value="custom" class="noborder"> <cfoutput>#GetLangVal('snp_ph_optional_settings_custom')#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td style="display:none;padding-left:40px;" id="id_td_options_customize" nowrap>
				<input name="frmoptions" type="checkbox" value="activatecrmsales" class="noborder" checked> <cfoutput>#GetLangVal('snp_ph_optional_settings_custom_crmsales')#</cfoutput>
				<br>
				<!---<input name="frmoptions" type="checkbox" value="activefreefaxnumber" class="noborder" checked> <cfoutput>#GetLangVal('snp_ph_optional_settings_free_Fax_number')#</cfoutput>
				<br>--->
				<input name="frmoptions" type="checkbox" value="subscribenewsletter" class="noborder" checked> <cfoutput>#GetLangVal('snp_ph_optional_settings_custom_newsletter')#</cfoutput>
				<br>
				<input name="frmoptions" type="checkbox" value="subscribetnt" class="noborder" checked> <cfoutput>#GetLangVal('snp_ph_optional_settings_custom_tnt')#</cfoutput>
				<br>
				<input name="frmoptions" type="checkbox" value="bonuspoints" class="noborder" checked> <cfoutput>#GetLangVal('snp_ph_optional_settings_custom_points')#</cfoutput>
			</td>
		  </tr>
		  <!---<tR>
		  	<td>
				<a href="javascript:SetPromoKeywordVisible();"><cfoutput>#GetLangVal('snp_ph_enter_promocode_keyword')#</cfoutput></a>
			</td>
		  </tR>
		  <tr id="idpromocodekeyword" style="display:none; ">
			<td>
				<cfoutput>#GetLangVal('snp_ph_promocode_keyword')#</cfoutput>:
				<input type="text" name="frmpartnerid" value="<cfoutput>#CheckDataStored('partnerid')#</cfoutput>" size="6">
			</td>
			</tr>		--->  
		</table>
	
		</div>
	</fieldset>
	
	<br/>
	
	<cfoutput>#WriteSimpleHeaderDiv(GetLangVal('snp_ph_end_of_registration'))#</cfoutput>

	
		<div style="background-color:white;padding:10px; ">
			<input <cfoutput>#WriteCheckedElement(CheckDataStored('agbaccepted'), 1)#</cfoutput> type="checkbox" class="noborder" value="1" name="frmcbacceptagb"> <cfoutput>#GetLangVal('snp_ph_agree_to_ctc')#</cfoutput> [ <a style="text-decoration:underline;" href="/rd/agb/" target="_blank"><cfoutput>#GetLangVal('snp_ph_ctc_download_as_pdf')#</cfoutput></a> ]
			
			<br><br>
			
			<!---<cfif a_struct_administration.autoorderontrialend>
				<cfset a_str_display_text = GetLangVal('snp_ph_test_without_risk')>
				<cfset a_str_display_text = ReplaceNoCase(a_str_display_text, '%EMAILADDRESS%', ExtractEmailAdr(a_str_email_feedback), 'ALL')>
				<cfoutput>#a_str_display_text#</cfoutput>
				<br><br>
			</cfif>--->
			
			<div style="padding-left:140px; ">
			<input class="btn btn-primary" type="submit" value="<cfoutput>#GetLangVal('snp_ph_login_now')#</cfoutput>">
			</div>
		</div>
		


	
	</td>
    <td valign="top" style="padding:20px;line-height:16px;" class="mischeader bl br">
	

		
		<!---<b><cfoutput>#GetLangVal('snp_pg_explain_how_simple')#</cfoutput></b>
		<br>
		<cfoutput>#GetLangVal('snp_pg_explain_how_simple_description')#</cfoutput>
		<br><br>--->
		
		
		
		<!--- affiliate information ... --->
		<cfinclude template="dsp_inc_affiliate.cfm">
		
		<b><cfoutput>#GetLangVal('cm_ph_important_links')#</cfoutput></b>
		<br />
		<a href="/rd/privacy/" target="_blank"><img height="9" width="9" src="/images/arrows/img_indent_small.png" align="absmiddle" border="0" vspace="6" hspace="6"> <cfoutput>#GetLangVal('start_ph_privacy_policy')#</cfoutput></a>
		<br />
		<a href="/rd/pricelist/" target="_blank"><img height="9" width="9" src="/images/arrows/img_indent_small.png" align="absmiddle" border="0" vspace="6" hspace="6"> <cfoutput>#GetLangVal('hpg_wd_pricelist')#</cfoutput></a>
		<br />
		<a href="/rd/about/" target="_blank"><img height="9" width="9" src="/images/arrows/img_indent_small.png" align="absmiddle" border="0" vspace="6" hspace="6"> <cfoutput>#GetLangVal('hpg_wd_about')#</cfoutput></a>
		
		<br><br>
		<span class="reg_req">*</span> = <cfoutput>#GetLangVal('snp_ph_required_field')#</cfoutput>
	</td>
  </tr>
</table>
</form>



<!---
<cfif cgi.SERVER_PORT IS '80'>
	<!-- mymon_form_log -->
	<script language="JavaScript1.1" src="http://inbox.log.checkeffect.at/mymon_form_log.js" type="text/javascript"></script>
	<script language="JavaScript1.1"><!--
	TryCookie('mymon_form_log_1');
	var form_url = "http://inbox.log.checkeffect.at/?u=inbox&t=1&js=1&a=view&r=" + GetCookie('mymon_form_log_1');
	document.write("<img src=\"" + form_url + "\" width=1 height=1 border=0>"); 
	//-->
	</script>
	<NOSCRIPT><IMG SRC="http://inbox.log.checkeffect.at/?u=inbox&t=1&a=view&r=0&js=0" width=1 height=1 BORDER=0></NOSCRIPT>
	<!-- /mymon_form_log -->
<cfelse>
	<!--- https code --->
	<script language="JavaScript1.1" src="https://checkeffect.at/mymon_form_log.js" type="text/javascript"></script>
	<script language="JavaScript1.1"><!--
	TryCookie('mymon_form_log_1');
	var form_url = "https://checkeffect.at/?u=inbox&t=1&js=1&a=view&r=" + GetCookie('mymon_form_log_1');
	document.write("<img src=\"" + form_url + "\" width=1 height=1 border=0>"); 
	//-->
	</script>
	<NOSCRIPT><IMG SRC="https://checkeffect.at/?u=inbox&t=1&a=view&r=0&js=0" width=1 height=1 BORDER=0></NOSCRIPT>
</cfif>

--->