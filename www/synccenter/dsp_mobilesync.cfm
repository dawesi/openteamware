<cfprocessingdirective pageencoding="iso-8859-1">

<style type="text/css" media="all">
	a {color:#3300FF;}
</style>
<cf_disp_navigation mytextleft="FAQ MobileSync">

<br><br>

<cfinvoke component="#application.components.cmp_lang#" method="GetTemplateIncludePath" returnvariable="a_str_page_include">
	<cfinvokeargument name="section" value="synccenter">
	<cfinvokeargument name="langno" value="#client.langno#">
	<cfinvokeargument name="template_name" value="mobilesync_faq">
</cfinvoke>

<cfinclude template="#a_str_page_include#">