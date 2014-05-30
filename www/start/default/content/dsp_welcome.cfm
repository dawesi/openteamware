<!--- //

	Description:Display start welcome page
	

// --->

<!--- load userdata .. --->
<cfinvoke component="#application.components.cmp_user#" method="GetUserData" returnvariable="q_select_user_data">
	<cfinvokeargument name="userkey" value="#request.stSecurityContext.myuserkey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_customer#" method="GetCompanyContacts" returnvariable="q_select_company_contacts">
	<cfinvokeargument name="companykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>

<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company_data">
	<cfinvokeargument name="entrykey" value="#request.stSecurityContext.mycompanykey#">
</cfinvoke>
	
<cfset a_str_productkey = application.components.cmp_licence.GetProductkeyforuserkey(request.stSecurityContext.myuserkey) />


<cfset a_str_display_left = GetUserPrefPerson('startpage_content', 'display.leftcolumn', 'email,calendar,addressbook,im', '', false) />
<cfset a_str_display_right = GetUserPrefPerson('startpage_content', 'display.rightcolumn', 'tasks,stat,websearch,news,bookmarks', '', false) />
	
<cfset a_str_top_header_str = htmleditformat(request.a_struct_personal_properties.myfirstname) & ' ' & htmleditformat(request.a_struct_personal_properties.mysurname) & ' (' & htmleditformat(q_select_company_data.companyname) & ')' />
<cfset tmp = SetHeaderTopInfoString(a_str_top_header_str) />
<div style="clear:both"></div>

<cfset q_select_sso_settings = application.components.cmp_security.LoadSwitchUsersData(userkey = request.stSecurityContext.myuserkey) />

<!--- allow user switch if enabled ... --->
<cfif request.stSecurityContext.isuserswitchenabled>
	
	<!--- write "sso" box --->
	<cfsavecontent variable="a_str_btn">
		<cfoutput>
		<input onClick="GotoLocHref('/settings/index.cfm?Action=ManageSSO');" type="button" class="btn btn-primary" value="Manage SSO Preferences" />
		</cfoutput>
	</cfsavecontent>
	
	<cfset a_str_content = application.components.cmp_content.DisplayUserSwitchDialog(securitycontext = request.stSecurityContext) />

	<cfoutput>#WriteNewContentBox('Single Sign On', a_str_btn, a_str_content)#</cfoutput>

</cfif>

<!--- build list of company news to load ... --->
<cfset a_str_companies_check_companynews = request.stSecurityContext.mycompanykey />
<cfset a_str_startpage_content = '' />

<cfif request.stSecurityContext.isuserswitchenabled>
	<cfloop query="q_select_sso_settings">
		<!--- if company is not yet in the list, add it now ... --->
		<cfif ListFindNoCase(a_str_companies_check_companynews, application.components.cmp_user.GetCompanyKeyOfuser(userkey = q_select_sso_settings.otheruserkey)) IS 0>
			<cfset a_str_companies_check_companynews = ListAppend(a_str_companies_check_companynews, application.components.cmp_user.GetCompanyKeyOfuser(userkey = q_select_sso_settings.otheruserkey))>
		</cfif>
	</cfloop>
</cfif>

<!--- generate startpage content ... --->
<cfsavecontent variable="a_str_startpage_companynews">
	<cfloop list="#a_str_companies_check_companynews#" index="a_str_companykey">

		<cfset a_str_custom_startpage_content = application.components.cmp_content.GetCompanyCustomElement(companykey = a_str_companykey,
																							elementname = 'startpage') />

		<cfif Len(a_str_custom_startpage_content)>
			
			<cfset a_str_custom_startpage_content = '<div style="padding:6px;"><i>' & htmleditformat(application.components.cmp_customer.GetCustomerNameByEntrykey(entrykey = a_str_companykey)) & '</i><br/>' & a_str_custom_startpage_content & '</div>' />
			
			<cfset a_str_startpage_content = a_str_startpage_content & a_str_custom_startpage_content />
		
		</cfif>
		
	</cfloop>
</cfsavecontent>

<cfif Len(a_str_startpage_content) GT 0>
	<cfoutput>#WriteNewContentBox(GetLangVal('adm_ph_nav_companynews'), '', a_str_startpage_content)#</cfoutput>	
</cfif>

<!--- today outlook --->
<cfsavecontent variable="a_str_today">
<table border="0" cellspacing="0" cellpadding="4" width="100%">
  <tr>
    <td width="50%" valign="top">
		
		<!--- email --->
		<cfif request.stSecurityContext.A_STRUCT_IMAP_ACCESS_DATA.enabled>
			<cfinclude template="../../../email/dsp_outlook_default.cfm">
		<cfelse>
			<!--- <cfoutput>
			<div class="status">
			<b>Finish the setup</b>
			<br />
			<a href="/settings/?action=AddemailAccount">Click here to add your email account</a>
			</div>
			</cfoutput> --->
		</cfif>

	</td>
    <td width="50%" valign="top">
	
		<cfinclude template="../../../calendar/dsp_outlook_default.cfm">
		
	</td>
  </tr>
</table>
</cfsavecontent>

<cfsavecontent variable="a_str_btn">
	<cfoutput>
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewDay');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_day')#" />
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewWeek');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_week')#" />
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewMonth');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_month')#" />	
	</cfoutput>
</cfsavecontent>

<!--- write "today" box --->
<cfoutput>#WriteNewContentBox(GetLangVal('cm_wd_today') & ' (' & LsDateFormat(now(), 'dddd, ' & request.stUserSettings.DEFAULT_DATEFORMAT) & ')', a_str_btn, a_str_today)#</cfoutput>

	<cfinclude template="/crm/dsp_outlook_default.cfm">

<!--- <cfinclude template="dsp_inc_startpage_welcome_current_items.cfm"> --->

