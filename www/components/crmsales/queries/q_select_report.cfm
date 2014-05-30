<cfquery name="q_select_report">
SELECT
	*
FROM
	crm_reports
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>