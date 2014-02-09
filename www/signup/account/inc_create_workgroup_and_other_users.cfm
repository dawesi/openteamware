<!--- //

	create workgroup and add team

	// --->
	
<cfif Len(trim(form.frmgroupname)) IS 0>
	<cfset form.frmgroupname = 'Team'>
</cfif>

<cfset a_cmp_workgroup = CreateObject('component', '/components/management/workgroups/cmp_workgroup')>
	
<!--- create workgroup ... --->
<cfinvoke component="#a_cmp_workgroup#" method="CreateWorkgroup" returnvariable="stReturn">
	<cfinvokeargument name="groupname" value="#form.frmgroupname#">
	<cfinvokeargument name="shortname" value="">
	<cfinvokeargument name="description" value="#trim(form.frmgroupdescription)#">
	<cfinvokeargument name="createdbyuserkey" value="#a_str_userkey#">
	<cfinvokeargument name="companykey" value="#a_str_customerkey#">
	<cfinvokeargument name="parentgroupkey" value="">
	<cfinvokeargument name="createstandardroles" value="true">
	<cfinvokeargument name="colour" value="white">
</cfinvoke>

<cfset a_str_workgroup_key = stReturn.entrykey>

<!--- add user to the group --->
<cfinvoke component="#a_cmp_workgroup#" method="GetWorkgroupRoles" returnvariable="q_select_roles">
	<cfinvokeargument name="workgroupkey" value="#a_str_workgroup_key#">
</cfinvoke>

<!--- 10 = main user --->
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


<!--- load usersettings of user creating the team ... --->
<cfinvoke component="#application.components.cmp_user#" method="GetUsersettings" returnvariable="stUserSettings">
	<cfinvokeargument name="userkey" value="#a_str_userkey#">
</cfinvoke>

<!--- add further users --->
<cfloop from="1" to="5" index="ii">
	<cfparam name="form.frmmember_#ii#" type="string" default="">
	
	<cfset a_str_email_address = ExtractEmailAdr(form['frmmember_'&ii])>
	
	<cfif Len(a_str_email_address) GT 0>
	
		<!--- email address entered ... --->
		
		<!--- insert key into database ... --->
		<cfset a_str_invitation_key = CreateUUID()>
		
		
		<cfquery name="q_insert_invitation" datasource="#request.a_str_db_users#">
		INSERT INTO
			team_invitations
			(
			entrykey,
			dt_created,
			companykey,
			emailadr,
			workgroupkey
			)
		VALUES
			(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_invitation_key#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_customerkey#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_email_address#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_workgroup_key#">
			)
		;
		</cfquery>
		
		<cfset a_str_mail_subject = GetLangVal('adm_ph_mail_subject_team_invitation')>
		<cfset a_str_mail_subject = ReplaceNoCase(a_str_mail_subject, '%TEAM%', form.frmgroupname)>
		
		<!--- load invitaion text and replace variables ... --->
		<cfset a_cmp_customize = CreateObject('component', request.a_str_component_customize)>
		<cfset a_str_base_url = a_cmp_customize.GetCustomStyleData(usersettings = stUserSettings, entryname = 'main').BaseURL>
		<cfset a_str_product_name = a_cmp_customize.GetCustomStyleData(usersettings = stUserSettings, entryname = 'main').Productname>

		
		
		<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
			<cfinvokeargument name="section" value="email">
			<cfinvokeargument name="langno" value="#client.langno#">
			<cfinvokeargument name="template_name" value="signup_create_team_invitation">
		</cfinvoke>
		
		
		<cfsavecontent variable="a_str_team_member_invite_html">
			<cfinclude template="#a_str_page_include#">	
		</cfsavecontent>
		
		<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
			<cfinvokeargument name="section" value="email">
			<cfinvokeargument name="langno" value="#client.langno#">
			<cfinvokeargument name="template_name" value="signup_create_team_invitation_text">
		</cfinvoke>		
		
		<cfsavecontent variable="a_str_team_member_invite_text">
			<cfinclude template="#a_str_page_include#">	
		</cfsavecontent>		
		
		<cfset a_str_team_member_invite_html = ReplaceNoCase(a_str_team_member_invite_html, '%SIGNUP_LINK%', '/rd/teaminvitation/?' & a_str_invitation_key, 'ALL')>
		<cfset a_str_team_member_invite_html = ReplaceNoCase(a_str_team_member_invite_html, '%PRODUCTNAME%', a_str_product_name, 'ALL')>
		<cfset a_str_team_member_invite_html = ReplaceNoCase(a_str_team_member_invite_html, '%SENDERNAME%', CheckDataStored('firstname') & ' ' & CheckDataStored('surname'), 'ALL')>
		<cfset a_str_team_member_invite_html = ReplaceNoCase(a_str_team_member_invite_html, '%COMPANYDATA%', a_str_customername & '<br>' & CheckDataStored('zipcode') & '<br>' & CheckDataStored('city'), 'ALL')>
		<cfset a_str_team_member_invite_html = ReplaceNoCase(a_str_team_member_invite_html, '%GROUPNAME%', form.frmgroupname, 'ALL')>
		
		<cfset a_str_team_member_invite_text = ReplaceNoCase(a_str_team_member_invite_text, '%SIGNUP_LINK%', '/rd/teaminvitation/?' & a_str_invitation_key, 'ALL')>
		<cfset a_str_team_member_invite_text = ReplaceNoCase(a_str_team_member_invite_text, '%PRODUCTNAME%', a_str_product_name, 'ALL')>
		<cfset a_str_team_member_invite_text = ReplaceNoCase(a_str_team_member_invite_text, '%SENDERNAME%', CheckDataStored('firstname') & ' ' & CheckDataStored('surname'), 'ALL')>
		<cfset a_str_team_member_invite_text = ReplaceNoCase(a_str_team_member_invite_text, '%COMPANYDATA%', a_str_customername & chr(13) & chr(10) & CheckDataStored('zipcode') & chr(13) & chr(10) & CheckDataStored('city'), 'ALL')>
		<cfset a_str_team_member_invite_text = ReplaceNoCase(a_str_team_member_invite_text, '%GROUPNAME%', form.frmgroupname, 'ALL')>
				
