<cfquery name="q_select_company_default_language" datasource="#request.a_str_db_users#">
SELECT
	language
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>