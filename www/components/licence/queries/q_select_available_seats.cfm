
<cfquery name="q_select_available_seats">
SELECT
	companykey,productkey,availableseats,inuse,totalseats
FROM
	licencing
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">
	AND
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
;
</cfquery>