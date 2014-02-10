<!--- some checks ... --->
<cfquery name="q_select_sub_workgroups" datasource="#request.a_str_Db_users#">
SELECT
	COUNT(id) AS count_id
FROM
	workgroups
WHERE
	parentkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>

<cfif q_select_sub_workgroups.count_id GT 0>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="q_select_members_count" datasource="#request.a_str_db_users#">
SELECT
	COUNT(entrykey) AS count_id
FROM
	workgroup_members
WHERE
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>

<cfif q_select_members_count.count_id GT 0>
	<cfexit method="exittemplate">
</cfif>

<!--- delete roles ... --->
<cfquery name="q_delete_roles" datasource="#request.a_str_db_users#">
DELETE FROM
	roles
WHERE
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>

<!--- delete entry ... --->
<cfquery name="q_delete_workgroup" datasource="#request.a_str_db_users#">
DELETE FROM
	workgroups
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>