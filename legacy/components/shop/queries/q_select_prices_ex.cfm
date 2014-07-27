<cfquery name="q_select_prices_ex" datasource="#request.a_str_db_users#">
SELECT
	unit,price1,durationinmonths,quantity,entrykey
FROM
	prices
WHERE
	productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">
	AND
	resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_resellerkey#">
ORDER BY
	quantity
;
</cfquery>