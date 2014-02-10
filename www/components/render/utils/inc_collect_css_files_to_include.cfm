<!--- //

	Component:	Render
	Function:	GetListOfStyleSheetstoInclude
	Description:Build a list of css files to use in the current context
	

	
	
	Collect necessary CSS files.
	
	The guideline:
	
	- General CSS (main)
	- Platform CSS (e.g. Mac, Windows)
		fonts only!!
		no specific settings
	- Browser specific CSS (e.g. "IE"
	
// --->

<cfinclude template="/tools/browser/inc_check_browser.cfm">

<!--- default stylesheet ... the BASIS of all other style information --->
<cfset a_str_ss_name = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/standard.css' />

<!--- Mac OS stylehseet ... --->
<cfset a_str_ss_name_mac = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/mac.css' />

<!--- windows stylehseet ... --->
<cfset a_str_ss_name_win = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/win.css' />

<!--- linux stylesheet ... --->
<cfset a_str_ss_name_linux = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/linux.css' />

<!--- internet explorer stylesheet ... --->
<cfset a_str_ss_name_ie = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/ie.css' />

<!--- firefox stylesheet ... --->
<cfset a_str_ss_name_firefox = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/firefox.css' />

<!--- print CSS --->
<cfset a_str_ss_name_print = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/print.css' />

<!--- especially for testing server ... ---->
<cfset a_str_ss_name_debugging_testingserver = '/' & request.a_str_include_dir & '/' & request.a_str_default_style & '/css/testingserver.css' />

<!--- add stylesheets to array ... start collection with default / print CSS --->
<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name, 'all') />
<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_print, 'print') />

<!--- include mac os stylesheet --->
<cfif FindNoCase('Macintosh', cgi.HTTP_USER_AGENT) GT 0>
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_mac, 'all') />
</cfif>

<!--- windows ... --->
<cfif FindNoCase('Windows', cgi.HTTP_USER_AGENT) GT 0>
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_win, 'all') />
</cfif>

<!--- in case of testing server, apply special css ... --->
<cfif application.a_struct_appsettings.properties.IsTestingserver IS 1>
	
	<!--- <cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory") />

	<cfif factory.DebuggingService.isEnabled()>
		<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_debugging_testingserver, 'all') />
	</cfif> --->
</cfif>

<!--- firefox and so on --->
<cfif NOT request.a_bol_is_current_ie_browser>
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_firefox, 'all') />
<cfelse>
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_ie, 'all') />
</cfif>

<!--- now check if we've got a custom stylesheet too ... --->
<cfset a_str_user_defined_stylesheet = StructKeyExists(request, 'stUserSettings') AND
									   StructKeyExists(request.stUserSettings, 'customstyle') AND
									   (Len(request.stUserSettings.customstyle) GT 0) AND
									   (Compare(request.stUserSettings.customstyle, request.a_str_default_style) NEQ 0) />

<!--- otherwise, maybe we've got a custom stylesheet of this domain ... (applies when the user is not logged in) --->
<cfset a_bol_custom_stylesheet_domain_defined =  StructKeyExists(request, 'appsettings') AND
												 StructKeyExists(request.appsettings, 'default_stylesheet') AND
												 (Len(request.appsettings.default_stylesheet) GT 0) AND
												 (Compare(request.appsettings.default_stylesheet, request.a_str_default_style) NEQ 0) />

<cfif a_str_user_defined_stylesheet>
	
	<!--- yes, a custom stylesheet ... --->
	<cfset a_str_ss_name = '/' & request.a_str_include_dir & '/' & request.stUserSettings.customstyle & '/css/standard.css' />
	<cfset a_str_ss_name_print = '/' & request.a_str_include_dir & '/' & request.stUserSettings.customstyle & '/css/print.css' />
	
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name, 'all') />
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_print, 'print') />
	
<cfelseif a_bol_custom_stylesheet_domain_defined>

	<!--- a custom domain style sheet ... --->
	<cfset a_str_ss_name = '/' & request.a_str_include_dir & '/' & request.appsettings.default_stylesheet & '/css/standard.css' />
	<cfset a_str_ss_name_print = '/' & request.a_str_include_dir & '/' & request.appsettings.default_stylesheet & '/css/print.css' />
	
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name, 'all') />
	<cfset a_arr_stylesheets = AddCSSFileToLoad(a_arr_stylesheets, a_str_ss_name_print, 'print') />
</cfif>


<cfexit method="exittemplate">

<cfset a_str_whole_css_file = '' />
<cfset a_str_whole_css_md5 = '' />

<cfloop from="1" to="#ArrayLen(a_arr_stylesheets)#" index="ii">
	<cfset a_str_whole_css_md5 = a_str_whole_css_md5 & a_arr_stylesheets[ii].filename />
</cfloop>

<cfset a_str_whole_css_md5 = Hash(a_str_whole_css_md5) />

<cfset a_str_cached_file = request.a_str_temp_directory & request.a_str_dir_separator & 'downloads' & request.a_str_dir_separator & a_str_whole_css_md5 & request.a_str_dir_separator & 'standard.css' />

<!--- exit if file exists but not in testing mode ... --->
<cfif FileExists(a_str_cached_file) AND NOT (application.a_struct_appsettings.properties.IsTestingserver IS 1)>
	<cfexit method="exittemplate">
</cfif>

<!--- no cached file exists right now ... calculate now the right file content, store it and deliver it ... --->
<cfset a_str_whole_css_md5 = '' />

<cfset a_str_len = ArrayLen(a_arr_stylesheets) />

<cfloop from="1" to="#a_str_len#" index="ii_ss">
	
	<cfset a_str_css_file = request.a_str_wwwroot_www_inbox_cc & request.a_str_dir_separator & a_arr_stylesheets[ii_ss].filename />
	
	<cfif FileExists(a_str_css_file)>
		
		<cffile action="read" charset="utf-8" file="#a_str_css_file#" variable="a_str_css">
	
		<cfset a_str_whole_css_file = a_str_whole_css_file & ' /* ----------- ' & GetFileFromPath( a_str_css_file ) & '------------ */' />
		<cfset a_str_whole_css_file = a_str_whole_css_file & '@media ' & a_arr_stylesheets[ii_ss].media & '{' />
		<cfset a_str_whole_css_file = a_str_whole_css_file & a_str_css />
		<cfset a_str_whole_css_file = a_str_whole_css_file & '} ' />
	
		<cfset a_str_whole_css_md5 = a_str_whole_css_md5 & a_arr_stylesheets[ii_ss].filename />
	<cfelse>
		<cflog file="ib_error_log" application="true" log="Application" type="warning" text="The following CSS file has not been found: #a_Str_css_file#">
	</cfif>

</cfloop>

<!--- generate hashed value, filename and store data ... --->
<cfset a_str_whole_css_md5 = Hash(a_str_whole_css_md5) />
<cfset a_str_download_dir = request.a_str_temp_directory & request.a_str_dir_separator & 'downloads' & request.a_str_dir_separator & a_str_whole_css_md5 & request.a_str_dir_separator />

<cfif NOT DirectoryExists(a_str_download_dir)>
	<cfdirectory action="create" directory="#a_str_download_dir#">
</cfif>

<cfset a_str_temp_file = a_str_download_dir & 'standard.css' />

<cffile action="write" addnewline="false" charset="utf-8" file="#a_str_temp_file#" output="#a_str_whole_css_file#">

