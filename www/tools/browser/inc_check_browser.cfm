<!--- //

	Component:	Framework
	Function:	check the browser
	Description:
	
	Header:	

// --->
	
<cfif NOT StructKeyExists(cgi, 'HTTP_USER_AGENT')>
	<cfset request.a_bol_is_current_ie_browser = false />
	<cfexit method="exittemplate">
</cfif>

<!--- <cfif NOT StructKeyExists(variables, 'browser')> --->
	<!--- check browser --->

<!--- </cfif> --->

<cfset request.a_bol_ibx_local_service_running = false />

<cfset request.a_bol_is_current_ie_browser = FindNoCase( 'Explorer', cgi.HTTP_REFERER ) GT 0 />