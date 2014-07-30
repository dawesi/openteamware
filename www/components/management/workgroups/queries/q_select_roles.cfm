<cfquery name="q_select_roles">
SELECT
	entrykey, rolename, description, dt_created,createdbyuserkey,active,standardtype
FROM
	roles
WHERE
	workgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.workgroupkey#">
;
</cfquery>