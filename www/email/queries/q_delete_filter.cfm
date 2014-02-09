<!--- //

	delete a filter entry 
	
	// --->
	
<cfparam name="DeleteFilterRequest.id" type="numeric" default="0">

<cfquery name="q_delete_filter" datasource="#request.a_str_db_mailusers#">
DELETE FROM filter
WHERE email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.stSecurityContext.myusername#">
AND id = <cfqueryparam cfsqltype="cf_sql_integer" value="#DeleteFilterRequest.id#">;
</cfquery>