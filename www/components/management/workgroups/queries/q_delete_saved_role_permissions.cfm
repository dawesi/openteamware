
<cfparam name="DeleteSavedRoleRequest.entrykey" type="string" default="">

<cfquery name="q_delete_role_permissions" datasource="#request.a_str_db_users#">
DELETE FROM rolepermissions
WHERE rolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DeleteSavedRoleRequest.entrykey#">;
</cfquery>