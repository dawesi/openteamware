<!--- //

	insert into basket 
	
	// --->
	

<cfquery name="q_insert_into_basket" datasource="#request.a_str_db_users#">
INSERT INTO
	bookedservices
	(
	entrykey,
	companykey,
	productkey,
	paid,	
	totalamount,
	productname,
	quantity,
	unit
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_float" value="#arguments.totalamount#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productname#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.unit#">
	)
;
</cfquery>