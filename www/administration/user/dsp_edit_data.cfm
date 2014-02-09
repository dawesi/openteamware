<!--- //
	
	daten editieren
	
	// --->
	
	
<cfoutput query="q_userdata">
<form action="user/act_update_user.cfm" method="post">
<input type="hidden" name="frmentrykey" value="#q_userdata.entrykey#">
<input type="hidden" name="frmcompanykey" value="#url.companykey#">
<input type="hidden" name="frmresellerkey" value="#url.resellerkey#">
<table border="0" cellspacing="0" cellpadding="4">
	<tr>
		<td align="right">
			#GetLangVal('cm_wd_status')#:
		</td>
		<td>
			<select name="frmactivitystatus" disabled>
				<option #writeselectedelement(q_userdata.activitystatus, 0)# value="0">#GetLangVal('cm_wd_inactive')#</option>
				<option #writeselectedelement(q_userdata.activitystatus, 1)# value="1">#GetLangVal('cm_wd_active')#</option>
			</select>
		</td>
	</tr>
	<tr>
		<td></td>
		<td>
			#GetLangVal('adm_ph_inactive_description')#
		</td>
	</tr>
  <tr>
    <td align="right">#GetLangVal('adrb_wd_firstname')#:</td>
    <td>
		<input type="text" name="frmfirstname" value="#htmleditformat(q_userdata.firstname)#" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('adrb_wd_surname')#:</td>
    <td>
		<input type="text" name="frmsurname" value="#htmleditformat(q_userdata.surname)#" size="30">
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adrb_wd_sex')#:</td>
	<td>
		<select name="frmsex">
			<option value="0" #writeselectedelement(q_userdata.sex,0)#>#GetLangVal('adrb_wd_sex_male')#</option>
			<option value="1" #writeselectedelement(q_userdata.sex,1)#>#GetLangVal('adrb_wd_sex_female')#</option>
		</select>
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('cm_ph_iden_code_short_member')#:</td>
	<td>
		<input type="text" name="frm_identification_code" value="#htmleditformat(q_userdata.IDENTIFICATIONCODE)#" size="10" maxlength="10">
	</td>
  </tr>
  <tr>
	<td align="right">
		#GetLangVal('cm_wd_language')#:
	</td>
	<td>
		<select name="frmlanguage">
			<cfloop from="0" to="5" index="ii">
				<option #writeSelectedElement(q_userdata.defaultlanguage, ii)# value="#ii#">#application.components.cmp_lang.GetLanguageShortNameByNumber(ii)#</option>
			</cfloop>
		</select>		
	</td>
  </tr>  
  <tr>
    <td align="right">#GetLangVal('adrb_wd_street')#:</td>
    <td>
		<input type="text" name="frmstreet" value="#htmleditformat(q_userdata.address1)#" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('adrb_wd_zipcode')#:</td>
    <td>
		<input type="text" name="frmzipcode" value="#htmleditformat(q_userdata.plz)#" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('adrb_wd_city')#:</td>
    <td>
		<input type="text" name="frmcity" value="#htmleditformat(q_userdata.city)#" size="30">
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('cm_wd_mobile')#:</td>
	<td>
		<input type="text" name="frmmobilrnr" value="#htmleditformat(q_userdata.mobilenr)#" size="30">
	</td>
  </tr>
  <tr>
    <td align="right">#GetLangVal('cm_wd_timezone')#:</td>
    <td>
		<select name="frmtimeZone" size="1" tabindex="1" alt="Time Zone">
			<option value="12" #writeselectedelement(q_userdata.utcdiff, 12)#> GMT -12:00 Dateline : Eniwetok, Kwajalein, Fiji, New Zealand
			<option value="11" #writeselectedelement(q_userdata.utcdiff, 11)#> GMT -11:00 Samoa : Midway Island, Samoa
			<option value="10" #writeselectedelement(q_userdata.utcdiff, 10)#> GMT -10:00 Hawaiian : Hawaii
			<option value="9" #writeselectedelement(q_userdata.utcdiff, 9)#> GMT -09:00 Alaskan : Alaska
			<option value="8" #writeselectedelement(q_userdata.utcdiff, 8)#> GMT -08:00 Pacific Time (U.S. & Canada)
			<option value="7" #writeselectedelement(q_userdata.utcdiff, 7)#> GMT -07:00 Mountain : Mountain Time (US & Can.)
			<option value="7" #writeselectedelement(q_userdata.utcdiff, 7)#>GMT -07:00 Arizona : Mountain Time (US & Can.)
			<option value="6" #writeselectedelement(q_userdata.utcdiff, 6)#> GMT -06:00 Central Time (U.S. & Canada), Mexico City
			<option value="5" #writeselectedelement(q_userdata.utcdiff, 5)#> GMT -05:00 Eastern Time (U.S & Can.), Bogota, Lima
			<option value="4" #writeselectedelement(q_userdata.utcdiff, 4)#> GMT -04:00 Atlantic Time (Canada), Caracas, La Paz
			<option value="3" #writeselectedelement(q_userdata.utcdiff, 3)#> GMT -03:00 Brasilia, Buenos Aires
			<option value="2" #writeselectedelement(q_userdata.utcdiff, 2)#> GMT -02:00 Mid-Atlantic
			<option value="1" #writeselectedelement(q_userdata.utcdiff, 1)#> GMT -01:00 Azores : Azores, Cape Verde Is.
			<option value="0" #writeselectedelement(q_userdata.utcdiff, 0)#> GMT 0 Greenwich Mean Time : Dublin, Lisbon, London
			<option value="-1" #writeselectedelement(q_userdata.utcdiff, -1)#> GMT +01:00 Western &amp; Central Europe
			<option value="-2" #writeselectedelement(q_userdata.utcdiff, -2)#> GMT +02:00 East. Europe, Egypt, Finland, Israel, S. Africa
			<option value="-3" #writeselectedelement(q_userdata.utcdiff, -2)#> GMT +03:00 Russia, Saudi Arabia, Nairobi
			<option value="-3" #writeselectedelement(q_userdata.utcdiff, -3)#> GMT +03:30 Iran
			<option value="-4" #writeselectedelement(q_userdata.utcdiff, -4)#> GMT +04:00 Arabian : Abu Dhabi, Muscat
			<option value="-5" #writeselectedelement(q_userdata.utcdiff, -5)#> GMT +05:00 West Asia : Islamabad, Karachi
			<option value="-6" #writeselectedelement(q_userdata.utcdiff, -6)#> GMT +06:00 Central Asia : Almaty, Dhaka, Colombo
			<option value="-7" #writeselectedelement(q_userdata.utcdiff, -7)#> GMT +07:00 Bangkok, Hanoi, Jakarta
			<option value="-8" #writeselectedelement(q_userdata.utcdiff, -8)#> GMT +08:00 China, Singapore, Taiwan, W. Australia
			<option value="-9" #writeselectedelement(q_userdata.utcdiff, -9)#> GMT +09:00 Korea, Japan
			<option value="-9" #writeselectedelement(q_userdata.utcdiff, -9)#> GMT +09:30 Cen. Australia : Adelaide
			<option value="-10" #writeselectedelement(q_userdata.utcdiff, -10)#> GMT +10:00 E. Australia : Brisbane, Vladivostok, Guam
			<option value="-11" #writeselectedelement(q_userdata.utcdiff, -11)#> GMT +11:00 Central Pacific : Magadan, Sol. Is.
		</select>	
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('prf_ph_daylightsaving')#:</td>
	<td>
		<select name="frmdaylightsavinghours">
			<option value="0" #writeselectedelement(q_userdata.daylightsavinghours,0)#>#GetLangVal('cm_wd_no')#</option>
			<option value="-1" #writeselectedelement(q_userdata.daylightsavinghours,-1)#>#GetLangVal('cm_wd_yes')#</option>
		</select>

	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adrb_wd_department')#:</td>
	<td>
		<input type="text" name="frmdepartment" value="#htmleditformat(q_userdata.department)#" size="30">
	</td>
  </tr>
  <tr>
  	<td align="right">#GetLangVal('adrb_wd_position')#:</td>
	<td>
		<input type="text" name="frmposition" value="#htmleditformat(q_userdata.aposition)#" size="30">
	</td>
  </tr>
  <tr>
  	<td align="right">
		#GetLangVal('adm_ph_external_address')#:
	</td>
	<td>
		<input type="text" name="frmexternalemail" value="#htmleditformat(q_userdata.email)#" size="30">
	</td>
  </tr>  
  <tr>
  	<td></td>
	<td>
		<input type="submit" name="frmsubmit" value="#GetLangVal('cm_wd_save')#">
	</td>
  </tr>

</table>
</form>
</cfoutput>