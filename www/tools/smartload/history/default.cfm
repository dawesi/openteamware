<cfif NOT StructKeyExists(request, 'stSecurityContext')>
	<cfabort>
</cfif>

<cfif StructKeyExists(session, 'a_arr_smartload_urls')>
	<cfset tmp = ArrayClear(session.a_arr_smartload_urls)>
<cfelse>
	<cfset session.a_arr_smartload_urls = ArrayNew(1)>
</cfif>