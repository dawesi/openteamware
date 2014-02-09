

<cfquery name="q_select_shares" datasource="#request.a_str_db_tools#">
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