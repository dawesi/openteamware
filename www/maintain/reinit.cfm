<!--- //
reinit everything
// --->


<cfinvoke component="/components/appsettings/cmp_load_settings" method="LoadAppSettings" returnvariable="stReturn">
	<cfinvokeargument name="appname" value="">
	<cfinvokeargument name="servername" value="#cgi.SERVER_NAME#">
</cfinvoke>

<cflock name="lck_scope_set_app_var" timeout="10" type="exclusive">
	<cfset application.a_struct_appsettings = stReturn>
	<cfset application.bAppInit = true>
</cflock>



<cfinvoke component="/components/appsettings/cmp_services" method="LoadAllServicesActionsSwitches" returnvariable="a_struct_switches">
	<cfinvokeargument name="frontend" value="www">
</cfinvoke>

<cflock scope="Application" type="exclusive" timeout="30">
	<cfset application.actionswitches = a_struct_switches>
</cflock>

OK, ACTIONSWITCHES RELOADED
<br /><br />

<cfinvoke component="/components/appsettings/cmp_services" method="LoadAvailableSecurityActionsOfServices" returnvariable="a_struct_switches">
	<cfinvokeargument name="frontend" value="www">
</cfinvoke>

OK, AVAILABLE ACTIONS RELOADED

<cfif StructKeyExists(application, "components")>
	<cfset StructClear(application.components) />
</cfif>

<cfinvoke component="/components/appsettings/cmp_app_init" method="InitApplicationComponents" returnvariable="a_bol_init">
</cfinvoke>

reloaded: <cfoutput>#a_bol_init#</cfoutput>


<cfif isStruct("application.forms")>
	<cfset StructClear(application.forms)>
</cfif>

<cfinvoke component="#application.components.cmp_forms#" method="UpdateFormDefinitionsFromXML" returnvariable="a_bol_init">
</cfinvoke>

reloaded: <cfoutput>#a_bol_init#</cfoutput>



<!--- reload translation ... --->
<cfinvoke component="#application.components.cmp_lang#" method="ReadTranslationsFromCSV" returnvariable="ab">
</cfinvoke>

<!--- reload lang ... --->
<cfloop from="0" to="7" index="ii">
	<cfhttp url="http://#cgi.http_host#/lang/loadlang.cfm?LoadLanguageNo=#ii#" delimiter="," resolveurl="no"></cfhttp>

	lang <cfoutput>#ii#</cfoutput> done.
	<br />
</cfloop>


