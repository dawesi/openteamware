<!--- //

	Module:		Cache cleanup
	Description: 
	

// --->

<cfset application.components.cmp_cache = CreateObject('component', request.a_str_component_cache) />
<cfset tmp = application.components.cmp_cache.DoCleanup() />


