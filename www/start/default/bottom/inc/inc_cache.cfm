<!--- //

	Description:Caching of javascripts and so on
	

// --->


<!--- // preload javascripts // --->
<cfset a_str_js_dir = request.a_str_wwwroot_www_inbox_cc & request.a_str_dir_separator & 'common' & request.a_str_dir_separator & 'js' />

<!--- list .js files ... --->
<cfdirectory action="list" directory="#a_str_js_dir#" recurse="false" name="q_select_javascripts" filter="*.js">

<!--- cache in app scope in future times ... application.cached_js --->
<cfset ii_cached_index = 0 />

<cfsavecontent variable="a_str_js">
	<cfoutput query="q_select_javascripts">
	myscripts[#(q_select_javascripts.currentrow - 1)#]= '/common/js/#q_select_javascripts.name#';
	</cfoutput>
</cfsavecontent>

<cfset tmp = AddJSToExecuteAfterPageLoad('PreloadNextJavaScript()', a_str_js) />



