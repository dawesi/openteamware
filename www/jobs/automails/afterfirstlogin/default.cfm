<!--- //

	Module:		Framework/Jobs
	Description:Send Info after first login
	

// --->

<cfquery name="q_select_users" datasource="#request.a_Str_db_users#">
SELECT
	users.email,
	users.username,
	users.entrykey,
	users.login_count,
	users.sex,
	users.surname,
	users.companykey,
	users.defaultlanguage,
	companies.resellerkey
FROM
	users
LEFT JOIN companies ON (companies.entrykey = users.companykey)
WHERE
	(users.afterfirstloginmailsent = 0)
	AND
	(users.allow_login = 1)
	AND
	(users.login_count >= 1)
	AND
	(resellerkey = '5872C37B-DC97-6EA3-E84EC482D29FC169')
ORDER BY
	users.userid
;
</cfquery>

<cfdump var="#q_select_users#">

<cfif q_select_users.recordcount IS 0>
	<cfexit method="exittemplate">
</cfif>

<!--- create lang component --->
<cfset a_cmp_lang = application.components.cmp_lang />
<cfset a_cmp_users = application.components.cmp_user />
<cfset a_cmp_customize = application.components.cmp_customize />

<!--- update! --->
<cfquery name="q_update" datasource="#request.a_Str_db_users#">
UPDATE
	users
SET 
	afterfirstloginmailsent = 1
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#valuelist(q_select_users.entrykey)#" list="yes">)
;
</cfquery>


<cfloop query="q_select_users">
<cfif q_select_users.sex IS 0>
	<cfset a_str_anrede = a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'cm_wd_male')>
	<cfset a_str_sex = a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'cm_wd_male')>
<cfelse>
	<cfset a_str_anrede = a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'cm_wd_female')>
	<cfset a_str_sex = a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'cm_wd_female')>
</cfif>

<cfset a_str_anrede = a_str_anrede & ' ' & q_select_users.surname>

<cfquery name="q_select_customer_email" datasource="#request.a_str_db_users#">
SELECT
	email
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_users.companykey#">
;
</cfquery>

<!--- get style of user ... --->
<cfset a_str_user_style = a_cmp_users.GetUserCustomStyle(userkey = q_select_users.entrykey)>

<cfoutput>#a_str_user_style#</cfoutput>

<cfset a_str_header_include = a_cmp_customize.GetMailCustomHeader(style = a_str_user_style, langno = q_select_users.defaultlanguage)>
<cfset a_str_footer_include = a_cmp_customize.GetMailCustomFooter(style = a_str_user_style, langno = q_select_users.defaultlanguage)>

<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'mail').FeedbackMailSender>
<cfset a_str_base_url = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'main').BaseURL>
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'main').Productname>
<cfset a_str_productname = a_cmp_customize.GetCustomStyleData(usersettings = a_cmp_users.GetUsersettings(userkey=q_select_users.entrykey), entryname = 'main').Productname>


<cfdump var="#a_str_header_include#" label="a_str_header_include">

<cfsavecontent variable="a_str_rating_overall">
	<cfoutput>
			<cfloop from="1" to="5" index="ii">
				<input type="radio" name="frmoverall" value="#ii#"> #ii#
			</cfloop>
			
			<input type="hidden" name="frmuserkey" value="#q_select_users.entrykey#">
	</cfoutput>
</cfsavecontent>

<cfset a_str_textarea_pro = '<textarea name="frmpro" cols="30" rows="4"></textarea>'>
<cfset a_Str_textarea_contra = '<textarea name="frmcontra" cols="30" rows="3"></textarea>'>
<cfset a_str_textarea_further_feedback = '<textarea name="frmfurtherfeedback" cols="30" rows="3"></textarea>'>

<cftry>
<cfmail charset="utf-8" cc="#q_select_customer_email.email#" from="#a_str_sender_address#" to="#q_select_users.username#" subject="#a_str_anrede#, #a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'snp_ph_firstmail_subject')#">
<cfmailpart type="text">
#a_cmp_lang.GetLangValExt(langno = q_select_users.defaultlanguage, entryid = 'snp_ph_firstmail_textpart')#
</cfmailpart>
<cfmailpart type="html" charset="utf-8">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<style>
		body,p,a,td,input{font-family:Tahoma,Verdana,Arial;font-size:11px;}
	</style>
	<base href="https://#a_str_base_url#/">
	<title>Signup Feedback</title>
</head>

<body>
<cfinclude template="#a_str_header_include#">
<form action="https://#a_str_base_url#/support/?action=afterfirstloginfeedback" style="margin:0px; " method="post">
		<cfinvoke component="#a_cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
			<cfinvokeargument name="section" value="emails">
			<cfinvokeargument name="langno" value="#q_select_users.defaultlanguage#">
			<cfinvokeargument name="template_name" value="signup_mail_after_first_login_html">
		</cfinvoke>
		
		<cfinclude template="#a_str_page_include#">
</form>	
<cfinclude template="#a_str_footer_include#">
</body>
</html>
</cfmailpart>
</cfmail>
<cfcatch type="any">

	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="after first login feedback ERROR" type="html">
	<cfdump var="#q_select_users#">
	<cfdump var="#cfcatch#">
	</cfmail>
</cfcatch>
</cftry>
</cfloop>


