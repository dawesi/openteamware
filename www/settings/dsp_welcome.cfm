<!--- //

	Module:		Settings
	Action:		ShowWelcome
	Description:Display possible preferences


// --->

<cfoutput><h2>#GetLangVal('cm_wd_settings')#</h2></cfoutput>


<cfsavecontent variable="a_str_content">
<table class="table">
  <tr>
    <td valign="top">
		<b><cfoutput>#GetLangVal('prf_ph_personal_data')#</cfoutput></b>

		<ul class="img_points">
			<li><a href="index.cfm?action=PersonalData"><cfoutput>#GetLangVal('prf_ph_personal_data_name_tel')#</cfoutput></a></li>
			<li><a href="index.cfm?action=categories"><cfoutput>#GetLangVal('prf_ph_personal_data_own_categories')#</cfoutput></a></li>
		</ul>

	</td>
    <td valign="top">
		<b><cfoutput>#GetLangVal('prf_ph_email_addresses')#</cfoutput></b>

		<ul class="img_points">
			<li><a href="index.cfm?action=emailaccounts"><cfoutput>#GetLangVal('prf_ph_email_addresses')#</cfoutput></a></li>

		</ul>
	</td>
  </tr>
  <tr>
    <td valign="top">
		<b><cfoutput>#GetLangVal('prf_ph_display_view')#</cfoutput></b>

		<ul class="img_points">
			<li><a href="index.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('cm_wd_addressbook')#</cfoutput></a></li>
			<li><a href="index.cfm?action=DisplayPreferences"><cfoutput>#GetLangVal('prf_ph_display_view_timezone')#</cfoutput></a></li>
		</ul>
	</td>
    <td valign="top">
		<cfoutput>#GetLangVal('cm_wd_security')#</cfoutput></b>

		<ul class="img_points">
			<li><a href="index.cfm?action=password"><cfoutput>#GetLangVal('prf_ph_security_change_pwd')#</cfoutput></a></li>
			<li><a href="index.cfm?action=loglogins"><cfoutput>#GetLangVal('prf_ph_security_login_logbook')#</cfoutput></a></li>
		</ul>
	</td>
  </tr>
</table>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(htmleditformat(GetLangVal('prf_ph_select_desired_section')), '', a_str_content)#</cfoutput>