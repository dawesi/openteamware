<!--- //

	Module:		Not seend for 21 days
	Description: 
	

// --->

<cfinclude template="/common/scripts/script_utils.cfm">

<cfset a_int_day = DateFormat(DateAdd('d', -21, Now()), 'yyyymmdd')>

<cfset a_cmp_customize = application.components.cmp_customize />

<cfquery name="q_select" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	<!--- no disabled companies --->
	status = 1
	OR
	disabled = 1
;
</cfquery>

<cfquery name="q_select_users" datasource="#request.a_str_db_users#">
SELECT
	username,entrykey,
	lasttimelogin,email,
	defaultlanguage
FROM
	users
WHERE
	companykey NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select.entrykey)#" list="yes">)
	AND
	DATE_FORMAT(lasttimelogin, '%Y%m%d') = <cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_day#">
	AND
	allow_login = 1
;
</cfquery>

<cfif q_select_users.recordcount IS 0>
	<!--- nothing to do --->
	<cfexit method="exittemplate">
</cfif>

<cfset a_cmp_lang = application.components.cmp_lang>
<cfset a_cmp_users = application.components.cmp_user>
<cfset a_cmp_customize = CreateObject('component', request.a_str_component_customize)>

<cfloop query="q_select_users">

<cfoutput>
	#q_select_users.currentrow# #q_select_users.username# #q_select_users.email#<br>
</cfoutput>

<cfset a_str_cc = ''>

<cfif ExtractEmailAdr(q_select_users.email) NEQ ''>
	<cfset a_str_cc = ExtractEmailAdr(q_select_users.email)>
</cfif>

<cfset a_str_user_style = a_cmp_users.GetUserCustomStyle(userkey = q_select_users.entrykey)>

<cfoutput>#a_str_user_style#</cfoutput>

<cfset a_str_header_include = a_cmp_customize.GetMailCustomHeader(style = a_str_user_style, langno = q_select_users.defaultlanguage)>
<cfset a_str_footer_include = a_cmp_customize.GetMailCustomFooter(style = a_str_user_style, langno = q_select_users.defaultlanguage)>

<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'mail').FeedbackMailSender>
<cfset a_str_base_url = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'main').BaseURL>
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'main').Productname>
<cfset a_str_productname = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'main').Productname>

<cfinvoke component="#a_cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="mail">
	<cfinvokeargument name="langno" value="#q_select_users.defaultlanguage#">
	<cfinvokeargument name="template_name" value="notseen21_text">
</cfinvoke>

<cfsavecontent variable="a_str_text_part_content">
	<cfinclude template="#a_str_page_include#">
</cfsavecontent>

<cfset a_str_text_part_content = ReplaceNoCase(a_str_text_part_content, '%PRODUCTNAME%', a_str_product_name, 'ALL')>
<cfset a_str_text_part_content = ReplaceNoCase(a_str_text_part_content, '%BASE_URL%', a_str_base_url, 'ALL')>
<cfset a_str_text_part_content = ReplaceNoCase(a_str_text_part_content, '%USERNAME%', q_select_users.username, 'ALL')>


<cfinvoke component="#a_cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="mail">
	<cfinvokeargument name="langno" value="#q_select_users.defaultlanguage#">
	<cfinvokeargument name="template_name" value="notseen21_html">
</cfinvoke>

<cfsavecontent variable="a_str_html_part_content">
	<cfinclude template="#a_str_page_include#">
</cfsavecontent>

<cfset a_str_html_part_content = ReplaceNoCase(a_str_html_part_content, '%PRODUCTNAME%', a_str_product_name, 'ALL')>
<cfset a_str_html_part_content = ReplaceNoCase(a_str_html_part_content, '%BASE_URL%', a_str_base_url, 'ALL')>
<cfset a_str_html_part_content = ReplaceNoCase(a_str_html_part_content, '%USERNAME%', q_select_users.username, 'ALL')>

<cfmail from="#a_str_sender_address#" to="#q_select_users.username#" cc="#a_str_cc#" subject="#a_str_productname#: #a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'automail_ph_subject_notseen21')#">
<cfmailpart type="text">#a_str_text_part_content#</cfmailpart>
<cfmailpart type="html">
<html>
	<head>
	<style>
		body,p,a,td,input{font-family:Tahoma,Verdana,Arial;font-size:11px;}
	</style>
	<base href="https://#a_str_base_url#/">
	<title>NotSeen 21 Feedback</title>	
	</head>
<body>
<cfinclude template="#a_str_header_include#">
#a_str_html_part_content#
<cfinclude template="#a_str_footer_include#">
</body>
</html>
</cfmailpart>
</cfmail>

<!--- 
 --->

</cfloop>


