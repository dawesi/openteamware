<!--- //

	Component:	Render
	Function:	GeneratePageBodyTag
	Description:Generate the body tag of the html file with various events (e.g. onLoad ...)

// --->

<cfsetting enablecfoutputonly="true">

<!--- no actions ... return the most simple body tag ever seen ... --->
<cfif NOT StructKeyExists(request, 'a_struct_current_service_actions')>
	<cfoutput><body></cfoutput>
	<cfsetting enablecfoutputonly="false">
	<cfexit method="exittemplate">
</cfif>

<cfif StructKeyExists(url, 'smartload') AND url.smartload IS 1>
	<!--- ignore this template if in smartload mode ... --->
	<!--- go away --->
	<cfsetting enablecfoutputonly="false">
	<cfexit method="exittemplate">
</cfif>

<!--- yes, here we go --->
<cfif ListFindNoCase('inpage,action', request.a_struct_current_service_action.type) GT 0>
	<!--- exit because is inpage or action page ... nothing special needed ... --->
	<cfsetting enablecfoutputonly="false">
	<cfexit method="exittemplate">
</cfif>

<!--- check the javascripts to execute ... --->
<cfset variables.a_str_js_onload = '' />

<!--- styles ... --->
<cfset a_str_style = '' />

<cfif ListFindNoCase(request.a_struct_current_service_action.attributes, 'popup') GT 0>
	<cfset a_str_style = 'overflow:auto;' />
</cfif>

<cfif Len(a_str_style) GT 0>
	<cfset a_str_style = 'style="#a_str_style#"' />
</cfif>

<cfif Len(variables.a_str_js_onload) GT 0>
	<cfset variables.a_str_js_onload = 'onload="#a_str_js_onload#"' />
</cfif>

<cfif (ListFindNoCase(request.a_struct_current_service_action.attributes, 'fullwindow') GT 0)>
	<cfset a_str_style = 'style="overflow:hidden;"' />
</cfif>

<cfoutput><body #a_str_style# #variables.a_str_js_onload#></cfoutput>
<cfsetting enablecfoutputonly="false">