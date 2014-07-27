<!--- //

	Module:		Framework
	Description:Reload stored form definitions ...
	

// --->

<cfif isStruct("application.forms")>
	<cfset StructClear(application.forms)>
</cfif>

<cfinvoke component="#application.components.cmp_forms#" method="UpdateFormDefinitionsFromXML" returnvariable="a_bol_init">
</cfinvoke>

reloaded: <cfoutput>#a_bol_init#</cfoutput>


