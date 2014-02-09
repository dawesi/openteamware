
<cfparam name="SelectWorkgroupRoles.workgroupkey" type="string" default="">

<cfquery name="q_select_roles" datasource="#request.a_str_db_users#">
SELECT entrykey, rolename, description, dt_created,createdbyuserkey,active,standardtype FROM roles
WHERE  workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupRoles.workgroupkey#">;
</cfquery>