<!--- //

	select the avaliable quantities and prices ...
	
	// --->
	
<cfparam name="SelectPricesRequest.Entrykey" type="string" default="">
	
<cfquery name="q_select_prices" datasource="#request.a_str_db_users#">
SELECT unit,price1,durationinmonths,quantity,entrykey FROM prices
WHERE productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectPricesRequest.Entrykey#">
ORDER BY quantity;
</cfquery>