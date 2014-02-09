<!---


changed 05.07.2005: disabled 

<cfparam name="attributes.to" type="string" default="">
<cfparam name="attributes.userkey" type="string" default="">
<cfparam name="attributes.autologinkey" type="string" default="">
<cfparam name="attributes.sex" type="numeric" default="0">
<cfparam name="attributes.surname" type="string" default="">

<cftry>

<cfset a_str_body = GetLangVal('adm_ph_confirmation_mail_body')>
<cfset a_str_body = ReplaceNoCase(a_str_body, '%HREF%', "https://www.openTeamWare.com/rd/l/a_ctac/?u=#attributes.userkey#&a=#Mid(attributes.autologinkey, 1, 4)#")>

<cfif attributes.sex IS 0>
	<cfset a_str_anrede = GetLangVal('cm_wd_male')>
<cfelse>
	<cfset a_str_anrede = GetLangVal('cm_wd_female')>
</cfif>

<cfset a_str_anrede = a_str_anrede & ' ' & attributes.surname>

<cfset a_str_body = ReplaceNoCase(a_str_body, '%NAME%', a_str_anrede)>

<cfmail from="openTeamWare.com Team <feedback@openTeamWare.com>" to="#attributes.to#" subject="#GetLangVal('adm_ph_confirmation_mail_subject')#">
#a_str_body#
</cfmail>

<cfcatch type="any">

</cfcatch>
</cftry>

--->