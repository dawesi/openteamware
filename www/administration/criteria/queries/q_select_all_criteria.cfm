<cfquery name="q_select_all_criteria">
SELECT
	*
FROM
	crmcriteria 
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>
