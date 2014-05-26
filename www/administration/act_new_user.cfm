<!--- //

	create the user now ...
	
	// --->
	
<cfinclude template="utils/inc_check_security.cfm">
	
<cfparam name="form.frmpasswordtype" type="numeric" default="0">
<cfparam name="form.frmproductkey" type="string" default="">

<!--- check the permissions ... is this user allowed to create a user? --->

<!--- load the address data and so on from the database ... --->
<cfset LoadCompanyData.entrykey = form.frmcompanykey>
<cfinclude template="queries/q_select_company_data.cfm">

<!--- check licence status ... --->
<cfinvoke component="#application.components.cmp_licence#" method="GetLicenceStatus" returnvariable="q_select_licence_status">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="productkey" value="#form.frmproductkey#">
</cfinvoke>

<cfif q_select_company_data.status IS 0 AND q_select_licence_status.availableseats IS 0>
	<b><cfoutput>#GetLangVal('adm_ph_error_no_more_licences_1')#</cfoutput></b>
	<br><br><br>
	<b><cfoutput>#GetLangVal('adm_ph_error_no_more_licences_2')#</cfoutput> <a href="index.cfm?action=shop<cfoutput>#writeurltags()#</cfoutput>"><cfoutput>#GetLangVal('adm_ph_error_no_more_licences_goto_shop')#</cfoutput></a></b>
	<br><br>
	<cfoutput>#GetLangVal('adm_ph_error_no_more_licences_3')#</cfoutput>
	<cfexit method="exittemplate">
</cfif>	

<cfif form.frmpasswordtype is 1>
	<cfset a_str_password = Mid(ReplaceNoCase(CreateUUID(), "-", "", "ALL"), 1, 6)>
<cfelse>
	<cfset a_str_password = form.frmpassword>
</cfif>

<cfif len(a_str_password) is 0>
	<h4><cfoutput>#GetLangVal('adm_ph_error_empty_password')#</cfoutput></h4>
	<cfabort>
</cfif>

<cfset a_str_username = form.frmusername & "@" & trim(form.frmdomain)>

<cfif FindNoCase("@", form.frmusername) gt 0>
	<h4>E: <cfoutput>#GetLangVal('adm_ph_error_invalid_username')#</cfoutput></h4>
	<cfabort>
</cfif>

<cfif FindNoCase(" ", form.frmusername) gt 0>
	<h4>E2: <cfoutput>#GetLangVal('adm_ph_error_invalid_username')#</cfoutput></h4>
	<cfabort>
</cfif>

<cfinvoke component="#application.components.cmp_user#" method="UsernameExists" returnvariable="a_bol_return">
	<cfinvokeargument name="username" value="#a_str_username#">
</cfinvoke>

<cfif a_bol_return is true>
	<h4>E: <cfoutput>#GetLangVal('adm_ph_error_username_in_use')#</cfoutput></h4>
	<cfabort>
</cfif>

<cfif q_select_company_data.status IS 1>
	
	<cfif Len(form.frmexternalemail) IS 0>
		<b>E: <cfoutput>#GetLangVal('adm_ph_error_external_adr_needed')#</cfoutput></b>
		<cfabort>
	</cfif>
	
</cfif>

<!--- call the create user method --->

<cftry>
<cfinvoke
	component="#application.components.cmp_user#"
	method="CreateUser"
	returnvariable="stReturn">
	<cfinvokeargument name="firstname" value="#form.frmfirstname#">
	<cfinvokeargument name="surname" value="#form.frmsurname#">
	<cfinvokeargument name="username" value="#a_str_username#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
	<cfinvokeargument name="password" value="#a_str_password#">
	<cfinvokeargument name="address1" value="#q_select_company_data.street#">
	<cfinvokeargument name="city" value="#q_select_company_data.city#">
	<cfinvokeargument name="country" value="#q_select_company_data.country#">
	<cfinvokeargument name="zipcode" value="#q_select_company_data.zipcode#">
	<cfinvokeargument name="sex" value="#form.frmsex#">
	<cfinvokeargument name="utcdiff" value="#form.frmutcdiff#">
	<cfinvokeargument name="mobilenr" value="">
	<cfinvokeargument name="createmailuser" value="true">
	<cfinvokeargument name="department" value="#form.frmdepartment#">
	<cfinvokeargument name="position" value="#form.frmposition#">
	<cfinvokeargument name="productkey" value="#form.frmproductkey#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
	<cfinvokeargument name="externalemail" value="#form.frmexternalemail#">
	<cfinvokeargument name="language" value="#form.frmlanguage#">
