<!--- //

	Module:		Settings
	Action:		ShowWelcome
	Description:Display possible preferences
	

// --->

<cfset tmp = SetHeaderTopInfoString(GetLangVal('cm_wd_settings')) />

<cfset a_cmp_reseller = CreateObject('component', request.a_str_component_reseller) />
<cfset a_bol_is_reseller = a_cmp_reseller.IsResellerUser(request.stSecurityContext.myuserkey) />

<cfif request.stSecurityContext.iscompanyadmin OR a_bol_is_reseller>
	<!--- this user is a company admin ... --->
	<div class="b_all mischeader" style="padding:6px;">
	<a href="/administration/" target="_blank"><b><img src="/images/si/wrench.png" class="si_img" /> <cfoutput>#GetLangVal('prf_ph_launch_admintool')#</cfoutput></b></a>
	</div>
</cfif>

<br /> 


<cfsavecontent variable="a_str_content">
<table border="0" cellspacing="0" cellpadding="8">
  <tr>
    <td valign="top">
		<img src="/images/si/user.png" class="si_img" /> <b><cfoutput>#GetLangVal('prf_ph_personal_data')#</cfoutput></b>
		
		<ul class="img_points">
			<li><a href="default.cfm?action=PersonalData"><cfoutput>#GetLangVal('prf_ph_personal_data_name_tel')#</cfoutput></a></li>
			<!--- <li><a href="default.cfm?action=PersonalData"><cfoutput>#GetLangVal('cm_wd_language')#</cfoutput></a></li> --->
			
			
			<li><a href="default.cfm?action=categories"><cfoutput>#GetLangVal('prf_ph_personal_data_own_categories')#</cfoutput></a></li>
			<!--- <li><a href="default.cfm?action=addressbook"><cfoutput>#GetLangVal('prf_ph_addressbook_vcard')#</cfoutput></a></li> --->
		</ul>	

	</td>
    <td valign="top">
		<img src="/images/si/email_add.png" class="si_img" /> <b><cfoutput>#GetLangVal('prf_ph_email_addresses')#</cfoutput></b>
		
		<ul class="img_points">
			<!--- <li><a href="default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('email_ph_pop3_collector')#</cfoutput></a></li> --->
			<li><a href="default.cfm?action=emailaccounts"><cfoutput>#GetLangVal('prf_ph_email_addresses')# / #GetLangVal('prf_ph_alias_addresses')#</cfoutput></a></li>
			<li><a href="default.cfm?action=signatures"><cfoutput>#GetLangVal('prf_wd_signatures')#</cfoutput></a></li>
			
		</ul>
	</td>
  </tr>
  <tr>
    <td valign="top">
		<img src="/images/si/palette.png" class="si_img" /> <b><cfoutput>#GetLangVal('prf_ph_display_view')#</cfoutput></b>
		
		<ul class="img_points">
			<li><a href="default.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput></a></li>
			<li><a href="default.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('cm_wd_email')#</cfoutput></a></li>
			<li><a href="default.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('cm_wd_calendar')#</cfoutput></a></li>
			<li><a href="default.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('prf_ph_display_view_timezone')#</cfoutput></a></li>
			<!--- <li><a href="default.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('prf_ph_display_view_forward_format')#</cfoutput></a></li> --->
			<!--- <li><a href="default.cfm?action=customize"><cfoutput>#GetLangVal('cm_wd_customize')#</cfoutput></a></li> --->
			
		</ul>
	</td>
    <td valign="top">
		<b><img src="/images/si/key.png" class="si_img" /> <cfoutput>#GetLangVal('cm_wd_security')#</cfoutput></b>
		
		<ul class="img_points">
			<li><a href="default.cfm?action=password"><cfoutput>#GetLangVal('prf_ph_security_change_pwd')#</cfoutput></a></li>
			<li><a href="default.cfm?action=loglogins"><cfoutput>#GetLangVal('prf_ph_security_login_logbook')#</cfoutput></a></li>
			<li><a href="default.cfm?action=autologin"><cfoutput>#GetLangVal('prf_ph_misc_settings_autologin')#</cfoutput></a></li>
			<li><a href="default.cfm?action=managesso">Manage Single Sing on</a></li>
		</ul>
	</td>
  </tr>
  <tr>
    <td valign="top">
		<b><cfoutput>#si_img( 'group' )# #GetLangVal('cm_wd_crm')#</cfoutput></b>
	
		<ul class="img_points">
			<li><a href="default.cfm?action=extensions.crm">CRM</a></li>
			
		
		
		</ul>
	</td>
    <td valign="top">
		<!--- <img src="/images/space_1_1.gif" class="si_img" /> <b><cfoutput>#GetLangVal('prf_ph_mobile_wireless')#</cfoutput></b>
	
		<ul class="img_points">
			<li><a href="default.cfm?action=wireless&M"><cfoutput>#GetLangVal('prf_ph_misc_settings_mobile')#</cfoutput></a></li>
			<!--- <li><a href="default.cfm?action=mobilesync">MobileSync</a></li> --->
		</ul> --->
	</td>
  </tr>
</table>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(htmleditformat(GetLangVal('prf_ph_select_desired_section')), '', a_str_content)#</cfoutput>
<!--- 
<br><br>
<font class="addinfotext">Beta</font>
<ul>
	<li><a href="default.cfm?action=extensions.crm">CRM</a></li>
</ul> --->

