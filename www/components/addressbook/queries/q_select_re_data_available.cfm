
<cfquery name="q_select_re_data_available" datasource="#GetDSName()#">
SELECT
	COUNT(id) AS count_id
FROM
	redata
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>