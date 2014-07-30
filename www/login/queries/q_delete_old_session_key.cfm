<!--- //

	delete possible old session keys
	
	// --->

<cfquery name="q_delete_old_session_key">
DELETE FROM sessionkeys
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>