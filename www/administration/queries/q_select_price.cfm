<!--- //

	select the avaliable quantities and prices ...
	
	// --->
	
<cfparam name="SelectPriceRequest.Entrykey" type="string" default="">
	
<cfquery name="q_select_price" datasource="#request.a_str_db_users#">
SELECT unit,price1,durationinmonths,quantity,entrykey FROM prices
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectPriceRequest.Entrykey#">;
</cfquery>