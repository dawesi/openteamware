<h4><cfoutput>#GetLangVal('adm_ph_help_guides')#</cfoutput></h4>

<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="admintool">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="partner_help_and_guides">
</cfinvoke>

<cfinclude template="#a_str_page_include#">
