
<cfset LoadCompanyData.entrykey = url.companykey>
<cfinclude template="../queries/q_select_company_data.cfm">

<cfinvoke component="#application.components.cmp_content#" method="SendActivationMail" returnvariable="a_bol_return">
	<cfinvokeargument name="companykey" value="#url.companykey#">
</cfinvoke>


<cflocation addtoken="no" url="../index.cfm?action=customerproperties#writeurltags()#">


<!---

old code

<cfset a_cmp_customize = application.components.cmp_customize>

<cfquery name="q_select_activate_code" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	activatecodes
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<cfif q_select_activate_code.activated IS 1>
	already done.
	<cfabort>
</cfif>

<cfquery name="q_update_set_email_sent" datasource="#request.a_str_db_users#">
UPDATE
	activatecodes
SET
	emailsent = 1
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>

<!--- get header/footer ... and style information --->
<cfset a_cmp_customize = application.components.cmp_customize>

<cfset a_str_used_style = CreateObject('component', request.a_Str_component_customer).GetCompanyCustomStyle(companykey = url.companykey)>


<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include_text">
	<cfinvokeargument name="section" value="admintool">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="activation_mail_text">
</cfinvoke>

<!---
<cfinvoke component="#request.a_str_component_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include_html">
	<cfinvokeargument name="section" value="admintool">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="activation_mail_html">
</cfinvoke>
--->

<cfinvoke component="#a_cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_page_include_html">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#q_select_company_data.language#">
	<cfinvokeargument name="template_name" value="activation_mail_html">
	<cfinvokeargument name="style" value="#a_str_used_style#">
</cfinvoke>

<cfsavecontent variable="a_str_html_content">
	<!---COLOR: #dd0067--->
	<cfinclude template="#a_str_page_include_html#">
</cfsavecontent>

<cfset a_str_include_header = a_cmp_customize.GetMailCustomHeader(style = a_str_used_style, langno = client.langno)>
<cfset a_str_include_footer = a_cmp_customize.GetMailCustomFooter(style = a_str_used_style, langno = client.langno)>		
<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'mail').AutomailSender>
<cfset a_str_base_url = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_used_style, entryname = 'main').BaseURL>

<cfmail failto="#request.stSecurityContext.myuserid#" from="#a_str_sender_address#" to="#q_select_company_data.email#" bcc="#request.appsettings.properties.NotifyEmail#" subject="#GetLangVal('adm_ph_activation_mail_subject')#">
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

#a_str_html_content#

<cfif Len(a_str_include_footer) GT 0>
	<cfinclude template="#a_str_include_footer#">
</cfif>
</body>
</html>
</cfmailpart>
</cfmail>

--->