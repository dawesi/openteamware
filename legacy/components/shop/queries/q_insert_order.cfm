
<cfset a_int_price = ReplaceNoCase(a_int_price, ',', '', 'ALL')>
<cfset a_int_original_price = ReplaceNoCase(a_int_original_price, ',', '', 'ALL')>

<cfif Len(arguments.specialdiscount) gt 0 AND IsNumeric(arguments.specialdiscount) is true>
	<cfset a_str_comment = "Hinweis: Reduziert; Preis lt. Preisliste:  #InsertOrderRequest.OriginalTotalAmount# EUR">
<cfelse>
	<cfset a_str_comment = ''>
</cfif>

<cfquery name="q_insert_order" datasource="#request.a_str_db_users#">
INSERT INTO
	bookedservices
	(
	entrykey,
	companykey,
	productkey,
	paid,
	durationinmonths,
	totalamount,
	createdbyuserkey,
	specialdiscount,
	productname,
	quantity,
	unit,
	comment,
	dt_created
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productkey#">,
	0,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#q_select_customer.settlementinterval#">,
	<cfqueryparam cfsqltype="cf_sql_float" value="#a_int_price#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.createdbyuserkey#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.specialdiscount)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_product.productname#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_product.unit#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_comment#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(Now())#">
	)
;
</cfquery>