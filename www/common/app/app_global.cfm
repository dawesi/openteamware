<!--- //

	Module:		Application
	Description:Set some common variables (request scope)

// --->

<cfif StructKeyExists(request, 'bAppInit_running')>
	<cfexit method="exittemplate">
</cfif>

<cfsilent>

<cfif NOT StructKeyExists(request, 'a_bol_app_global_set')>
	<!--- set various STATIC properties ... --->

	<cfscript>
	// admin actions
	request.a_str_admin_actions = 'editmasterdata,order,resetpassword,useradministration,groupadministration,securityadministration,newsadministration,viewlog,viewusercontent,forumadmin';

	// ************ further properties ************
	// product name
	request.a_str_product_name = "openTeamWare";
	// include directories
	request.a_str_include_dir = "include";
	request.a_str_include_pages_dir = "pages";
	request.a_str_include_css_dir = "css";
	request.a_str_include_misc_dir = "misc";
	request.a_str_include_images_dir = "images";
	// waiting img circle
	request.a_str_img_tag_status_loading = '<img src="/images/status/img_circle_loading.gif" width="32" height="32" border="0" alt="..." vspace="4" hspace="4"/ >';
	// toolbar separator
	request.a_str_toolbar_sep_img = '<img alt="" src="/images/menu/img_tb_separator.gif" width="5" height="16" border="0" vspace="0" hspace="0" align="absmiddle" />';
	// default date formats
	request.a_str_default_dt_format = "dd.mm.yy";
	request.a_str_default_js_dt_format = "dd.MM.yy";
	request.a_str_default_long_dt_format = "ddd, dd.mm.yy";
	request.a_str_dir_separator = '/';

	request.a_str_component_logs = "/components/log/cmp_log";
	request.a_str_component_workgroups = "/components/management/workgroups/cmp_workgroup";
	request.a_str_component_secretary = '/components/management/workgroups/cmp_secretary';
	request.a_str_component_resources = '/components/tools/cmp_resources';
	request.a_str_component_security = '/components/management/security/cmp_security';
	request.a_str_component_users = '/components/management/users/cmp_user';
	request.a_str_component_addressbook = '/components/addressbook/cmp_addressbook';
	request.a_str_component_customize = '/components/customize/cmp_customize';
	request.a_str_component_content = '/components/content/cmp_content';
	request.a_str_component_browser = '/components/tools/cmp_browser';
	request.a_str_component_alerts = '/components/tools/cmp_alerts';
	request.a_str_component_tools = '/components/tools/cmp_tools';
	request.a_str_component_forms = '/components/forms/cmp_forms';
	request.a_str_component_session = '/components/tools/cmp_session';
	request.a_str_component_project = '/components/project/cmp_project';
	request.a_str_component_assigned_items = '/components/tools/cmp_assign_items';
	request.a_str_component_admin_stat = '/components/stat/cmp_stat';
	request.a_str_component_followups = '/components/tools/cmp_follow_up';
	request.a_str_component_events = '/components/events/cmp_events';
	request.a_str_component_crm_sales = '/components/crmsales/cmp_crmsales';
	request.a_str_component_lang = '/components/lang/cmp_lang';
	request.a_str_component_render = '/components/render/cmp_render';
	request.a_str_component_protocol = '/components/protocol/cmp_protocol';
	request.a_str_component_locks = '/components/tools/cmp_locks';
	request.a_str_component_import = '/components/import/cmp_import';
	request.a_str_component_person = '/components/tools/cmp_person';
	request.a_str_component_datatypeconvert = '/components/tools/cmp_datatypeconvert';
	request.a_str_component_cache = '/components/cache/cmp_cache';
	request.a_str_component_products = '/components/crmsales/cmp_products';
	request.a_str_component_sql = '/components/tools/cmp_sql';

	// default style
	request.a_str_default_style = '08157A5F-A19B-29A3-9E95FB9C0442E545';
	</cfscript>

</cfif>

<!--- first of all ... check if the app has already been initialized ... --->
<cflock name="lck_scope_check_app_name" timeout="3" type="exclusive">
	<cfset bAppInit = StructKeyExists(application, 'bAppInit') />
</cflock>

