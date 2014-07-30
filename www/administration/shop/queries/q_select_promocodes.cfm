<cfquery name="q_select_promocodes">
SELECT
	*
FROM
	assigned_promocodes
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>