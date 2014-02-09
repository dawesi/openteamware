<!--- //

	add a member to a workgroup ...
	
	// --->
	

<cfparam name="form.frmrole" type="string" default="">
<cfparam name="form.frmusersource" type="string" default="internal">

<cfif Len(form.frmrole) IS 0>
	<cfoutput>#GetLangVal('adm_ph_error_no_role_selected')#</cfoutput>
	<br><br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('adm_ph_go_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfset a_cmp_email_accounts = CreateObject('component', '/components/email/cmp_accounts')> 

<cfif CompareNoCase(form.frmusersource, 'external') IS 0>
	<!--- external source ... --->
	
	<!--- 2do: licence check!!!!!!!!!!!! --->
	
	<cfset form.frmemail = ExtractEmailAdr(form.frmemail)>
	
	<cfif Len(form.frmemail) IS 0>
		Sie haben keine gueltige E-Mail Adresse eingegeben.
		<cfabort>
	</cfif>
	
	<cfif Len(form.frmfirstname) IS 0>
		Vorname darf nicht leer sein.
		<cfabort>
	</cfif>
	
	<cfif Len(form.frmsurname) IS 0>
		Nachname darf nicht leer sein.
		<cfabort>
	</cfif>	
	
	<!--- create user --->
	
	<cfset LoadCompanyData.entrykey = form.frmcompanykey>
	<cfinclude template="queries/q_select_company_data.cfm">
		
	<!--- use the first domain in the list ... --->
	<cfset a_str_domain = ListGetAt(q_select_company_data.domains, 1, ',')>
	
	<cfset a_str_username_1 = ListGetAt(form.frmemail, 1, '@') & '@' & a_str_domain>
	<cfset a_str_username_2 = lcase(form.frmfirstname & '.' & form.frmsurname & '@' & a_str_domain)>
	<cfset a_str_username_3 = lcase(Mid(form.frmfirstname, 1, 1) & '.' & form.frmsurname & '@' & a_str_domain)>
	<cfset a_str_username_4 = lcase(form.frmfirstname & '_' & form.frmsurname & '@' & a_str_domain)>
	
	<cfset a_bol_username_exists = a_cmp_email_accounts.EmailAddressInUse(a_str_username_1)>
	
	<cfif NOT a_bol_username_exists>
		<cfset a_str_username = a_str_username_1>
	</cfif>
	
	<cfif a_bol_username_exists>
		<cfset a_bol_username_exists = a_cmp_email_accounts.EmailAddressInUse(a_str_username_2)>
		
		<cfif NOT a_bol_username_exists>
			<cfset a_str_username = a_str_username_2>
		</cfif>		
	</cfif>
	
	<cfif a_bol_username_exists>
		<cfset a_bol_username_exists = a_cmp_email_accounts.EmailAddressInUse(a_str_username_3)>
		
		<cfif NOT a_bol_username_exists>
			<cfset a_str_username = a_str_username_3>
		</cfif>		
	</cfif>	
	
	<cfif a_bol_username_exists>
		<cfset a_bol_username_exists = a_cmp_email_accounts.EmailAddressInUse(a_str_username_4)>
		
		<cfif NOT a_bol_username_exists>
			<cfset a_str_username = a_str_username_4>
		</cfif>		
	</cfif>		
	
	<cfdump var="#a_str_username#">
	
	<cfset a_str_password = Mid(ReplaceNoCase(CreateUUID(), "-", "", "ALL"), 1, 6)>
	
	
	<cfinvoke component="#application.components.cmp_user#" method="CreateUser" returnvariable="stReturn">
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
		<cfinvokeargument name="utcdiff" value="-1">
		<cfinvokeargument name="mobilenr" value="">
		<cfinvokeargument name="createmailuser" value="true">
		<!--- groupware --->
		<cfinvokeargument name="productkey" value="AE79D26D-D86D-E073-B9648D735D84F319">
		<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">
		<cfinvokeargument name="externalemail" value="#form.frmemail#">
		<!--- external ... 2do! --->
		<cfinvokeargument name="account_type" value="1">
	</cfinvoke>	
	
	<cfif NOT stReturn.result>
		<b>Fehler:</b> <cfoutput>#stReturn.result#</cfoutput>
		<cfabort>
	</cfif>
	
	<cfset form.frmuserkey = stReturn.entrykey>
	
	<!--- create a forwarding to this address ... forward all emails ... --->
	<cfinvoke component="#a_cmp_email_accounts#" method="UpdateForwarding" returnvariable="a_bol_dummy_return">
		<cfinvokeargument name="source" value="#a_str_username#">
		<cfinvokeargument name="destination" value="#form.frmemail#">
		<cfinvokeargument name="leavecopy" value="0">
	</cfinvoke>
	
<cfmail from="feedback@openTeamWare.com" subject="Ihr Projektzugang wurde erstellt" to="#form.frmemail#">
Guten Tag!

Ihr Konto im Projektteam wurde soeben erstellt - loggen Sie sich nun bitte unter

https://www.openTeamWare.com/

mit Ihren Zugangsdaten ein.

Benutzername (Ihre E-Mail Adresse): #form.frmemail#
Passwort: #a_str_password#

Um das Passwort nun sofort zu aendern klicken Sie bitte hier:
https://www.openTeamWare.com/rd/change_password/

<cfif Len(form.frmcommentemail) GT 0>
Zusaetzliche Hinweise:
#form.frmcommentemail#
</cfif>

Bei Fragen kontaktieren Sie bitte:

#q_select_company_data.companyname#
#q_select_company_data.zipcode# #q_select_company_data.city#
#q_select_company_data.telephone#

#q_select_company_data.email#
</cfmail>

	
</cfif>

<cfif Len(form.frmuserkey) IS 0>
	<cfoutput>#GetLangVal('adm_ph_error_no_user_selected')#</cfoutput>
	<br><br><br>
	<a href="javascript:history.go(-1);"><cfoutput>#GetLangVal('adm_ph_go_back')#</cfoutput></a>
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="stReturn_userdata">
	<cfinvokeargument name="entrykey" value="#form.frmuserkey#">
</cfinvoke>

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="GetWorkgroupNameByEntryKey" returnvariable="a_str_workgroup_name">
	<cfinvokeargument name="entrykey" value="#form.frmworkgroupkey#">
</cfinvoke>

<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="AddWorkgroupMember" returnvariable="stReturn">
	<cfinvokeargument name="workgroupkey" value="#form.frmworkgroupkey#">
	<cfinvokeargument name="userkey" value="#form.frmuserkey#">
	<cfinvokeargument name="roles" value="#form.frmrole#">
	<cfinvokeargument name="createdbyuserkey" value="#request.stSecurityContext.myuserkey#">	
</cfinvoke>

<cfset a_str_body = GetLangVal('adm_ph_new_workgroup_member_mail_body')>
<cfset a_str_body = ReplaceNoCase(a_str_body, '%WORKGROUP%', a_str_workgroup_name, 'ALL')>

<cfmail from="#request.stSecurityContext.myusername#" to="#stReturn_userdata.query.username#" subject="#GetLangVal('adm_ph_new_workgroup_member_mail_subject')#">
#a_str_body#
</cfmail>

<cflocation addtoken="no" url="default.cfm?action=workgroupproperties&entrykey=#urlencodedformat(form.frmworkgroupkey)##writeurltagsfromform()#">