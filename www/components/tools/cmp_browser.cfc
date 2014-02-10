<cfcomponent output='false'>

	<cffunction access="public" name="CheckIfUserAgentIsCurrentIEBrowser" output="false" returntype="boolean">
		<cfargument name="agent" type="string" required="true">
		
		<!--- check if this routine has been called before ... --->
		<cfif StructKeyExists(request, 'a_bol_is_current_ie_browser')>
			<cfreturn a_bol_is_current_ie_browser>
		</cfif>
		
		<cfreturn FindNoCase( 'Explorer', cgi.HTTP_REFERER ) GT 0 />
		
	</cffunction>

</cfcomponent>