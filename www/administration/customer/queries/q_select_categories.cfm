<cfquery name="q_select_categories">
SELECT
	company_default_categories
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>