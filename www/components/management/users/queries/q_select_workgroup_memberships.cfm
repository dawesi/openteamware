<!--- //
	select memberships
	// --->


<cfparam name="SelectWorkgroupMemberships.entrykey" type="string" default="">

<cfquery name="q_select_workgroup_memberships" datasource="#request.a_str_db_users#">
SELECT
	workgroupkey,roles,dt_created
FROM
	workgroup_members
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupMemberships.entrykey#">
;
</cfquery>