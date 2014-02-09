<!--- //

	Module:		Address Book
	Description:RemoteEdit Reaction form
	

	
	
	TODO hp: migrate to simple HTML form
	
	or simple XML form
	
	or call XML form with custom actions ...
	
// --->


<!--- the entrykey of the remote edit job ... --->
<cfparam name="url.entrykey" type="string" default="">

<cfinclude template="/common/scripts/script_utils.cfm">
<cfinclude template="../../tools/browser/inc_check_browser.cfm">

<!--- create component and set custom language to false --->
<cfset a_bol_custom_language_has_been_set = false>

<!--- get the current language --->
<cfset a_int_current_language = client.langno />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<link rel="shortcut icon" href="/images/si/star.png" type="image/png" />
	
	<cfoutput>
	#application.components.cmp_render.CallJavaScriptsInclude()#
	#application.components.cmp_render.CallStyleSheetInclude()#
	</cfoutput>
	
	<title><cfoutput>#htmleditformat(GetLangVal('adrb_ph_remote_edit_page_title'))#</cfoutput> / RemoteEdit</title>	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body style="padding:10px;overflow:auto;">

<cfinclude template="../../menu/dsp_inc_top_header.cfm">

<!--- check if an remote edit job is active ... --->
<cfinvoke component="#application.components.cmp_addressbook#" method="RemoteEditJobAvailable" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#url.entrykey#">
</cfinvoke>

<cfif NOT a_bol_return>
	<h4><cfoutput>#GetLangVal('adrb_ph_remote_Edit_job_deleted_or_Executed')#</cfoutput></h4>
	<br /><br />
	<a href="/"><cfoutput>#GetLangVal('lg_ph_goto_homepage')#</cfoutput></a>
	<cfabort>
</cfif>

<!--- get owner userkey --->
<cfset q_select_re_job_data = application.components.cmp_addressbook.GetRemoteEditJobdata(entrykey = url.entrykey) />

<cfset a_str_job_owner_userkey = q_select_re_job_data.userkey />
<cfset a_str_addressbookkey = q_select_re_job_data.objectkey />

<!--- has a custom language been defined? --->
<cfif q_select_re_job_data.languageID GT -1>
	<cfset client.langno = q_select_re_job_data.languageID>
	<cfset a_bol_custom_language_has_been_set = true>
</cfif>

<!--- load userdata --->
<cfset q_select_user_data = application.components.cmp_user.GetUserData(userkey = a_str_job_owner_userkey) />

<cfif q_select_user_data.recordcount IS 0>
	<h4><cfoutput>#GetLangVal('adrb_ph_remote_Edit_job_deleted_or_Executed')#</cfoutput></h4>
	<br /><br />
	<a href="/"><cfoutput>#GetLangVal('lg_ph_goto_homepage')#</cfoutput></a>	
	<cfabort>
</cfif>

<!--- user still active? --->
<cfif q_select_user_data.allow_login IS -1>
	<h4><cfoutput>#GetLangVal('adrb_ph_remote_Edit_job_deleted_or_Executed')#</cfoutput></h4>
	<br /><br />
	<a href="/"><cfoutput>#GetLangVal('lg_ph_goto_homepage')#</cfoutput></a>	
	<cfabort>
</cfif>

<!--- set language if it has not been set yet --->
<cfif NOT a_bol_custom_language_has_been_set>
	<cfset client.langno = q_select_user_data.defaultlanguage>
</cfif>

<!--- the language has been changed ... so reload the whole page in order to
	reflect the changes ... --->
<cfif a_int_current_language NEQ client.langno>
	<cflocation addtoken="no" url="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#&langset=true">
</cfif>

<!--- load permissions of this user ... --->
<cfset stSecurityContext = application.components.cmp_security.GetSecurityContextStructure(userkey = a_str_job_owner_userkey) />
<cfset stUserSettings = application.components.cmp_user.GetUsersettings(userkey = a_str_job_owner_userkey) />

<!--- load data using the permissions of the user --->
<cfinvoke component="#application.components.cmp_addressbook#" method="GetContact" returnvariable="a_struct_load_contact">
	<cfinvokeargument name="entrykey" value="#a_str_addressbookkey#">
	<cfinvokeargument name="securitycontext" value="#stSecurityContext#">
	<cfinvokeargument name="usersettings" value="#stUserSettings#">
