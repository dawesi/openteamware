<!--- //

	delete possible old session keys
	
	// --->

<cfquery name="q_delete_old_session_key" datasource="#request.a_str_db_users#">
DELETE FROM sessionkeys
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>