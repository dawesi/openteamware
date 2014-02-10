<cfparam name="SelectCustomRolePermissions.entrykey" type="string" default="">
<cfparam name="SelectCustomRolePermissions.servicekey" type="string" default="">

<cfquery name="q_select_custom_role_permissions" datasource="#request.a_str_db_users#">
SELECT
	allowedactions
FROM
	rolepermissions
WHERE
	rolekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCustomRolePermissions.entrykey#">
	AND
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectCustomRolePermissions.servicekey#">
;
</cfquery>