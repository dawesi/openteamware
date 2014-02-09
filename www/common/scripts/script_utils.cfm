<!--- //

	Module:		Framework
	Description:Include helper scripts (only once!)
	

// --->

		
<cfif StructKeyExists(variables, 'A_BOL_SCRIPT_UTILS_LOADED')>
	<cfexit method="exittemplate">
</cfif>

<cfset variables.a_bol_script_utils_loaded = true />

<cfinclude template="inc_scripts.cfm">

