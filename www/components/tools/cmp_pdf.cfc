<!--- //

	Component:	PDF
	Description:Create a PDF from html content

// --->
<cfcomponent output="false">

	<cfinclude template="/common/app/app_global.cfm">

	<cffunction access="public" name="CreatePDFofHTMLContent" output="false" returntype="string"
			hint="Create the PDF and return the filename of the PDF">
		<cfargument name="htmlcontent" type="string" required="true"
			hint="the html content to convert into PDF">

		<!--- set variables ... dest filename and temp file ... --->
		<cfset var a_str_tmp_file = getTempDirectory() & request.a_str_dir_separator & CreateUUID()& '.html' />
		<cfset var a_str_dest_file = getTempDirectory() & request.a_str_dir_separator & CreateUUID() & '.pdf' />
		<cfset var a_str_sh_filename = getTempDirectory() & request.a_str_dir_separator & CreateUUID() & '.sh' />

		<!--- arguments for creating PDF ... --->
		<cfset var a_str_arguments = "--webpage -f #a_str_dest_file# #a_str_tmp_file# --quiet --left 10mm --right 10mm --top 5mm --textfont Arial" />

		<cfset var a_str_sh_cmd = '/usr/bin/htmldoc ' & a_str_arguments />

		<!--- write .html content ... --->
		<cffile action="write" addnewline="no" charset="iso-8859-1" file="#a_str_tmp_file#" output="#arguments.htmlcontent#">

		<!--- write sh file ... --->
		<cffile action="write" addnewline="false" charset="iso-8859-1" file="#a_str_sh_filename#" output="#a_str_sh_cmd#">

		<cfexecute name="sh" arguments="#a_str_sh_filename#" timeout="30"></cfexecute>

		<cfreturn  a_str_dest_file />

	</cffunction>

</cfcomponent>