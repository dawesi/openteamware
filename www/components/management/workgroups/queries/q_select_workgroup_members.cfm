
<cfparam name="SelectWorkgroupMembersRequest.entrykey" type="string" default="">

<cfquery name="q_select_workgroup_members">
SELECT
	entrykey,userkey
FROM
	workgroup_members
WHERE
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupMembersRequest.entrykey#">
;
</cfquery>