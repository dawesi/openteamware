<cfquery name="q_select_company_custom_element" datasource="#request.a_str_db_tools#">
SELECT
	content
FROM
	company_custom_elements
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	item_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.elementname#">
;
</cfquery>