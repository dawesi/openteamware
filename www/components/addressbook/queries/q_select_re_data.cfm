<cfquery name="q_select_re_data">
SELECT
	*
FROM
	redata
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>