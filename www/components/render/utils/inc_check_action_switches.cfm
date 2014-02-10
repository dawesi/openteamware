<!--- //

	Component:	Render
	Function:	GenerateServiceDefaultFile
	Description:check the switches and set the appropriate parametes ...
	

// --->

<cfsetting enablecfoutputonly="yes">

<!--- get the properties for the current service ... --->
<cfset request.a_struct_current_service_actions = GetActionSwitchesForCurrentService() />

<!--- define the base directory ... --->
<cfif Len(request.a_struct_current_service_actions.basedirectory) GT 0>
	<cfset request.a_str_base_include_path = request.a_struct_current_service_actions.basedirectory />
<cfelse>
	<!--- generate the base include path from the CGI path (default) ... --->
	<cfset request.a_str_base_include_path = GetDirectoryFromPath(cgi.SCRIPT_NAME) />
</cfif>

<!--- get the properties for the current action --->
<cfset request.a_struct_current_service_action = GetServiceActionSwitch(request.a_struct_current_service_actions, url.action) />

<!--- generate the header include filename ... --->
<cfset request.a_str_header_include = request.a_str_base_include_path & request.a_struct_current_service_actions.headerinclude />

<!--- include left ... --->
<cfset request.a_str_left_include= '' />

<cfif ListFindNoCase(request.a_struct_current_service_action.attributes, 'noleftinclude') IS 0 AND
	  Len(request.a_struct_current_service_actions.leftinclude) GT 0>
	<cfset request.a_str_left_include = request.a_str_base_include_path & request.a_struct_current_service_actions.leftinclude />
</cfif>

<cfsetting enablecfoutputonly="no">

