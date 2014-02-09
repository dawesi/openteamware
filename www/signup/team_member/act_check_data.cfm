<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	<cflocation addtoken="no" url="#ReturnRedirectURL()#">
</cfif>

<cfinclude template="queries/q_select_signup_address.cfm">

<cfinvoke component="#application.components.cmp_customer#" method="GetCustomerData" returnvariable="q_select_company">
	<cfinvokeargument name="entrykey" value="#q_select_signup_address.companykey#">
</cfinvoke>

<cfset a_cmp_workgroup = CreateObject('component', request.a_str_component_workgroups)>

<cfset a_str_customerkey = q_select_signup_address.companykey>

<cfset session.a_struct_data.sex = form.frmsex>
<cfset session.a_struct_data.firstname = form.frmfirstname>
<cfset session.a_struct_data.surname = form.frmsurname>
<cfset session.a_struct_data.password = form.frmpassword>
<cfset session.a_struct_data.own_username = form.frm_own_username>

<cfif Len(form.frmfirstname) LTE 2>
	<cflocation addtoken="no" url="default.cfm?error=tooshortfirstname&k=#form.frmentrykey#">
</cfif>

<cfif Len(form.frmsurname) LTE 2>
	<cflocation addtoken="no" url="default.cfm?error=tooshortsurname&k=#form.frmentrykey#">
</cfif>

<!--- check username ... --->
<cfif Len(form.frm_own_username) GT 0>
	<cfset a_str_username = form.frm_own_username>
<cfelse>
	<cfset a_str_username = form.frm_default_username>
</cfif>

<cfif Len(a_str_username) LT 3>
	<cflocation addtoken="no" url="default.cfm?error=tooshortusername&k=#form.frmentrykey#">
</cfif>

<cfif FindNoCase("@", a_str_username, 1) GT 0>
	<cflocation addtoken="no" url="default.cfm?error=atcharinusername&k=#form.frmentrykey#">
</cfif>

<cfif ReFindNoCase("[^0-9,a-z,.,--,_]", a_str_username, 1) GT 0>
	<cflocation addtoken="no" url="default.cfm?error=invalidcharinusername&k=#form.frmentrykey#">
</cfif>

<cfset a_str_username = a_str_username & '@' & ListGetAt(q_select_company.domains, 1)>

<cfinvoke component="#application.components.cmp_user#" method="UsernameExists" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#a_str_username#">
</cfinvoke>

<cfif a_bol_return>
	<!--- user already exists ... --->
	<cflocation addtoken="no" url="default.cfm?error=useralreadyexists&k=#form.frmentrykey#">
</cfif>

<cfif Len(form.frmpassword) LT 4>
	<cflocation addtoken="no" url="default.cfm?error=passwordtooshort&k=#form.frmentrykey#">
</cfif>

<!--- create user ... --->
<cfinvoke component="#request.a_str_component_users#" method="CreateUser" returnvariable="stReturn">
	<cfinvokeargument name="firstname" value="#form.frmfirstname#">
	<cfinvokeargument name="surname" value="#form.frmsurname#">
	<cfinvokeargument name="username" value="#a_str_username#">
	<cfinvokeargument name="companykey" value="#a_str_customerkey#">
	<cfinvokeargument name="password" value="#form.frmpassword#">
	<cfinvokeargument name="sex" value="#val(form.frmsex)#">
	
	<cfinvokeargument name="address1" value="#q_select_company.street#">
	<cfinvokeargument name="city" value="#q_select_company.city#">
	<cfinvokeargument name="country" value="#q_select_company.countryisocode#">
	<cfinvokeargument name="externalemail" value="#q_select_signup_address.emailadr#">
	
	<!--- default ... --->
	<cfinvokeargument name="utcdiff" value="-1">
	<cfinvokeargument name="createmailuser" value="true">
	<cfinvokeargument name="language" value="#client.langno#">
</cfinvoke>

<cfdump var="#stReturn#">

<cfset a_str_userkey = stReturn.entrykey>
<cfset a_str_workgroup_key = q_select_signup_address.workgroupkey>

<cfinvoke component="#application.components.cmp_content#" method="SendWelcomeMail" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="companykey" value="#a_str_customerkey#">
</cfinvoke>

<cfinvoke component="#a_cmp_workgroup#" method="GetWorkgroupRoles" returnvariable="q_select_roles">
	<cfinvokeargument name="workgroupkey" value="#a_str_workgroup_key#">
</cfinvoke>

<cfquery name="q_select_mainuser_role" dbtype="query">
SELECT
	entrykey
FROM
	q_select_roles
WHERE
	standardtype = 10
;	
</cfquery>

<cfset sEntrykey_mainuser_role = q_select_mainuser_role.entrykey>

<cfinvoke component="#a_cmp_workgroup#" method="AddWorkgroupMember" returnvariable="stReturn">
	<cfinvokeargument name="workgroupkey" value="#a_str_workgroup_key#">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
	<cfinvokeargument name="roles" value="#sEntrykey_mainuser_role#">
	<cfinvokeargument name="createdbyuserkey" value="">	
</cfinvoke>

<cfdump var="#stReturn#">

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
	<cfinvokeargument name="entrykey" value="#a_str_userkey#">
</cfinvoke>

<cflocation addtoken="no" url="/al/?key=#a_struct_load_userdata.query.autologin_key#">

<!--- add to workgroup ... --->