
<cfparam name="SelectWorkgroupRoles.workgroupkey" type="string" default="">

<cfquery name="q_select_roles">
SELECT entrykey, rolename, description, dt_created,createdbyuserkey,active,standardtype FROM roles
WHERE  workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupRoles.workgroupkey#">;
</cfquery>