<cfinvoke component="/components/appsettings/cmp_load_settings" method="LoadAppSettings" returnvariable="stReturn">
	<cfinvokeargument name="appname" value="">
	<cfinvokeargument name="servername" value="#cgi.SERVER_NAME#">
</cfinvoke>

<cflock name="lck_scope_set_app_var" timeout="10" type="exclusive">
	<cfset application.a_struct_appsettings = stReturn>
	<cfset application.bAppInit = true>
</cflock>