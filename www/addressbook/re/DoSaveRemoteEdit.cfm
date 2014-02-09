<!--- //

	Module:		Address Book / Remote Edit
	Description:Store result
	

// --->
<cfparam name="form.frmentrykey" type="string" default="">
<cfparam name="form.frmcbsendinfo" type="numeric" default="0">
<cfparam name="form.frmsex" type="numeric" default="0">

<!--- create needed components --->
<cfset a_cmp_users = application.components.cmp_user />
<cfset a_cmp_customize = application.components.cmp_customize />
<cfset a_cmp_contacts = application.components.cmp_addressbook />

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<cfinclude template="/style_sheet.cfm">
	<title><cfoutput>#GetLangVal('cm_ph_thank_you')#</cfoutput></title>
</head>

<body>

<cfinclude template="/common/scripts/script_utils.cfm">

<cfinclude template="../../menu/dsp_inc_top_header.cfm">

<cfif cgi.REQUEST_METHOD NEQ 'POST'>
	Ein Fehler ist aufgetreten. Bitte nutzen Sie ausschliesslich den originalen Link, den Sie fuer diese Funktion erhalten haben.
	<br>
	An error occured - please use the original link you've received only.
	<cfabort>
</cfif>


<!--- check --->
<cfinvoke component="#a_cmp_contacts#" method="RemoteEditJobAvailable" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmremoteeditjobjey#">
</cfinvoke>

<cfif NOT a_bol_return>
	Die RemoteEdit-Freigabe wurde vom Benutzer entfernt bzw. bereits ausgefuehrt.
	<br><br>
	The RemoteEdit job has been deleted or already been executed.
	<cfabort>
</cfif>

<cfinvoke component="#a_cmp_contacts#" method="GetRemoteEditJobdata" returnvariable="q_select_re_job_data">
	<cfinvokeargument name="entrykey" value="#form.frmremoteeditjobjey#">
</cfinvoke>

<cfset a_str_job_owner_userkey = q_select_re_job_data.userkey>
<cfset a_str_addressbookkey = q_select_re_job_data.objectkey>

<!--- load userdata --->
<cfinvoke component="/components/management/users/cmp_load_userdata" method="LoadUserData" returnvariable="a_struct_load_userdata">
	<cfinvokeargument name="entrykey" value="#a_str_job_owner_userkey#">
</cfinvoke>

<cfset q_select_user_data = a_struct_load_userdata.query>

<cfset a_str_user_style = a_cmp_users.GetUserCustomStyle(userkey = q_select_user_data.entrykey)>

<!--- save data ... --->
<cfinvoke component="#a_cmp_contacts#" method="SaveRemoteEditData" returnvariable="a_bol_return">	
	<cfinvokeargument name="entrykey" value="#form.frmentrykey#">
	<cfinvokeargument name="firstname" value="#form.frmfirstname#">
	<cfinvokeargument name="surname" value="#form.frmsurname#">
	<cfinvokeargument name="title" value="#form.frmtitle#">
	<cfinvokeargument name="sex" value="#form.frmsex#">
	<cfinvokeargument name="company" value="#form.frmcompany#">
	<cfinvokeargument name="department" value="#form.frmdepartment#">
	<cfinvokeargument name="position" value="#form.frmposition#">
	<cfinvokeargument name="email_prim" value="#form.frmemail_prim#">
	<cfinvokeargument name="email_adr" value="#form.frmemail_adr#">
	<cfinvokeargument name="birthday" value="#form.frmbirthday#">
	<cfinvokeargument name="b_street" value="#form.frmb_street#">
	<cfinvokeargument name="b_city" value="#form.frmb_city#">
	<cfinvokeargument name="b_zipcode" value="#form.frmb_zipcode#">
	<cfinvokeargument name="b_country" value="#form.frmb_country#">
	<cfinvokeargument name="b_telephone" value="#form.frmb_telephone#">
	<cfinvokeargument name="b_fax" value="#form.frmb_fax#">
	<cfinvokeargument name="b_mobile" value="#form.frmb_mobile#">
	<!--- <cfinvokeargument name="b_url" value="#form.frmb_url#"> --->
	<cfinvokeargument name="p_street" value="#form.frmp_street#">
	<cfinvokeargument name="p_city" value="#form.frmp_city#">
	<cfinvokeargument name="p_zipcode" value="#form.frmp_zipcode#">
	<cfinvokeargument name="p_country" value="#form.frmp_country#">
	<cfinvokeargument name="p_telephone" value="#form.frmp_telephone#">
	<!--- <cfinvokeargument name="p_fax" value="#form.frmp_fax#"> --->
	<cfinvokeargument name="p_mobile" value="#form.frmp_mobile#">
	<!--- <cfinvokeargument name="p_url" value="#form.frmp_url#">
	<cfinvokeargument name="skypeusername" value="#form.frmskypeusername#"> --->
	
	<cfif Len(form.frmnotices) GT 0>
		<cfset a_str_add = '----- Comment RemoteEdit ' & DateFormat(Now(), 'dd.mm.yyyy') & ' ' & TimeFormat(Now(), 'HH:mm') & ':' & chr(13) & chr(10) & form.frmnotices>
		<cfinvokeargument name="notice" value="ADDTEXT:#a_str_add#">
	</cfif>
