<cfset a_cmp_customize = application.components.cmp_customize>
<cfset a_cmp_customer = application.components.cmp_customer>
<cfset a_cmp_lang = application.components.cmp_lang>

<cfset a_str_used_style = a_cmp_customer.GetCompanyCustomStyle(companykey = arguments.companykey)>

<cfinvoke component="#application.components.cmp_security#" method="GetSecurityContextStructure" returnvariable="stReturn">
	<cfinvokeargument name="userkey" value="#arguments.userkey#">
</cfinvoke>

<cfset CreateDemoData.stSecurityContext = stReturn>

<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="a_struct_settings">
	<cfinvokeargument name="userkey" value="#arguments.userkey#">
</cfinvoke>

<cfset CreateDemoData.stUserSettings = a_struct_settings>

<cfset a_str_product_name = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').productname>

<cfinvoke component="#application.components.cmp_addressbook#" method="CreateContact" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#CreateDemoData.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#CreateDemoData.stUserSettings#">	
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="firstname" value="#a_str_product_name#">
	<cfinvokeargument name="surname" value="Office">
	<cfinvokeargument name="email_prim" value="Office@#ReplaceNoCase(a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').baseurl, 'www.', '')#">
</cfinvoke>

<!--- create sales --->
<!---<cfinvoke component="#request.a_str_component_addressbook#" method="CreateContact" returnvariable="a_bol_return">
	<cfinvokeargument name="securitycontext" value="#CreateDemoData.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#CreateDemoData.stUserSettings#">	
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="firstname" value="openTeamWare.com">
	<cfinvokeargument name="surname" value="#GetLangVal('snp_ph_demo_data_consulting_sales')#">
	<cfinvokeargument name="email_prim" value="Info@openTeamWare.com">
	<cfinvokeargument name="b_telephone" value="+43 (0) 316 - 72 02 40">
</cfinvoke>--->

<!--- create tasks --->
<cfset a_dt_due = DateAdd('d', 1, Now())>
<cfinvoke component="#application.components.cmp_tasks#" method="CreateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="securitycontext" value="#CreateDemoData.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#CreateDemoData.stUserSettings#">	
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="title" value="#GetLangVal('snp_ph_demo_data_team_settings_subject')#">
	<cfinvokeargument name="notice" value="#GetLangVal('snp_ph_demo_data_team_settings_text')#">
	<cfinvokeargument name="status" value="1">
	<cfinvokeargument name="due" value="#a_dt_due#">	
</cfinvoke>
<cfinvoke component="#application.components.cmp_tasks#" method="CreateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="securitycontext" value="#CreateDemoData.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#CreateDemoData.stUserSettings#">		
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="title" value="#GetLangVal('snp_ph_demo_data_pop3_collector_subject')#">
	<cfinvokeargument name="notice" value="#GetLangVal('snp_ph_demo_data_pop3_collector_text')#">
	<cfinvokeargument name="status" value="1">
	<cfinvokeargument name="due" value="#a_dt_due#">	
</cfinvoke>
<cfinvoke component="#request.a_str_component_tasks#" method="CreateTask" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="securitycontext" value="#CreateDemoData.stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#CreateDemoData.stUserSettings#">		
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="title" value="#GetLangVal('snp_ph_demo_data_outlooksync_subject')#">
	<cfinvokeargument name="notice" value="#GetLangVal('snp_ph_demo_data_outlooksync_text')#">
	<cfinvokeargument name="status" value="1">
	<cfinvokeargument name="due" value="#a_dt_due#">	
</cfinvoke>

<!--- create events --->


<cfinvoke component="#application.components.cmp_calendar#" method="CreateEvent" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#CreateUUID()#">
	<cfinvokeargument name="title" value="#GetLangVal('snp_ph_demo_data_demoevent_title')#">
	<cfinvokeargument name="description" value="#GetLangVal('snp_ph_demo_data_demoevent_text')#">
	<cfinvokeargument name="securitycontext" value="#CreateDemoData.stSecurityContext#">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="usersettings" value="#CreateDemoData.stUserSettings#">
	<cfinvokeargument name="date_start" value="#a_dt_due#">
	<cfinvokeargument name="date_end" value="#DateAdd('h', 1, a_dt_due)#">
	<cfinvokeargument name="meetingmemberscount" value="0">
</cfinvoke>