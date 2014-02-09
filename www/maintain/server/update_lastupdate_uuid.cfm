<!--- //

	update the last update uuid so that all applications know that
	they have to update their data they've cached in the
	application scope
	
	// --->
	
<cflock scope="server" timeout="3" type="exclusive">
	<cfset server.a_str_last_application_cache_uuid = CreateUUID()>
</cflock>