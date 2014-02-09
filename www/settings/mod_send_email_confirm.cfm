<!--- //

	Module:		E-Mail
	Description:Send confirmation code to external address
	

// --->
<cfparam name="attributes.userid" default="0">
<cfparam name="attributes.username" default="">
<cfparam name="attributes.id" default="0">

<cfinclude template="/common/scripts/script_utils.cfm">
<cfinclude template="/common/app/inc_lang.cfm">

<cfquery name="q_Select_email_Adr" datasource="#request.a_str_db_users#">
SELECT
	emailadr,confirmcode
FROM
	pop3_data
WHERE
	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.userid#">
	AND
	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(attributes.id)#">
;
</cfquery>

<cfset a_str_confirmation_text = GetLangVal('settings_ph_confirm_external_address_body')>
<cfset a_str_confirmation_text = ReplaceNoCase(a_str_confirmation_text, '%LINK%', 'https://www.openTeamWare.com/rd/webmail/c/?email='&urlencodedformat(q_Select_email_Adr.emailadr)&'&code='&q_Select_email_Adr.confirmcode)>

<cfmail to="#q_Select_email_Adr.emailadr#" from="openTeamWare E-Mail System <KeineAntwortadresse@openTeamWare.com>" subject="#GetLangVal('settings_ph_confirm_external_address_subject')#">
#a_str_confirmation_text#
</cfmail>



