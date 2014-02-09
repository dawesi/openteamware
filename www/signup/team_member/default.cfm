<!--- //

	signup form for team members invited by the subscriber ...
	
	// --->
	
<cfprocessingdirective pageencoding="UTF-8">

<cfinclude template="/common/scripts/script_utils.cfm">
	
<cfparam name="url.error" type="string" default="">
<cfparam name="url.k" type="string" default="">

<!--- load data ... --->
<cfinclude template="queries/q_select_signup_address.cfm">
<cfinclude template="queries/q_select_workgroup_properties.cfm">

<cfif q_select_signup_address.recordcount IS 0>
	Job already done.
	<cfabort>
</cfif>

<cfscript>
	function CheckDataStored(s)
		{
		if (StructKeyExists(session, 'a_struct_data') AND StructKeyExists(session.a_struct_data, s))
			{
			return session.a_struct_data[s];
			}
				else return '';
		}
</cfscript>

<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company">
	<cfinvokeargument name="entrykey" value="#q_select_signup_address.companykey#">
</cfinvoke>

<cfset a_cmp_customize = application.components.cmp_customize>
<cfset a_struct_medium_logo = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = request.appsettings.default_stylesheet, entryname = 'medium_logo')>

<!--- structure holding data --->
<cfif NOT StructKeyExists(session, 'a_struct_data')>
	<cfset session.a_struct_data = StructNew()>
</cfif>

<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<cfinclude template="../../common/js/inc_js.cfm">
	<title><cfoutput>#request.appsettings.description#</cfoutput> | <cfoutput>#GetLangVal('cm_wd_signup')#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<script type="text/javascript">
		function ShowUsernameAlternatives()
			{
			var obj1;
			obj1 = findObj('id_tr_select_own_username');
			obj1.style.display = '';
			
			obj1 = findObj('id_tr_username_proposal');
			obj1.style.display = 'none';
			}
	</script>
</head>

<body style="padding:10px;padding-top:45px;text-align:center;background-color:#EAE7E3; ">

