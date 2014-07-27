<!--- //

	Module:		Maintain
	Description:Reload all components cached in application scope
	

// --->

<cfset StructClear( application )>

<cfif StructKeyExists(application, "components")>
	<cfset StructClear(application.components) />
</cfif>

<cfinvoke component="/components/appsettings/cmp_app_init" method="InitApplicationComponents" returnvariable="a_bol_init">
</cfinvoke>

reloaded: <cfoutput>#a_bol_init#</cfoutput>

