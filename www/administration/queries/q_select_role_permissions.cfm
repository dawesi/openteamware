

<cfparam name="SelectRolePermissionsRequest.entrykey" type="string" default="">

<cfquery name="q_select_role_permissions">
SELECT rolekey,dt_created,servicekey,allowedactions FROM rolepermissions
WHERE rolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectRolePermissionsRequest.entrykey#">;
</cfquery>