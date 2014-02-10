<cfquery name="q_select_criteria_count" datasource="#request.a_str_db_crm#">
SELECT
	COUNT(id) AS count_id
FROM
	crmcriteria 
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>