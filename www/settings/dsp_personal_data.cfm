<!--- //

	Module:		Settings
	Action:		Personaldata
	Description:Let the user edit personal data
	

// --->


<cfparam name="url.message" type="string" default="">

<cfset tmp = SetHeaderTopInfoString(GetLangVal('prf_ph_personal_data_name_tel'))>


<!--- load personal data --->
<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn">
	<cfinvokeargument name="entrykey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfset q_user_data = stReturn.query>

<cfif Len(url.message) gt 0>
	<!--- display information (f.e. "updated") .... --->
	<br><b><img src="/images/info.jpg" hspace="2" vspace="2" border="0" align="absmiddle" alt="">&nbsp;<cfoutput>#url.message#</cfoutput>!</b>
	<br>
</cfif>



<form action="act_save_personal_data.cfm" method="POST" enablecab="No">
<table class="table_details table_edit_form">
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>
	</td>
	<td>
		<input type="Text" name="frmFirstname" value="<cfoutput>#htmleditformat(q_user_data.firstname)#</cfoutput>" required="No" size="30" maxlength="50">
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>
	</td>
	<td>
		<input type="Text" name="frmSurname" value="<cfoutput>#htmleditformat(q_user_data.surname)#</cfoutput>" required="No" size="30" maxlength="50">
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_organisation')#</cfoutput>
	</td>
	<td>
		<input type="text" name="frmorganization" value="<cfoutput>#htmleditformat(q_user_data.organization)#</cfoutput>"  size="30" maxlength="50">
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_sex')#</cfoutput>
	</td>
	<td>
		<input <cfif q_user_data.sex is 1>checked</cfif> type="Radio" value="1" name="frmSex" class="noborder">&nbsp;<cfoutput>#GetLangVal('adrb_wd_sex_female')#</cfoutput>
		&nbsp;&nbsp;&nbsp;
		<input <cfif q_user_data.sex is 0>checked</cfif> type="Radio" value="0" name="frmSex" class="noborder">&nbsp;<cfoutput>#GetLangVal('adrb_wd_sex_male')#</cfoutput>
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_street')#</cfoutput>:
	</td>
	<td>
			<input type="Text" name="frmAddress" value="<cfoutput>#htmleditformat(q_user_data.address1)#</cfoutput>" required="No" size="30" maxlength="50">
	</td>
</tr>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('adrb_wd_zipcode')#</cfoutput>
	</td>
	<td><input type="Text" name="frmPLZ" value="<cfoutput>#htmleditformat(q_user_data.plz)#</cfoutput>" required="No" size="6" maxlength="6"></td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('adrb_wd_city')#</cfoutput></td>
	<td><input type="Text" name="frmCity" value="<cfoutput>#htmleditformat(q_user_data.city)#</cfoutput>" required="No" size="30" maxlength="60"></td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('adrb_wd_country')#</cfoutput></td>
	<td><input type="Text" name="frmCountry" value="<cfoutput>#htmleditformat(q_user_data.country)#</cfoutput>" required="No" size="30" maxlength="60"></td>
</tr>
<!--- <tr>
	<td class="field_name"><cfoutput>#GetLangVal('mail_ph_alert_mobile_nr')#</cfoutput></td>
	<td><cfoutput>#request.a_struct_personal_properties.mymobiletelnr#</cfoutput></td>
</tr>
<tr>
	<td  style="font-size:10px;" align="right" valign="top"></td>
	<td style="font-size:10px;">
	<a href="default.cfm?action=wireless"><cfoutput>#GetLangVal('prf_ph_link_change_mobile_nr')#</cfoutput></a></td>
</tr> --->
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('cm_wd_language')#</cfoutput>
	</td>
	<td>
	<input class="noborder" <cfif request.a_struct_personal_properties.myDefaultLanguage is 0>checked</cfif> type="Radio" name="frmDefaultLanguage" value="0"> DE (Deutsch)
	&nbsp;
	<input class="noborder" <cfif request.a_struct_personal_properties.myDefaultLanguage is 1>checked</cfif> type="Radio" name="frmDefaultLanguage" value="1"> EN (English)
	&nbsp;
	<input class="noborder" <cfif request.a_struct_personal_properties.myDefaultLanguage is 4>checked</cfif> type="Radio" name="frmDefaultLanguage" value="4"> PL (Polski)
	&nbsp;
	<input class="noborder" <cfif request.a_struct_personal_properties.myDefaultLanguage is 2>checked</cfif> type="Radio" name="frmDefaultLanguage" value="2"> CZ
	&nbsp;
	<input class="noborder" <cfif request.a_struct_personal_properties.myDefaultLanguage is 3>checked</cfif> type="Radio" name="frmDefaultLanguage" value="3"> SK
	&nbsp;
	<input class="noborder" <cfif request.a_struct_personal_properties.myDefaultLanguage is 5>checked</cfif> type="Radio" name="frmDefaultLanguage" value="5"> RO
	
	</td>
</tr>
<input type="hidden" name="frmICQNumber" value="" />
<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	SubscrNewsletter,SubscrNewsletterAddress,email,SubscribeTippsntricks,email
FROM
	users
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">
;
</cfquery>
<tr>
	<td class="field_name">
		<cfoutput>#GetLangVal('prf_ph_misc_settings_newsletters')#</cfoutput>
	</td>
	<td><input class="noborder" type="checkbox" name="frmSubScrNewsletter" value="1" <cfif q_select.subscrNewsletter is 1>checked</cfif>></td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_address_for_newsletters')#</cfoutput></td>
	<td>
	<cfif q_select.SubscrNewsletterAddress is "">
		<cfset ANewsletterAdr = request.stSecurityContext.myuserid>
	<cfelse>
		<cfset ANewsletteradr = q_Select.SubscrNewsletterAddress>
	</cfif>
	<input type="text" value="<cfoutput>#ANewsletterAdr#</cfoutput>" name="frmSubscrNewsletterAddress" size="30" maxlength="150">
	</td>
</tr>
<tr>
	<td class="field_name"><cfoutput>#GetLangVal('prf_ph_address_for_password')#</cfoutput></td>
	<td>
	<input type="text" name="frmEmail" value="<cfoutput>#q_select.email#</cfoutput>" size="30" maxlength="100">
	</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" value="<cfoutput>#GetLangVal('cm_wd_save')#</cfoutput>"></td>
</tr>
</table>
</form>