</cfinvoke>

<cfif q_select_user_data.allow_login IS -1>
	<h4><cfoutput>#GetLangVal('adrb_ph_remote_Edit_job_deleted_or_Executed')#</cfoutput></h4>
	<br /><br />
	<a href="/"><cfoutput>#GetLangVal('lg_ph_goto_homepage')#</cfoutput></a>	
	<cfabort>
</cfif>

<cfset ACurrentHour = hour(now()) />
<cfif ACurrentHour gt 18>
	<cfset a_str_caption = GetLangVal('cm_ph_good_evening') />
<cfelseif ACurrentHour lt 2>
	<cfset a_str_caption = GetLangVal('cm_ph_good_evening') />
<cfelseif ACurrentHour lt 9>
	<cfset a_str_caption = GetLangVal('cm_ph_good_morning') />
<cfelse>
	<cfset a_str_caption = GetLangVal('cm_ph_hello_formal') />
</cfif>
	
<cfsavecontent variable="a_str_content_welcome">
	
<div style="line-height:16px;padding:20px;">

<cfif q_select_user_data.bigphotoavaliable IS 1>
	<img align="right" vspace="3" hspace="3" src="/tools/img/show_big_userphoto.cfm?entrykey=<cfoutput>#urlencodedformat(q_select_user_data.entrykey)#</cfoutput>&source=re">
</cfif>

<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="addressbook">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="remote_edit_page_1">
</cfinvoke>

<cfsavecontent variable="a_str_output">
	<cfinclude template="#a_str_page_include#">
</cfsavecontent>

<cfset a_str_output = ReplaceNoCase(a_str_output, '%EMAILADDRESS%', q_select_user_data.username, 'ALL') />
<cfset a_str_output = ReplaceNoCase(a_str_output, '%NAME%', q_select_user_data.firstname & ' ' & q_select_user_data.surname, 'ALL') />

<cfoutput>#a_str_output#</cfoutput>
</div>

</cfsavecontent>

<cfoutput>#WriteNewContentBox(a_str_caption & '!', '', a_str_content_welcome)#</cfoutput>
		
<br />
<cfsavecontent variable="a_str_content">

<!--- 	<cfset EditOrCreateContact.action = 'remoteedit'>
	<cfset EditOrCreateContact.query = a_struct_load_contact.q_select_contact>
	<cfset EditOrCreateContact.entrykey = a_struct_load_contact.q_select_contact.entrykey>
	<cfset EditOrCreateContact.RemoteEditJobKey = url.entrykey>
	
			<cfinclude template="../dsp_inc_create_edit_item.cfm">
		
	 --->
<cfset sEntrykeys_fields_to_ignore = 'A8E9621F-ADAB-EF2A-BE9E689B5A3B2469,A879442B-ED54-3881-ADDCABE0C040B168' />
<cfset a_struct_force_element_values = StructNew() />
<cfset a_struct_force_element_values.virt_remote_edit_job_entrykey = url.entrykey />
<cfset sEntrykeys_fields_show_force = 'oa9-ADAB-EF2A-BE9E689B5A3B2469' />

<cfset a_str_form = application.components.cmp_forms.DisplaySavedForm(action = 'create',
						query = a_struct_load_contact.q_select_contact,
						securitycontext = variables.stSecurityContext,
						usersettings = variables.stUserSettings,
						custom_action_url = 'DoSaveRemoteEdit.cfm',
						entrykey = 'A80E19A8-E62D-4219-972809B6ACC361FF',
						objectkey = a_struct_load_contact.q_select_contact.entrykey,
						entrykeys_fields_to_ignore = sEntrykeys_fields_to_ignore,
						force_element_values = a_struct_force_element_values,
						entrykeys_fields_force_to_show = sEntrykeys_fields_show_force) />
						
<cfoutput>#a_str_form#</cfoutput>

</cfsavecontent>
<cfsavecontent variable="a_str_buttons">
</cfsavecontent>

<cfoutput>#WriteNewContentBox(ReplaceNoCase(GetLangVal('adrb_ph_remote_edit_mail_subject'), '%NAME%', q_select_user_data.firstname & ' ' & q_select_user_data.surname), a_str_buttons, a_str_content)#</cfoutput> 

</body>
</html>

