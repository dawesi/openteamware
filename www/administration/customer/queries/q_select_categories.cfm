<cfquery name="q_select_categories" datasource="#request.a_str_db_users#">
SELECT
	company_default_categories
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>