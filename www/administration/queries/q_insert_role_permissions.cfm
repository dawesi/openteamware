<!--- 

	insert permissions
	
	--->
	
<cfparam name="InsertRolePermissions.workgroupkey" type="string" default="">
<cfparam name="InsertRolePermissions.rolekey" type="string" default="">
<cfparam name="InsertRolePermissions.servicekey" type="string" default="">
<cfparam name="InsertRolePermissions.allowedactions" type="string" default="">
	
<cfquery name="q_insert_role_permissions">
INSERT INTO rolepermissions
(workgroupkey,rolekey,dt_created,servicekey,allowedactions)
VALUES
(
<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertRolePermissions.workgroupkey#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertRolePermissions.rolekey#">,
<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Createodbcdatetime(now())#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertRolePermissions.servicekey#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertRolePermissions.allowedactions#">
);
</cfquery>