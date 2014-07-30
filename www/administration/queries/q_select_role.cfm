
<cfparam name="SelectRoleRequest.entrykey" type="string" default="">

<cfquery name="q_select_role">
SELECT entrykey, rolename, description, dt_created,createdbyuserkey,active,standardtype,workgroupkey FROM roles
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectRoleRequest.entrykey#">;
</cfquery>