<!--- //
	
	has the source user an affiliate link?
	
	// --->
	
<!--- get company / check if reseller --->

<!---a_str_job_owner_userkey--->

<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="addressbook">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="remote_edit_success_page">
</cfinvoke>

<cfinclude template="#a_str_page_include#">