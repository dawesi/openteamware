

<cfquery name="q_select_shares">
SELECT
	workgroupkey
FROM
	tasks_shareddata
WHERE
	servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
	AND
	taskkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
;
</cfquery>