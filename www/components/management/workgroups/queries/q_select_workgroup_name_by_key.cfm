

<cfparam name="SelectWorkgroupnamebyKeyRequest.entrykey" type="string" default="">



<cfquery name="q_select_workgroup_name_by_key">
SELECT
	shortname,groupname
FROM
	workgroups
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectWorkgroupnamebyKeyRequest.entrykey#">
;
</cfquery>