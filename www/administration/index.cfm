<!--- //

	Module:		Administration tool main controller file
	Description: 
	
// --->

<cfparam name="url.action" default="ShowWelcome" type="string">

<cfset request.sCurrentServiceKey = '9596B599-B48F-087E-2A1FA266FEED4D61' />

<cfinclude template="/login/check_logged_in.cfm">

<cfinclude template="utils/inc_check_security.cfm">

<cfset SetHeaderTopInfoString(GetLangVal('adm_ph_page_title')) />

<cfoutput>#GetRenderCmp().GenerateServiceDefaultFile(servicekey = request.sCurrentServiceKey,
										pagetitle = GetLangVal('adm_ph_page_title'))#</cfoutput>

<cfset a_str_resellerkey_log = '' />
<cfset a_str_companykey_log = '' />

<cfif StructKeyExists(url, 'resellerkey')>
	<cfset a_str_resellerkey_log = url.resellerkey />
</cfif>

<cfif StructKeyExists(url, 'companykey')>
	<cfset a_str_companykey_log = url.companykey />
</cfif>

<cfquery name="q_insert_log">
INSERT INTO
	adminactions
	(
	userkey,
	companykey,
	resellerkey,
	dt_created,
	href,
	urlvariables,
	formvariables
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey_log#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_resellerkey_log#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.SCRIPT_NAME#?#cgi.QUERY_STRING#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.QUERY_STRING#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="">
	)
;
</cfquery>