<cfif NOT bAppInit>
	<!--- not yet ... app is being run for the first time ... load all preferences --->

  	<!--- create standard components ... --->
  	<cfinvoke component="/components/appsettings/cmp_app_init" method="InitApplicationComponents" returnvariable="a_bol_init">
  	</cfinvoke>

	<!--- load application settings ... --->
  	<cfinvoke component="/components/appsettings/cmp_load_settings" method="LoadAppSettings" returnvariable="stReturn">
   	     <cfinvokeargument name="appname" value="">
		 <cfinvokeargument name="servername" value="#cgi.HTTP_HOST#">
	</cfinvoke>

  	<cflock name="lck_scope_set_app_var" timeout="10" type="exclusive">

		<!--- universal approch for storing data in cache ... --->
		<cfset application.cache = StructNew() />
		<cfset application.cache.cached_elements = StructNew() />
		<cfset application.cache.cache_expire_information = StructNew() />

		<!--- translation data ... --->
		<cfset application.langdata = StructNew() />

		<!--- application settings ... --->
    	<cfset application.a_struct_appsettings = stReturn />

		<!--- we've done basic init! --->
    	<cfset application.bAppInit = true />

  	</cflock>

	<cfset request.appsettings = stReturn />

  	<!--- load action switches --->
  	<cfinvoke component="/components/appsettings/cmp_services" method="LoadAllServicesActionsSwitches" returnvariable="a_struct_switches">
		<cfinvokeargument name="frontend" value="www">
  	</cfinvoke>

  	<cfset application.actionswitches = a_struct_switches />

<cfelse>
  <!--- copy the structure ... --->
  <cfset request.appsettings = StructCopy(application.a_struct_appsettings) />

</cfif>

<cfif NOT StructKeyExists(request, 'a_bol_app_global_set')>
	<!--- set various DYNAMIC! properties ... --->

	<cfscript>
	// generate procmail config ...
	request.a_str_url_generateprocmailconfigurl = request.appsettings.properties.GenerateProcmailConfigScript;
	// update mailbox size ...
	request.a_str_url_updatemaildirsizeurl = request.appsettings.properties.UpdateMaildirSizeScript;
	// create mail dir ...
	request.a_str_url_createmaildirurl = request.appsettings.properties.CreateMailDirScript;

	// NEW: Linux paths
	request.a_str_storage_directory = request.appsettings.properties.StorageDirectory;

	request.a_str_wwwroot_www_inbox_cc = request.appsettings.properties.wwwroot;
	request.a_str_storage_datadir = request.appsettings.properties.StorageDirectory;
	request.a_str_storage_datapath = request.appsettings.properties.StorageDirectory;
	// the default domain ... used for user lookups and so on
	request.a_str_default_domain = request.appsettings.properties.DefaultDomain;
	request.a_str_default_mail_server = request.appsettings.properties.DefaultMailServer;
	request.a_str_default_imap_server = request.appsettings.properties.DefaultIMAPServer;
	// the space image for 1x1 pixel spacer
	request.a_str_img_1_1_pixel_location = request.appsettings.properties.PixelLocation;
	// set now that all properties have been set!
	request.a_bol_app_global_set = 1;
	</cfscript>

</cfif>

<!--- directory for transfer files --->
<cfset a_str_transfer_dir = getTempDirectory() & '/transfer/' />

<cfif NOT DirectoryExists( a_str_transfer_dir )>
	<cfdirectory action="create" directory="#a_str_transfer_dir#">
</cfif>

<cfset a_str_langs_to_load = '' />
<!--- Load translation data if necessary ... DE, EN, CZ, SK, PL, RO --->

<cflock scope="Application" timeout="30" type="readonly">
<cfloop from="0" to="5" index="iLangNo">

	<!--- if lang struct does not exist, reload it ... --->
	<cfset a_bol_lang_loaded = StructKeyExists(application.langdata, 'lang' & iLangNo) />

	<cfif NOT a_bol_lang_loaded>
		<cfset a_str_langs_to_load = ListAppend(a_str_langs_to_load, iLangNo) />
	</cfif>
</cfloop>
</cflock>

<cfif Len(a_str_langs_to_load) GT 0>
	<cfloop list="#a_str_langs_to_load#" index="iLangNo">
	<cfset application.components.cmp_lang.LoadTranslationData(langno = iLangNo) />
	</cfloop>
</cfif>

<cfset server.abc = StructKeyExists(server, 'a_struct_custom_styles') />

<!--- load custom styles (server wide) --->
<cflock scope="server" type="readonly" timeout="3">
	<cfset a_bol_styles_loaded = StructKeyExists(server, 'a_struct_custom_styles') />
</cflock>

<cftry>
	<cfif NOT a_bol_styles_loaded>
		<!--- load styles ... --->
		<cflock scope="server" timeout="5" type="exclusive">
			<cfset server.a_struct_custom_styles = application.components.cmp_customize.ReturnAllAvailableStyles() />
		</cflock>
</cfif>

<cfcatch type="any">
	<cfmail from="support@openTeamware.com" to="support@openTeamware.com" subject="excep" type="html">
	<cfdump var="#cfcatch#">
	</cfmail>
</cfcatch>
</cftry>

</cfsilent>