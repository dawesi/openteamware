<cfquery name="q_select_featurestatus_for_product" datasource="#request.a_str_db_users#">
SELECT
	param
FROM
	scopeofservices
WHERE
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
	AND
	featurename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.featurename#">
;
</cfquery>