<cfmail from="#ExtractEmailAdr(form.frm_external_email)#" to="#a_str_email_address#" bcc="#request.appsettings.properties.NotifyEmail#" subject="#a_str_mail_subject#">
<cfmailpart type="text" charset="utf-8">
#a_str_team_member_invite_text#
</cfmailpart>
<cfmailpart type="html" charset="utf-8">
<html>
	<head>
		<base href="https://#a_str_base_url#">
		<cfinclude template="/style_sheet.cfm">
		<title>#htmleditformat(a_str_mail_subject)#</title>
	</head>
<body style="padding:10px; ">
	#a_str_team_member_invite_html#
</body>
</html>
</cfmailpart>
</cfmail>
		
		<!---
		<cfset a_str_username = TRIM(url['frm_create_team_username' & ii]) & '@' & request.appsettings.defaultdomain>>
		
		<cfset a_str_password = Mid(CreateUUID(), 1, 4)>

		<!--- create the user and add to the team --->
		<cfinvoke component="#request.a_str_component_users#" method="CreateUser" returnvariable="stReturn">
			<cfinvokeargument name="firstname" value="">
			<cfinvokeargument name="surname" value="">
			<cfinvokeargument name="username" value="#a_str_username#">
			<cfinvokeargument name="companykey" value="#a_str_customerkey#">
			<cfinvokeargument name="password" value="#a_str_password#">
			<cfinvokeargument name="sex" value="0">
			
			<cfinvokeargument name="address1" value="#CheckDataStored('street')#">
			<cfinvokeargument name="city" value="#CheckDataStored('city')#">
			<cfinvokeargument name="country" value="#CheckDataStored('country')#">
			<cfinvokeargument name="externalemail" value="#url['frm_create_team_email'&ii]#">
			
			<!--- default ... --->
			<cfinvokeargument name="utcdiff" value="-1">
			<cfinvokeargument name="createmailuser" value="true">
			<cfinvokeargument name="language" value="#client.langno#">
		</cfinvoke>
		
		<cfif stReturn.result>
			<!--- send welcome mail ... --->
			<cfset a_str_userkey = stReturn.entrykey>
			
			<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata_new_user">
				<cfinvokeargument name="entrykey" value="#a_str_userkey#">
			</cfinvoke>

			<cfset SendWelcomeMail.language = client.langno>
			<cfset SendWelcomeMail.Recipient1 = a_str_username>
			<cfset SendWelcomeMail.Recipient2 = url['frm_create_team_email'&ii]>
			<cfset SendWelcomeMail.ExternalEmailAddress = url['frm_create_team_email'&ii]>

			<cfset SendWelcomeMail.name = a_struct_load_userdata_new_user.query.firstname&' '&a_struct_load_userdata_new_user.query.surname>
			<cfset SendWelcomeMail.username = a_str_username>
			<cfset SendWelcomeMail.CreatedByUsername = a_str_subscriber_username>

			<cfinclude template="inc_welcome_mail.cfm">
			<cfinclude template="inc_create_data.cfm">

			<cfif Len(Extractemailadr(url['frm_create_team_email'&ii])) GT 0>
				<cfset a_str_access_data = url['frm_create_team_email'&ii]>
			<cfelse>
				<cfset a_str_access_data = CheckDataStored('email')>
			</cfif>

<cfset a_str_mail_body = GetLangVal('adm_ph_new_account_confirmation_email_body')>
<cfset a_str_mail_body = ReplaceNoCase(a_str_mail_body, '%USERNAME%', a_str_username)>
<cfset a_str_mail_body = ReplaceNoCase(a_str_mail_body, '%PASSWORD%', a_str_password)>
<cftry>
<cfmail from="#a_str_access_data#" to="#a_str_access_data#" subject="#GetLangVal('adm_ph_new_account_confirmation_email_subject')#">
#a_str_mail_body#
</cfmail>
<cfcatch type="any"></cfcatch></cftry>
			
			<cfinvoke component="/components/management/workgroups/cmp_workgroup" method="AddWorkgroupMember" returnvariable="stReturn">
				<cfinvokeargument name="workgroupkey" value="#a_str_workgroup_key#">
				<cfinvokeargument name="userkey" value="#a_str_userkey#">
				<cfinvokeargument name="roles" value="#sEntrykey_mainuser_role#">
				<cfinvokeargument name="createdbyuserkey" value="">	
			</cfinvoke>			
		</cfif>
		--->

	</cfif>

</cfloop>