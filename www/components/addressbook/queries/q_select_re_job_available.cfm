
<cfquery name="q_select_re_job_available" datasource="#GetDSName()#">
SELECT
	COUNT(id) AS count_id
FROM
	remoteedit
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>