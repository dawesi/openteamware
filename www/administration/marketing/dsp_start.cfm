

<cfinclude template="../dsp_inc_select_reseller.cfm">

<cfquery name="q_select_affiliate_code" datasource="#request.a_str_db_users#">
SELECT
	affiliatecode,companyname,entrykey
FROM
	reseller
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.resellerkey#">
;
</cfquery>

<cfif q_select_affiliate_code.affiliatecode IS ''>
	<cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="affiliate code requested" type="html">
		<cfdump var="#q_select_affiliate_code#">
	</cfmail>
	
	<cfoutput>#GetLangVal('adm_ph_marketing_link_requested')#</cfoutput>
	
	<cfexit method="exittemplate">
</cfif>

<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="admintool">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="partner_marketing_affiliate">
</cfinvoke>

<cfinclude template="#a_str_page_include#">