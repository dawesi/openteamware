<cfquery name="q_select_promocodes" datasource="#request.a_str_db_users#">
SELECT
	*
FROM
	assigned_promocodes
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.companykey#">
;
</cfquery>