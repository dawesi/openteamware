<!--- //

	Component:	Render
	Description:Include the needed style sheets
	

	
	
	if the browser supports it, use preloading, otherwise the old fashioned way ...
	
	Try to use the cached version with all necessary style informations in one file
	
// --->

<cfset a_bol_use_old_way = NOT StructKeyExists(request, 'a_bol_using_generate_service_default_file_framework') />

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