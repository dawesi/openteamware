<!--- //

	send out activation mail
	
	// --->
	
<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_cmp_customer = application.components.cmp_customer>
<cfset a_cmp_lang = application.components.cmp_lang>

<cfset q_select_company_data = a_cmp_customer.GetCustomerData(entrykey = arguments.companykey)>

<cfif q_select_company_data.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- try to select the activation code ... --->
<cfquery name="q_select_activate_code" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	activatecodes
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

<cfif q_select_activate_code.activated IS 1>
	<cfexit method="exittemplate">
</cfif>

<cfif q_select_activate_code.recordcount IS 0>
	<cfinclude template="q_insert_activation_code.cfm">
</cfif>

<cfquery name="q_update_set_email_sent" datasource="#request.a_str_db_users#">
UPDATE
	activatecodes
SET
	emailsent = 1
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

<!--- re-select the code for security reasons ... --->
<cfquery name="q_select_activate_code" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	activatecodes
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

<cfset a_cmp_customize = application.components.cmp_customize />

<cfset a_str_used_style = CreateObject('component', request.a_Str_component_customer).GetCompanyCustomStyle(companykey = arguments.companykey)>

<cfinvoke component="#a_cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include_text">
	<cfinvokeargument name="section" value="admintool">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="activation_mail_text">
</cfinvoke>

<cfinvoke component="#a_cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_page_include_html">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#q_select_company_data.language#">
	<cfinvokeargument name="template_name" value="activation_mail_html">
	<cfinvokeargument name="style" value="#a_str_used_style#">
</cfinvoke>

<cfset a_str_include_header = a_cmp_customize.GetMailCustomHeader(style = a_str_used_style, langno = q_select_company_data.language)>
<cfset a_str_include_footer = a_cmp_customize.GetMailCustomFooter(style = a_str_used_style, langno = q_select_company_data.language)>		
<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'mail').AutomailSender>
<cfset a_str_reply_to_address = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'mail').FeedbackMailSender>
<cfset a_str_base_url = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').BaseURL>

<cfmail from="#a_str_sender_address#" to="#q_select_company_data.email#" subject="#a_cmp_lang.GetLangValExt(entryid = 'adm_ph_activation_mail_subject', langno = q_select_company_data.language)#">
<cfmailparam name="Reply-To" value="#a_str_reply_to_address#">
<cfmailpart type="plain" charset="utf-8">
<cfinclude template="#a_str_page_include_text#">
</cfmailpart>
<cfmailpart type="html" charset="utf-8">
<html>
	<head>
		<title>Activation Information</title>
		<base href="https://#a_str_base_url#/">
		<style>
			body,p,td,a {font-family:Verdana, Arial, Helvetica, sans-serif;font-size:11px;}
		</style>
	</head>
<body>
<cfif Len(a_str_include_header) GT 0>
	<cfinclude template="#a_str_include_header#">
</cfif>

<cfinclude template="#a_str_page_include_html#">

<cfif Len(a_str_include_footer) GT 0>
	<cfinclude template="#a_str_include_footer#">
</cfif>
</body>
</html>
</cfmailpart>
</cfmail>