<!--- //

	Module:		Framework
	Description:Check if the user is logged in
	
// --->
<cfsetting enablecfoutputonly="Yes">

<!--- checked if the user is logged in ... TODO cleanup --->

<cfif NOT StructKeyExists(request, 'stSecurityContext')>

	<!--- user is not logged in ... --->
	
	<!--- check if we should save the form values ... --->
	<cfif (cgi.REQUEST_METHOD IS 'POST')>
		
		<!--- TODO: save the post data for later ... --->
		
		<!--- save form values ... --->
		<!--- <cfmail from="#request.appsettings.properties.NotifyEmail#" to="#request.appsettings.properties.NotifyEmail#" subject="test" type="html">
			<cfdump var="#form#">
		</cfmail> --->
	</cfif>
	
	<cfset a_str_add_url = "" />

		<cfloop collection="#Form#" item="i">
    		<cfset a_str_add_url = a_str_add_url & "&" & i & "=" & urlencodedformat(Form[i]) />
		</cfloop>

	<cfset a_str_url = cgi.script_name />

	<cfif Len(cgi.query_string) GT 0>
		<cfset a_str_url = a_str_url & '?' & cgi.query_string & a_str_add_url />
	</cfif>

	<cflocation addtoken="No" url="/login/index.cfm?url=#urlencodedformat(a_str_url)#">

</cfif>

<cfsetting enablecfoutputonly="No">