<form action="act_check_data.cfm" method="post" style="margin:0px; ">
<input type="hidden" name="frmentrykey" value="<cfoutput>#htmleditformat(url.k)#</cfoutput>">

	<div style="width:740px;background-color:gray;color:white;padding:8px;font-weight:bold;text-align:left;">
		<cfoutput>#GetLangVal('snp_ph_team_invite_finish_reg_user')#</cfoutput>
	</div>
	
	<div class="b_all" style="padding:10px;width:740px;text-align:left;background-color:white;">
	
	<fieldset class="default_fieldset">
			<legend><cfoutput>#GetLangVal('cm_wd_information')#</cfoutput></legend>
			<div style="line-height:20px; ">
			
				<img height="<cfoutput>#a_struct_medium_logo.height#</cfoutput>" width="<cfoutput>#a_struct_medium_logo.width#</cfoutput>" align="right" vspace="6" hspace="6" border="0" src="<cfoutput>#a_struct_medium_logo.path#</cfoutput>">
				<cfoutput>#ReplaceNoCase(GetLangVal('snp_pg_invite_team_welcome_text'), chr(10), '<br>', 'ALL')#</cfoutput>
				
			</div>
	</fieldset>
		
	<br>
	
	<cfif Len(url.error) GT 0>
	
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
				<cfcase value="passwordtooshort">
					<cfoutput>#GetLangVal('snp_ph_error_password_too_short')#</cfoutput>
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
	
	<fieldset class="default_fieldset">
		<legend style="font-weight:bold; ">
			<img src="/images/menu/img_heads_32x32.gif" align="absmiddle"> <cfoutput>#GetLangVal('snp_pg_your_profile')#</cfoutput>
		</legend>
		<div>
		
			<table cellpadding="8" cellspacing="0" border="0">
				<tr>
					<td>
					

					
					<table border="0" cellspacing="0" cellpadding="6">
						<tr>
							<td align="right">
								<cfoutput>#GetLangVal('cm_wd_salutation')#</cfoutput>:
							</td>
							<td>
							<select name="frmsex">
									<option value="-1"><cfoutput>#GetLangVal('cm_ph_please_select_option')#</cfoutput></option>
									<option value="1" <cfoutput>#WriteSelectedElement(CheckDataStored('sex'), 1)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_female')#</cfoutput></option>
									<option value="0" <cfoutput>#WriteSelectedElement(CheckDataStored('sex'), 0)#</cfoutput>><cfoutput>#GetLangVal('cm_wd_male')#</cfoutput></option>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">
									<cfoutput>#GetLangVal('adrb_wd_firstname')#</cfoutput>:
							</td>
							<td>
								<input type="text" name="frmfirstname" size="20" value="<cfoutput>#htmleditformat(CheckDataStored('firstname'))#</cfoutput>">
							</td>
						</tr>
						<tr>
							<td align="right">
									<cfoutput>#GetLangVal('adrb_wd_surname')#</cfoutput>:
							</td>
							<td>
								<input type="text" name="frmsurname" size="20" value="<cfoutput>#htmleditformat(CheckDataStored('surname'))#</cfoutput>">
							</td>
						</tr>				
					  <tr id="id_tr_username_proposal">
						<td align="right" valign="top">
							<cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>:
						</td>
						<td valign="top">
						
							<!--- check usernames ... --->
							<cfset a_str_username_1 = Mid(q_select_signup_address.emailadr, 1, FindNoCase('@', q_select_signup_address.emailadr) - 1) & '@' & ListGetAt(q_select_company.domains, 1)>
							
							<b><cfoutput>#a_str_username_1#</cfoutput></b>
							
							<input type="hidden" name="frm_default_username" value="<cfoutput>#htmleditformat(a_Str_username_1)#</cfoutput>">
							
							<br><br>
							<a href="javascript:ShowUsernameAlternatives();"><cfoutput>#GetLangVal('snp_pg_invite_team_show_alternative_usernames')#</cfoutput></a>
						</td>
					  </tr>
					  <tr id="id_tr_select_own_username" style="display:none; ">
					  	<td align="right">
							<cfoutput>#GetLangVal('cm_wd_username')#</cfoutput>:
						</td>
						<td>
							<input type="text" name="frm_own_username" value="<cfoutput>#htmleditformat(CheckDataStored('own_username'))#</cfoutput>" size="20">@<cfoutput>#ListGetAt(q_select_company.domains, 1)#</cfoutput>
						</td>
					  </tr>
					  <tr>
						<td align="right">
							<cfoutput>#GetLangVal('cm_wd_password')#</cfoutput>:
						</td>
						<td>
							<input type="password" name="frmpassword"  value="<cfoutput>#htmleditformat(CheckDataStored('password'))#</cfoutput>" size="20">
						</td>
					  </tr>
					  <!---<tr>
						<td align="right" valign="top">
							<cfoutput>#GetLangVal('snp_ph_optional_settings')#</cfoutput>:
						</td>
						<td valign="top">
							<input class="noborder" type="radio" name="frmsettings" value="default" checked> <cfoutput>#GetLangVal('snp_ph_team_invite_optional_settings_default')#</cfoutput>
							<br>
							<input class="noborder" type="radio" name="frmsettings" value="custom"> <cfoutput>#GetLangVal('snp_ph_team_invite_optional_settings_custom')#</cfoutput>
						</td>
					  </tr>--->
					  <tr>
						<td>&nbsp;</td>
						<td>
							<input type="submit" value="<cfoutput>#GetLangVal('snp_ph_login_now')#</cfoutput>">
						</td>
					  </tr>
					  <tr>
					  	<td></td>
						<td class="addinfotext">
							<cfoutput>#GetLangVal('snp_ph_invite_team_no_obligations')#</cfoutput>
						</td>
					  </tr>
					</table>
			
				</td>
				<td class="bl">
				
					<div>
					
					<!--- display group properties --->
					<cfoutput>#GetLangVal('cm_wd_workgroup')#</cfoutput>
					<br>
					<br>
					<b><cfoutput>#htmleditformat(q_select_workgroup_properties.groupname)#</cfoutput></b>
					<br><br>
					<font class="addinfotext"><cfoutput>#GetLangVal('cm_wd_description')#</cfoutput></font>
					<br>
					<cfoutput>#htmleditformat(q_select_workgroup_properties.description)#</cfoutput>
					<br><br>
					
					<cfoutput>#GetLangVal('snp_ph_invite_team_created_by')#</cfoutput>:
					<br><br>
					<cfoutput query="q_select_company">
					<b>#htmleditformat(q_select_company.companyname)#<br>
					#htmleditformat(q_select_company.contactperson)#</b>
					<br>
					#q_select_company.zipcode# #q_select_company.city# / #q_select_company.countryisocode#
					</cfoutput>
			
			
				</td>
			</tr>
		</table>
	
	</div>
	</fieldset>
	
		<div class="addinfotext" style="padding:8px;padding-bottom:4px;text-align:right;">
			<cfoutput>
			#request.appsettings.about_company#: <a class="addinfotext" target="_blank" href="/rd/about/"><cfoutput>#GetLangVal('hpg_wd_about')#</cfoutput></a> |  <a href="/rd/privacy/" target="_blank" class="addinfotext"><cfoutput>#GetLangVal('start_ph_privacy_policy')#</cfoutput></a>
			</cfoutput>
		</div>
	
	</div>
</form>

<cfif Len(CheckDataStored('own_username')) GT 0>
	<script type="text/javascript">
		ShowUsernameAlternatives();
	</script>
</cfif>
</body>
</html>