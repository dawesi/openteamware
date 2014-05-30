<!--- //

	Cmp:		Security
	Fn:			GetWorkgroupSharesForObject
	Description:Load workgroup shares ...
	
// --->

<cfquery name="q_select_shares">
SELECT
	shareddata.workgroupkey,
	'' AS workgroupname
FROM
	shareddata
WHERE
	addressbookkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
AND
	shareddata.workgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(securitycontext.q_select_workgroup_permissions.workgroup_key)#" list="yes">)
;
</cfquery>
