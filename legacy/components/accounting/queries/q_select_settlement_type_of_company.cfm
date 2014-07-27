<cfquery name="q_select_settlement_type_of_company" datasource="#request.a_str_db_users#">
SELECT
	settlement_type
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>