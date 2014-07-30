<cfquery name="q_select_workgroup_properties">
SELECT
	shortname,groupname,description,entrykey,companykey
FROM
	workgroups
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>