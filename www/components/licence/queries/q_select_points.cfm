<cfquery name="q_select_points">
SELECT
	companykey,productkey,availableunits
FROM
	consumergoods
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="E11A2209-9448-1723-8EEEDF6CCB91E747">
;
</cfquery>