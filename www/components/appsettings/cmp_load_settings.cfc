<!--- //

	Module:		Application settings
	Description:Load the settings for an application,
	
				that means more or less the settings for a special subdomain or domain,
				e.g. the colours or headers for
	
	

// --->

<cfcomponent displayname="LoadAppSettings" output="false">
	
	<cfinclude template="/common/scripts/script_utils.cfm">

	<cffunction access="public" name="LoadAppSettings" output="false" returntype="struct"
			hint="load the settings and return a structure with the settings">
		<cfargument name="appname" type="string" required="true" default=""
			hint="the app name?">
		<cfargument name="servername" type="string" required="true" default=""
			hint="the server name (by cgi.server_name)">
		<cfargument name="hostname" type="string" required="no" default="www.openTeamWare.com"
			hint="http host ...">
		
		<cfset var a_str_app_name = '' />
		<cfset var stReturn = StructNew() />
		<cfset var a_str_field_name = '' />
		
		<!--- create the various structures in application scope, which store data ... --->
		
		<!--- cached templates ... --->
		<cfset stReturn.cached_templates = StructNew() />
		
		<!--- cached JS --->
		<cfset stReturn.cached_js = StructNew() />
		
		<!--- form information ... --->
		<cfset stReturn.forms = StructNew() />
		
		<!--- imap connections ... --->
		<cfset stReturn.cached_imap_stores = StructNew() />
		
		<cfset stReturn.app_name = a_str_app_name />
		
		<!--- strcuture holding various properties ... --->
		<cfset stReturn.properties = StructNew() />
		
		<!--- check what has been provided ... the server name or the application name ... --->
		<cfif len(arguments.appname) GT 0>
			<cfset a_str_app_name = arguments.appname />
		<cfelse>
			<cfset a_str_app_name = arguments.servername />
			
			<cfif FindNoCase(':', a_str_app_name) GT 0>
				<cfset a_str_app_name = Mid(a_str_app_name, 1, FindNoCase(':', a_str_app_name)-1) />
			</cfif>
		</cfif>
		
		<!--- now load various preferences from the inboxcc.properties file --->
		<cfinclude template="utils/inc_load_inboxcc_properties_file_data.cfm">
		
		<cflock name="lck_scope_set_app_var" timeout="10" type="exclusive">
    		<cfset application.a_struct_appsettings = stReturn />
			<cfset request.appsettings.properties = stReturn.properties />
  		</cflock>
		
		<!--- check if such an app exists ... --->
		<cfset a_str_app_name = ReplaceNoCase(a_str_app_name, "www.", "")>
		<cfinclude template="queries/q_select_app_exists.cfm">
		
		<cfset stReturn.a_str_app_name = a_str_app_name>
		<cfset stReturn.q_select_app_exists = q_select_app_exists>
		
		<cfif q_select_app_exists.recordcount neq 1>
			<cfset a_str_app_name = "openTeamware.com">
		</cfif>
		
		<!--- select now the settings of the app --->
		<cfinclude template="queries/q_select_settings.cfm">
				
		<cfloop list="#q_select_settings.columnlist#" delimiters="," index="a_str_field_name">
			<cfset stReturn[lcase(a_str_field_name)] = Evaluate("q_select_settings.#a_str_field_name#")>
		</cfloop>
		
		<cfreturn stReturn />
	</cffunction>
	
</cfcomponent>