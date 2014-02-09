<!--- //

	check which outlook sync data are avaliable
	
	// --->
	
<cfquery name="q_select_ol_sync_data" datasource="#request.a_str_db_tools#">
SELECT datatype,dt_created,program_id FROM outlooksettings
WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.stSecurityContext.myuserid#">;
</cfquery>