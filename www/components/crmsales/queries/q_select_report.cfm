<cfquery name="q_select_report" datasource="#request.a_str_db_crm#">
SELECT
	*
FROM
	crm_reports
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>