</cfinvoke>

<!--- delete now the remote edit job --->
<cfinvoke component="#request.a_str_component_addressbook#" method="DeleteRemoteEditJob" returnvariable="a_bol_return">
	<cfinvokeargument name="entrykey" value="#form.frmremoteeditjobjey#">
	<cfinvokeargument name="deleteremoteeditdata" value="false">
</cfinvoke>

<!--- <cfif form.frmcbsendinfo IS 1>
	<!--- send short information to the sender ... --->
	<cfinclude template="inc_send_mail.cfm">
</cfif>
 --->
<cfset a_str_mail_base_href = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_user_style, entryname = 'main').BaseURL />
<cfset a_str_sender_address = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_user_style, entryname = 'mail').FeedbackMailSender />
<cfset a_str_product_name = a_cmp_customize.GetCustomStyleDataWithoutUsersettings(style = a_str_user_style, entryname = 'main').Productname />

<cfif ExtractEmailAdr(form.frmemail_prim) GT 0>
	<cfset a_str_sender_address = ExtractEmailAdr(form.frmemail_prim) />
<cfelse>
	<cfset a_str_sender_address = a_str_sender_address />
</cfif>

<cfset a_str_subject = GetLangVal('adrb_ph_remote_edit_notific_mail_subject')>
<cfset a_str_subject = ReplaceNoCase(a_str_subject, '%NAME%', form.frmfirstname & ' ' & form.frmsurname)>

<cfset a_str_body = GetLangVal('adrb_ph_remote_edit_notific_mail_body')>
<cfset a_str_body = ReplaceNoCase(a_str_body, '%NAME%', form.frmfirstname & ' ' & form.frmsurname)>

<!--- alert user --->
<cftry>
<cfmail to="#q_select_user_data.username#" from="#a_str_sender_address#" subject="#a_str_subject#">
#a_str_body#

https://#a_str_mail_base_href#/rd/a/c/?#urlencodedformat(a_str_addressbookkey)#

<cfif Len(form.frmnotices) GT 0>
---------- <cfoutput>#GetLangVal('adrb_wd_notices')#</cfoutput>:
#form.frmnotices#
----------
</cfif>

powered by #a_str_product_name#
</cfmail>
<cfcatch type="any"> </cfcatch></cftry>

<div style="padding:10px;">
<b><cfoutput>#GetLangVal('adrb_ph_remote_edit_data_transfered')#</cfoutput></b>

<cfset a_str_custom_content = application.components.cmp_content.GetCompanyCustomElement(companykey = q_select_user_data.companykey, elementname = 'remote_edit_confirmation_page')>


<cfif Len(a_str_custom_content) GT 0>
	<div style="border-bottom:silver solid 1px;padding:10px; "><cfoutput>#a_str_custom_content#</cfoutput></div>
</cfif>

<cfinvoke component="#application.components.cmp_customize#" method="GetCobrandedElement" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="cobranding">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="ad_remote_edit_done">
	<cfinvokeargument name="style" value="#request.appsettings.default_stylesheet#">
</cfinvoke>

<cftry>
<div style="padding:20px;line-height:17px; ">
<cfinclude template="#a_str_page_include#">	
</div>
<cfcatch type="any"> </cfcatch></cftry>

<cfif request.appsettings.entrykey IS '576FCC20-D206-4FB1-AD2215D7C03A709C'>
	<cfinclude template="dsp_inc_ad.cfm">
</cfif>
</div>

</body>
</html>



