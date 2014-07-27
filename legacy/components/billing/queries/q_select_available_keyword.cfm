<cfquery name="q_select_available_keyword" datasource="#request.a_str_db_users#">
SELECT
	percent
FROM
	keywords
WHERE
	dedecuted = 0
	AND
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>