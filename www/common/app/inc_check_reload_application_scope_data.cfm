<cfsetting enablecfoutputonly="yes">
<!--- //

	check if we need to reload the data that is cached in the application scope
	
	that happens if something has changed
	
	// --->
	
	
<cfset variables.a_bol_reload_application_scope_data = false>
	
<cflock name="lck_check_app_var_exists" type="exclusive" timeout="3">

	<!--- check if app var exists --->
	<cfset variables.a_bol_app_var_exists = StructKeyExists(application, 'a_str_last_application_cache_uuid')>
	
	<cfif variables.a_bol_app_var_exists>
		<cfset variables.a_str_last_application_cache_uuid_application = application.a_str_last_application_cache_uuid>
	<cfelse>
		<cfset variables.a_str_last_application_cache_uuid_application = 'doesnotexistyet'>
	</cfif>
</cflock>

<cflock name="lck_check_server_var_exists" type="exclusive" timeout="3">

	<!--- check if server var exists --->
	<cfset variables.a_bol_server_var_exists = StructKeyExists(server, 'a_str_last_application_cache_uuid')>
	
	<cfif variables.a_bol_server_var_exists>
		<cfset variables.a_str_last_application_cache_uuid_server = server.a_str_last_application_cache_uuid>
	<cfelse>
		<cfset variables.a_str_last_application_cache_uuid_server = CreateUUID()>
		
		<!--- set server var now ... --->
		<cflock scope="server" timeout="3" type="exclusive">
			<cfset server.a_str_last_application_cache_uuid = variables.a_str_last_application_cache_uuid_server>
		</cflock>
	</cfif>
</cflock>


<cfif Compare(variables.a_str_last_application_cache_uuid_server, variables.a_str_last_application_cache_uuid_application) NEQ 0>
	<!--- reload app scope data ... --->
	<cflock scope="application" timeout="30" type="exclusive">
			
			<h1>reload</h1>
			
			<cfset application.a_str_last_application_cache_uuid = variables.a_str_last_application_cache_uuid_server>
	
	</cflock>
</cfif>

<cfsetting enablecfoutputonly="no">