<!--- //

	Component:	Render
	Description:Include the needed style sheets
	

	
	
	if the browser supports it, use preloading, otherwise the old fashioned way ...
	
	Try to use the cached version with all necessary style informations in one file
	
// --->

<cfset a_bol_use_old_way = NOT StructKeyExists(request, 'a_bol_using_generate_service_default_file_framework') />

<!--- <cfinclude template="/tools/browser/inc_check_browser.cfm">

<cfset a_str_whole_css_md5 = '' />

<cfloop from="1" to="#ArrayLen(a_arr_stylesheets)#" index="ii">
	<cfset a_str_whole_css_md5 = a_str_whole_css_md5 & a_arr_stylesheets[ii].filename />
</cfloop>

<cfset a_str_whole_css_md5 = Hash(a_str_whole_css_md5) />

<cfset a_str_cached_css_web_file = '/launch/download/' & a_str_whole_css_md5 & request.a_str_dir_separator & 'standard.css' />
<cfset a_str_cached_file = request.a_str_temp_directory & request.a_str_dir_separator & 'downloads' & request.a_str_dir_separator & a_str_whole_css_md5 & request.a_str_dir_separator & 'standard.css' />
 --->
<!--- cached file exists? deliver it! ... --->
<!--- <cfif FileExists(a_str_cached_file)>
	
	<cfif application.a_struct_appsettings.properties.IsTestingserver IS 1>
		<cfset a_str_cached_css_web_file = a_str_cached_css_web_file & '?random=' & CreateUUID() />
	</cfif>
	
	<link rel="stylesheet" href="<cfoutput>#ReplaceNoCase(a_str_cached_css_web_file, '\', '/', 'ALL')#</cfoutput>" type="text/css" />
	<cfexit method="exittemplate">
</cfif>
 --->
<cfoutput>
	<cfloop from="1" to="#ArrayLen(a_arr_stylesheets)#" index="ii">
	<link rel="stylesheet" href="#ReplaceNoCase(a_arr_stylesheets[ii].filename, '\', '/', 'ALL')#" type="text/css" media="#a_arr_stylesheets[ii].media#"/>
	</cfloop>
</cfoutput>

<!--- <script type="text/javascript"><cfoutput>
	<cfloop from="1" to="#ArrayLen(a_arr_stylesheets)#" index="ii">
	IncludeResFile('#JsStringFormat(a_arr_stylesheets[ii].filename)#', 'style', '#JsStringFormat(a_arr_stylesheets[ii].media)#');
	</cfloop>
</cfoutput>
</script> --->
