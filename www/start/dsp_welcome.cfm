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


<!--- build list of company news to load ... --->
<cfset a_str_startpage_content = '' />

<!--- today outlook --->
<cfsavecontent variable="a_str_today">
	<cfinclude template="../calendar/dsp_outlook_default.cfm">
</cfsavecontent>

<cfsavecontent variable="a_str_btn">
	<cfoutput>
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewDay');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_day')#" />
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewWeek');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_week')#" />
	<input onClick="GotoLocHref('/calendar/index.cfm?Action=ViewMonth');" type="button" class="btn btn-primary" value="#GetLangVal('cal_wd_month')#" />	
	</cfoutput>
</cfsavecontent>

<!--- write "today" box --->
<h2><cfoutput>#GetLangVal('cm_wd_today')# (#LsDateFormat(now(), 'dddd, ' & request.stUserSettings.DEFAULT_DATEFORMAT)#)</cfoutput></h2>
<cfoutput>#WriteNewContentBox('', a_str_btn, a_str_today)#</cfoutput>

<cfinclude template="../crm/dsp_outlook_default.cfm">
