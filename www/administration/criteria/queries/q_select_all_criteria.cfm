<cfquery name="q_select_all_criteria" datasource="#request.a_str_db_crm#">
SELECT
	*
FROM
	crmcriteria 
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>
