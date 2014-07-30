
<!--- //

	insert a role ...
	
	// --->
	
<cfquery name="q_insert_role">
INSERT INTO roles
(entrykey,rolename,description,workgroupkey,dt_created,createdbyuserkey,active,standardtype,standardallowedactions)
VALUES
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateRoleRequest.entrykey#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateRoleRequest.rolename#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateRoleRequest.description#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateRoleRequest.workgroupkey#">,
<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateRoleRequest.createdbyuserkey#">,
1,
<cfqueryparam cfsqltype="cf_sql_integer" value="#CreateRoleRequest.standardtype#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateRoleRequest.standardallowedactions#">);
</cfquery>