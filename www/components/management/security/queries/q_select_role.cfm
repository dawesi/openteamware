<cfparam name="SelectRoleRequest.entrykey" type="string" default="">

<cfquery name="q_select_role" datasource="#request.a_str_db_users#">
SELECT
	rolename,description,standardtype,entrykey,workgroupkey
FROM
	roles
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectRoleRequest.entrykey#">
;
</cfquery>