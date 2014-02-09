<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="service">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="ad_email_sent">
</cfinvoke>

<cftry>
<div style="padding:20px;line-height:17px; ">
<cfinclude template="#a_str_page_include#">	
</div>
<cfcatch type="any"> </cfcatch></cftry>