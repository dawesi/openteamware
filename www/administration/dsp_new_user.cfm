<!--- //

	Module:		Admintool
	Action:		Newuser
	Description:Form for creating a new user
	
// --->
<cfparam name="url.productkey" type="string" default="">

<cfinclude template="dsp_inc_select_company.cfm">

<!--- is company in trial phase? --->
<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="queries/q_select_company_data.cfm">
<cfset tmp = SetHeaderTopInfoString(GetLangVal('adm_ph_add_user_now')) />
	
<!--- check if there are still users avaliable ... otherwise move to shop ... --->

<!--- single place... --->
<cfinvoke component="/components/licence/cmp_licence" method="GetLicenceStatus" returnvariable="q_select_licence_professional">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="productkey" value="AD4262D0-98D5-D611-4763153818C89190">
</cfinvoke>

<!--- groupware ... --->
<cfinvoke component="/components/licence/cmp_licence" method="GetLicenceStatus" returnvariable="q_select_licence_groupware">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
</cfinvoke>

<cfif Len(url.productkey) IS 0>

	<b><cfoutput>#GetLangVal('adm_ph_new_account_choose_type')#</cfoutput></b>
	<form action="index.cfm" method="get">
		<input type="hidden" name="action" value="newuser">
		<input type="hidden" name="companykey" value="<cfoutput>#url.companykey#</cfoutput>">
		<input type="hidden" name="resellerkey" value="<cfoutput>#url.resellerkey#</cfoutput>">
		
		<table border="0" cellspacing="0" cellpadding="8">
		  <tr class="lightbg">
		  	<td>&nbsp;</td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_new_account_type')#</cfoutput>
			</td>
			
			<cfif q_select_company_data.status IS 0>
				<td>
					<cfoutput>#GetLangVal('adm_ph_licences_available')#</cfoutput>
				</td>
				<td>
					<cfoutput>#GetLangVal('adm_ph_licences_in_use')#</cfoutput>
				</td>
			</cfif>
		  </tr>
		  <tr>
		  	<td>
				<input checked align="absmiddle" type="radio" name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319" class="noborder">
			</td>
			<td>
			 <b>Mobile CRM</b><br>
			 <cfoutput>#GetLangVal('adm_ph_new_account_type_groupware_description')#</cfoutput>
			</td>
			
			<cfif q_select_company_data.status IS 0>
				<td align="right">
				<cfoutput>#val(q_select_licence_groupware.availableseats)#</cfoutput>
				</td>
				<td align="right">
				<cfoutput>#val(q_select_licence_groupware.inuse)#</cfoutput>
				</td>
			</cfif>
		  </tr>
		  <tr>
		  	<td>
				<input align="absmiddle" type="radio" name="productkey" value="AD4262D0-98D5-D611-4763153818C89190" class="noborder">
			</td>
			<td>
			 <b>Mobile Office (<cfoutput>#GetLangVal('adm_ph_single_seat')#</cfoutput>)</b><br>
			 <cfoutput>#GetLangVal('adm_ph_new_account_type_pro_description')#</cfoutput>
			</td>
			
			<cfif q_select_company_data.status IS 0>
				<td align="right">
				<cfoutput>#val(q_select_licence_professional.availableseats)#</cfoutput>
				</td>
				<td align="right">
				<cfoutput>#val(q_select_licence_professional.inuse)#</cfoutput>
				</td>
			</cfif>
		  </tr>
		  <tr>
			<td class="bt">&nbsp;</td>
			<td class="bt">
				<input class="btn btn-primary" type="submit" value="<cfoutput>#GetLangVal('cm_wd_proceed')#</cfoutput> ...">
			</td>
			<td class="bt" colspan="2">&nbsp;</td>
		  </tr>
		</table>		
	</form>

<cfexit method="exittemplate">
</cfif>

<!--- check if this user is in trial phase - in this case let him create x users for free --->
<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company_data">
	<cfinvokeargument name="entrykey" value="#url.companykey#">
</cfinvoke>

<cfinvoke component="#request.a_str_component_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
	<cfinvokeargument name="companykey" value="#url.companykey#">
	<cfinvokeargument name="productkey" value="#url.productkey#">
</cfinvoke>

<cfif q_select_company_data.status IS 0 AND val(q_select_licence_status.availableseats) IS 0>
	<b><cfoutput>#GetLangVal('adm_ph_new_account_licences_needed')#</cfoutput></b>
	<br><br><br>
	<b><a href="index.cfm?action=shop<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_licence_status_add_goto_shop')#</cfoutput></a></b>
	<br><br>
	<cfoutput>#GetLangVal('hpg_ph_shop_need_consulting')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>

<cfset SelectCompanyUsersRequest.companykey = url.companykey>
<cfinclude template="queries/q_select_company_users.cfm">

  <form action="act_new_user.cfm" method="post" name="formadduser" style="margin:0px; ">
  	<input type="hidden" name="frmresellerkey" value="<cfoutput>#htmleditformat(url.resellerkey)#</cfoutput>">
    <input type="hidden" name="frmcompanykey" value="<cfoutput>#htmleditformat(url.companykey)#</cfoutput>">
	<input type="hidden" name="frmproductkey" value="<cfoutput>#url.productkey#</cfoutput>">

<table class="table table_details table_edit_form">
	<tr>
		<td class="field_name"><b><cfoutput>#GetLangVal('adm_wd_customer')#</cfoutput>:</b></td>
		<td>
		<b><cfoutput>#htmleditformat(q_select_company_data.companyname)#</cfoutput></b>
		</td>
	</tr>
	<tr>
		<td class="field_name"><cfoutput>#GetLangVal('adm_ph_new_account_type')#</cfoutput>:</td>
		<td>
			<cfswitch expression="#url.productkey#">
				<cfcase value="AE79D26D-D86D-E073-B9648D735D84F319">Mobile CRM</cfcase>
				<cfcase value="AD4262D0-98D5-D611-4763153818C89190">Mobile Office</cfcase>
			</cfswitch>
		</td>
	</tr>
	<cfif q_select_company_users.recordcount IS 0>
		<tr>
			<td class="field_name"></td>
			<td>
				<cfoutput>#GetLangVal('adm_ph_new_account_first_account_admin_hint')#</cfoutput>
			</td>
		</tr>
	</cfif>
    <tr> 
      <td class="field_name">
	  	<cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>:
	  </td>
      <td> <input type="text" name="frmusername" size="30">@
	  <select name="frmdomain">
	  <cfloop list="#q_select_company_data.domains#" delimiters="," index="a_str_domain">
	  	<cfset a_str_domain = trim(a_str_domain)>
	  	<option value="<cfoutput>#htmleditformat(a_str_domain)#</cfoutput>"><cfoutput>#a_str_domain#</cfoutput></option>
	  </cfloop>
	  </select>
		</td>
    </tr>
    <tr> 
      <td class="field_name"></td>
      <td> [ <a href="javascript:CheckUsernameAvaliable();"><cfoutput>#GetLangVal('adm_ph_new_account_check_username_available')#</cfoutput></a> ... ] </td>
    </tr>
	<tr>
		<td class="field_name"></td>
		<td>
		<select name="frmsex">
          <option value="-1"></option>
          <option value="0"><cfoutput>#GetLangVal('cm_wd_male')#</cfoutput></option>
          <option value="1"><cfoutput>#GetLangVal('cm_wd_female')#</cfoutput></option>
        </select>
		</td>
	</tr>
    <tr> 
      <td class="field_name"><cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>:</td>
      <td> <input type="text" name="frmfirstname" size="30"> </td>
    </tr>
    <tr> 
      <td class="field_name"><cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>:</td>
      <td> <input type="text" name="frmsurname" size="30"> </td>
    </tr>
	<tr>
		<td class="field_name"><cfoutput>#GetLangVal('adrb_wd_department')#</cfoutput>:</td>
		<td>
			<input type="text" name="frmdepartment" size="30">
		</td>
	</tr>
	<tr>
		<td class="field_name"><cfoutput>#GetLangVal('adrb_wd_position')#</cfoutput>:</td>
		<td>
			<input type="text" name="frmposition" size="30">
		</td>
	</tr>
	<tr>
		<td class="field_name">
			<cfoutput>#GetLangVal('cm_wd_language')#</cfoutput>:
		</td>
		<td>
			<select name="frmlanguage">
				<cfloop from="0" to="5" index="ii">
					<cfoutput>
					<option #writeSelectedElement(q_select_company_data.language, ii)# value="#ii#">#application.components.cmp_lang.GetLanguageShortNameByNumber(ii)#</option>
					</cfoutput>
				</cfloop>
			</select>		
		</td>
	</tr>
	<tr>
		<td class="field_name"><cfoutput>#GetLangVal('adm_ph_external_address')#</cfoutput> (<cfoutput>#GetLangVal('cm_wd_email')#</cfoutput>):</td>
		<td>
			<input type="text" name="frmexternalemail" size="30" value="<cfoutput>#htmleditformat(q_select_company_data.email)#</cfoutput>">
		</td>
	</tr>
	<cfif q_select_company_data.status IS 1>
		<script type="text/javascript">
			function setemail()
				{
				document.formadduser.frmexternalemail.value = '<cfoutput>#jsstringformat(q_select_company_data.email)#</cfoutput>';
				}
		</script>
		<tr>
			<td class="field_name"></td>
			<td>
				<cfoutput>#GetLangVal('adrb_wd_email_address')#</cfoutput> (<cfoutput>#GetLangVal('adm_ph_nav_account_data')#</cfoutput>): <cfoutput>#q_select_company_data.email#</cfoutput> [<a href="javascript:setemail();"><cfoutput>#GetLangVal('cm_wd_use')#</cfoutput></a>]
			</td>
		</tr>
	</cfif>
    <tr> 
      <td class="field_name"><cfoutput>#GetLangVal('cm_wd_password')#</cfoutput>:</td>
      <td valign="top">
	  	<input type="radio" class="noborder" checked name="frmpasswordtype" value="1"> <cfoutput>#GetLangVal('adm_ph_new_account_password_random')#</cfoutput><br>
	    <input type="radio" class="noborder" name="frmpasswordtype" value="2"> <input onClick="SetCustomPasswordType();" type="password" name="frmpassword" size="10"> </td>
    </tr>
	
	<script type="text/javascript">
		function SetCustomPasswordType()
			{
			var obj1;
			
			obj1 = findObj('frmpasswordtype');
			
			for (var i=0; i<obj1.length; i++) if (obj1[i].value == 2)
				{
				obj1[i].checked = true;
				}
			}
	</script>
    <tr> 
      <td class="field_name"><cfoutput>#GetLangVal('cm_wd_timezone')#</cfoutput>:</td>
      <td>
	  	<!---<select name="frmutcdiff">
          <option value="-1">MEZ ... Deutschland, Oesterreich, Schweiz, ... (UTC -1)</option>
        </select>--->
		
		<select name="frmutcdiff" size="1" tabindex="1" alt="Time Zone">
		<option value="12"> GMT -12:00 Dateline : Eniwetok, Kwajalein, Fiji, New Zealand
		<option value="11"> GMT -11:00 Samoa : Midway Island, Samoa
		<option value="10"> GMT -10:00 Hawaiian : Hawaii
		<option value="9"> GMT -09:00 Alaskan : Alaska
		<option value="8"> GMT -08:00 Pacific Time (U.S. & Canada)
		<option value="7"> GMT -07:00 Mountain : Mountain Time (US & Can.)
		<option value="7">GMT -07:00 Arizona : Mountain Time (US & Can.)
		<option value="6"> GMT -06:00 Central Time (U.S. & Canada), Mexico City
		<option value="5"> GMT -05:00 Eastern Time (U.S & Can.), Bogota, Lima
		<option value="4"> GMT -04:00 Atlantic Time (Canada), Caracas, La Paz
		<option value="3"> GMT -03:00 Brasilia, Buenos Aires
		<option value="2"> GMT -02:00 Mid-Atlantic
		<option value="1"> GMT -01:00 Azores : Azores, Cape Verde Is.
		<option value="0"> GMT 0 Greenwich Mean Time : Dublin, Lisbon, London
		<option value="-1" selected> GMT +01:00 Western &amp; Central Europe
		<option value="-2"> GMT +02:00 East. Europe, Egypt, Finland, Israel, S. Africa
		<option value="-3"> GMT +03:00 Russia, Saudi Arabia, Nairobi
		<option value="-3"> GMT +03:30 Iran
		<option value="-4"> GMT +04:00 Arabian : Abu Dhabi, Muscat
		<option value="-5"> GMT +05:00 West Asia : Islamabad, Karachi
		<option value="-6"> GMT +06:00 Central Asia : Almaty, Dhaka, Colombo
		<option value="-7"> GMT +07:00 Bangkok, Hanoi, Jakarta
		<option value="-8"> GMT +08:00 China, Singapore, Taiwan, W. Australia
		<option value="-9"> GMT +09:00 Korea, Japan
		<option value="-9"> GMT +09:30 Cen. Australia : Adelaide
		<option value="-10"> GMT +10:00 E. Australia : Brisbane, Vladivostok, Guam
		<option value="-11"> GMT +11:00 Central Pacific : Magadan, Sol. Is.
		</select>		
		
		
	  </td>
    </tr>
    <tr> 
      <td class="field_name">&nbsp;</td>
      <td><input type="submit" name="frmsubmit" value="<cfoutput>#GetLangVal('adm_ph_add_user_now')#</cfoutput>" class="btn btn-primary" /></td>
    </tr>

</table>
  </form>
<script type="text/javascript">
	
	function CheckUsernameAvaliable()

		{

		// check if this username is still avaliable ...
		mywindow=open('show_check_username_avaliable','show_check_username_avaliable','resizable=no,width=350,height=270');

	    mywindow.location.href = 'show_check_username_avaliable.cfm?username='+escape(document.formadduser.frmusername.value)+'@'+escape(document.formadduser.frmdomain.value);

	    if (mywindow.opener == null) mywindow.opener = self;

		mywindow.focus();		

		}

</script>
<script type="text/javascript">
<!--//
objForm = new qForm("formadduser");
// make these fields required
objForm.required("frmusername, frmsurname");
//-->

</SCRIPT>



