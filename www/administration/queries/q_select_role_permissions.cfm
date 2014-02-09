

<cfparam name="SelectRolePermissionsRequest.entrykey" type="string" default="">

<cfquery name="q_select_role_permissions" datasource="#request.a_str_db_users#">
SELECT rolekey,dt_created,servicekey,allowedactions FROM rolepermissions
WHERE rolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectRolePermissionsRequest.entrykey#">;
</cfquery>