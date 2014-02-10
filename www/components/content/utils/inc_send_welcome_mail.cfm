<!--- //

	send out welcome mail ...
	
	// --->
	
<cfset a_str_additionalInfo = arguments.AdditionalInfo>
	
<cfif Len(arguments.CreatedByUsername) GT 0>
	<cfset a_str_additionalInfo = a_str_additionalInfo & chr(13) & chr(10) & a_cmp_translation.GetLangValExt(langno = q_user_data.defaultlanguage, entryid='snp_ph_welcome_mail_created_by_username')>
	<cfset a_str_additionalInfo = ReplaceNoCase(a_str_additionalInfoo, '%USERNAME%', arguments.CreatedByUsername)>
</cfif>

<cfset a_str_additionalInfo = trim(a_str_additionalInfo)>

<!--- old SHIT ... to be compatible! --->
<cfset SENDWELCOMEMAIL = StructNew()>
<cfset SENDWELCOMEMAIL.additionalInfo = a_str_additionalInfo>
<cfset SENDWELCOMEMAIL.ExternalEmailAddress = q_user_data.email>
<cfset SENDWELCOMEMAIL.username = q_user_data.username>

<cfset a_bol_custom_text_welcome_exists = false>
<cfset a_bol_custom_html_welcome_exists = false>

<!--- check if custom template exists ... otherwise use standard template --->
<cfif Len(a_str_used_style) GT 0>
	<cfset a_bol_custom_text_welcome_exists = a_cmp_translation.TemplateExists(section = 'cobranding', langno = q_user_data.defaultlanguage, template_name = 'mail_welcome_text_' & a_str_used_style)>
	<cfset a_bol_custom_html_welcome_exists = a_cmp_translation.TemplateExists(section = 'cobranding', langno = q_user_data.defaultlanguage, template_name = 'mail_welcome_html_' & a_str_used_style)>
</cfif>

<!--- text part --->
<cfif a_bol_custom_text_welcome_exists>

	<cfinvoke component="#a_cmp_translation#" method="GetTemplateIncludePath" returnvariable="a_str_include_text">
		<cfinvokeargument name="section" value="cobranding">
		<cfinvokeargument name="langno" value="#q_user_data.defaultlanguage#">
		<cfinvokeargument name="template_name" value="mail_welcome_text_#a_str_used_style#">
	</cfinvoke>
	
<cfelse>
	<cfinvoke component="#a_cmp_translation#" method="GetTemplateIncludePath" returnvariable="a_str_include_text">
		<cfinvokeargument name="section" value="emails">
		<cfinvokeargument name="langno" value="#q_user_data.defaultlanguage#">
		<cfinvokeargument name="template_name" value="welcome_mail_text">
	</cfinvoke>
</cfif>

<!--- html part --->
<cfif a_bol_custom_html_welcome_exists>

	<!--- use custom text --->
	<cfinvoke component="#a_cmp_translation#" method="GetTemplateIncludePath" returnvariable="a_str_include_html">
		<cfinvokeargument name="section" value="cobranding">
		<cfinvokeargument name="langno" value="#q_user_data.defaultlanguage#">
		<cfinvokeargument name="template_name" value="mail_welcome_html_#a_str_used_style#">
	</cfinvoke>
	
<cfelse>
	<!--- use default html --->
	<cfinvoke component="#a_cmp_translation#" method="GetTemplateIncludePath" returnvariable="a_str_include_html">
		<cfinvokeargument name="section" value="emails">
		<cfinvokeargument name="langno" value="#q_user_data.defaultlanguage#">
		<cfinvokeargument name="template_name" value="welcome_mail_html">
	</cfinvoke>
</cfif>

<cfset a_str_subject = a_cmp_translation.GetLangValExt(langno = q_user_data.defaultlanguage, entryid='snp_ph_welcome_mail_subject')>

<cfmail from="#a_str_sender_address#" to="#q_user_data.username#" cc="#extractemailadr(q_user_data.email)#" subject="#a_str_subject#" charset="utf-8">
<cfmailpart type="text" charset="utf-8">
<!--- text --->
<cfinclude template="#a_str_include_text#">
</cfmailpart>
<cfmailpart type="html" charset="utf-8">
<html>
	<head>
		<title>Welcome</title>
		<style>
			body,p,td,a,div {font-family:Verdana, Arial, Helvetica, sans-serif;font-size:11px;}
		</style>
		<base href="http://#a_str_base_url#/">
	</head>
</html>
<cfif Len(a_str_content_company_header) GT 0>
	<div style="padding:6px;border-bottom:silver solid 1px; ">
	#a_str_content_company_header#
	</div>
<cfelseif Len(a_str_include_header) GT 0>
	<cfinclude template="#a_str_include_header#">
</cfif>

<cfif Len(a_str_content_company_text) GT 0>
	<div style="padding:6px;">
	#a_str_content_company_text#
	</div>
<cfelse>
	<cfinclude template="#a_str_include_html#">
</cfif>

<cfif Len(a_str_content_company_footer) GT 0>
	<div style="padding:6px;border-top:silver solid 1px; ">
	#a_str_content_company_footer#
	</div>
<cfelseif Len(a_str_include_footer) GT 0>
	<cfinclude template="#a_str_include_footer#">
</cfif>
</body>
</html>
</cfmailpart>
</cfmail>

<!---<cfinvoke component="#a_cmp_translation#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="emails">
	<cfinvokeargument name="langno" value="#q_user_data.defaultlanguage#">
	<cfinvokeargument name="template_name" value="welcome_mail_text">
</cfinvoke>--->