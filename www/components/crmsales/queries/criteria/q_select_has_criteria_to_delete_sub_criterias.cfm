<cfquery name="q_select_has_criteria_to_delete_sub_criterias">
SELECT 
	COUNT(id) AS count_id
FROM
	crmcriteria
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	parent_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
;
</cfquery>