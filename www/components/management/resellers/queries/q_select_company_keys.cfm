

<cfquery name="q_select_company_keys" datasource="#request.a_str_db_users#">
SELECT
	entrykey
FROM
	companies
WHERE
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.resellerkey#">
;
</cfquery>