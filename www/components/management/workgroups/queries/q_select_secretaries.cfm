

<cfquery name="q_select_secretaries" datasource="#request.a_str_db_users#">
SELECT
	userkey,
	secretarykey,
	dt_created,
	createdbyuserkey,
	entrykey,
	permission
FROM
	secretarydefinitions
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
;
</cfquery>