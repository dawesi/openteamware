<cfquery name="q_select_style_company" datasource="#request.a_str_db_users#">
SELECT
	style
FROM
	companies
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_companykey#">
;
</cfquery>