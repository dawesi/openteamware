<cfquery name="q_select_quota" datasource="#request.a_str_db_users#">
SELECT
	companykey,productkey,availableunits
FROM
	consumergoods
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="AD9947E9-92B7-635C-B48BC5D8259841DF">
;
</cfquery>