</cfinvoke>

<cfcatch type="any">
	<cfdump var="#cfcatch#">
	<cfabort>
</cfcatch>
</cftry>>

<cfif NOT stReturn.result>
	<h1>
		E: <cfoutput>#stReturn.errormessage#</cfoutput>
	</h1>
	<cfabort>
</cfif>

<!--- is this the first user? --->
<cfset SelectCompanyUsersRequest.companykey = form.frmcompanykey>
<cfinclude template="queries/q_select_company_users.cfm">

<cfif q_select_company_users.recordcount IS 1>
	<!--- set as admin user ... --->
	<cfinvoke component="#application.components.cmp_customer#" method="AddCustomerContact" returnvariable="a_bol_return">
		<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
		<cfinvokeargument name="userkey" value="#stReturn.entrykey#">
		<cfinvokeargument name="level" value="100">
	</cfinvoke>
	
	<!--- send freischalt link ... --->
	<!---<cfmodule template="customer/inc_send_confirm_mail.cfm" to=#form.frmexternalemail# userkey=#stReturn.entrykey# autologinkey='123' sex=#form.frmsex# surname=#form.frmsurname#>/--->
	
</cfif>

<cfif Len(form.frmexternalemail) GT 0>

<cfset a_cmp_translation = application.components.cmp_lang>
<cfset a_str_body = a_cmp_translation.GetLangValExt(langno = val(form.frmlanguage), entryid='adm_ph_new_account_confirmation_email_body')>
<cfset a_str_subject = a_cmp_translation.GetLangValExt(langno = val(form.frmlanguage), entryid='adm_ph_new_account_confirmation_email_subject')>

<!---
<cfset a_str_body = GetLangVal('adm_ph_new_account_confirmation_email_body')>--->



<cfset a_str_body = ReplaceNoCase(a_str_body, '%USERNAME%', a_str_username)>
<cfset a_str_body = ReplaceNoCase(a_str_body, '%PASSWORD%', a_str_password)>

<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_str_used_style = CreateObject('component', request.a_Str_component_customer).GetCompanyCustomStyle(companykey = form.frmcompanykey)>
<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'mail').AutomailSender>

<cfset a_str_body = ReplaceNoCase(a_str_body, '%BASEURL%', a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').BaseURL)>
<cfset a_str_body = ReplaceNoCase(a_str_body, '%PRODUCTNAME%', a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').productname)>
<cfset a_str_body = ReplaceNoCase(a_str_body, '%FEEDBACK_ADDRESS%', a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'mail').FeedbackMailSender)>

<cftry>
<cfmail from="#a_str_sender_address#" to="#form.frmexternalemail#" subject="#a_str_subject#">
#form.frmfirstname# #form.frmsurname#, 

#a_str_body#
</cfmail>
<cfcatch type="any"> </cfcatch></cftry>

</cfif>

<cftry>
<cfinvoke component="#application.components.cmp_content#" method="SendWelcomeMail" returnvariable="a_bol_return">
	<cfinvokeargument name="userkey" value="#stReturn.entrykey#">
	<cfinvokeargument name="companykey" value="#form.frmcompanykey#">
</cfinvoke>
<cfcatch type="any">
</cfcatch>
</cftry>

	
<cflocation addtoken="no" url="index.cfm?action=useradministration&companykey=#urlencodedformat(form.frmcompanykey)#&resellerkey=#urlencodedformat(form.frmresellerkey)#">