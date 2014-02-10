

<cfquery name="q_select_first_workgroup_level" datasource="#request.a_str_db_users#">
SELECT
	workgroup_members.workgroupkey
FROM
	workgroup_members
LEFT JOIN workgroups ON (workgroups.entrykey = workgroup_members.workgroupkey)
WHERE
	userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_userkey#">
	<!---AND
	workgroups.parentkey = ''--->
;
</cfquery>