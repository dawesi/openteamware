
<cfparam name="SelectWorkgroupMembersRequest.entrykey" type="string" default="">

<cfquery name="q_select_workgroup_members" datasource="#request.a_str_db_users#">
SELECT
	entrykey,userkey
FROM
	workgroup_members
WHERE
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupMembersRequest.entrykey#">
;
</cfquery>