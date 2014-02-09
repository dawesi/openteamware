<!--- //



	insert an order request

	

	

	THIS MIGHT ALSO BE A DISCOUNT ORDER (price < 0)

	

	// --->

	

<cfparam name="InsertOrderRequest.productkey" type="string" default="">

<cfparam name="InsertOrderRequest.entrykey" type="string" default="">

<cfparam name="InsertOrderRequest.companykey" type="string" default="">

<cfparam name="InsertOrderRequest.paid" type="numeric" default="0">

<cfparam name="InsertOrderRequest.durationinmonths" type="numeric" default="24">

<cfparam name="InsertOrderRequest.totalamount" default="0">

<cfset InsertOrderRequest.totalamount = ReplaceNoCase(InsertOrderRequest.totalamount, ',', '', 'ALL')>

<cfparam name="InsertOrderRequest.OriginalTotalAmount" default="0">

<cfset InsertOrderRequest.OriginalTotalAmount = ReplaceNoCase(InsertOrderRequest.OriginalTotalAmount, ',', '', 'ALL')>

<cfparam name="InsertOrderRequest.specialdiscount" default="">

<cfparam name="InsertOrderRequest.contractend" type="date">

<cfparam name="InsertOrderRequest.createdbyuserkey" type="string" default="">

<cfparam name="InsertOrderRequest.quantity" type="numeric" default="1">



<!--- select the productname ... --->

<cfset SelectProductRequest.entrykey = InsertOrderRequest.productkey>

<cfinclude template="q_select_product.cfm">



<cfset a_str_product_name = q_select_product.productname>

<cfset a_str_comment = "">



<cfif Len(InsertOrderRequest.specialdiscount) gt 0 AND IsNumeric(InsertOrderRequest.specialdiscount) is true>

	<cfset a_str_comment = "Hinweis: Reduziert; Preis lt. Preisliste:  #InsertOrderRequest.OriginalTotalAmount# EUR">

</cfif>



<cfquery name="q_insert_order" datasource="#request.a_str_db_users#">

INSERT INTO bookedservices

(entrykey,companykey,productkey,paid,durationinmonths,totalamount,dt_contractend,createdbyuserkey,

specialdiscount,productname,quantity,unit,comment)

VALUES

(

<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertOrderRequest.entrykey#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertOrderRequest.companykey#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertOrderRequest.productkey#">,

<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertOrderRequest.paid#">,

<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertOrderRequest.durationinmonths#">,

<cfqueryparam cfsqltype="cf_sql_float" value="#InsertOrderRequest.totalamount#">,

<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(InsertOrderRequest.contractend)#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertOrderRequest.createdbyuserkey#">,

<cfqueryparam cfsqltype="cf_sql_integer" value="#val(InsertOrderRequest.specialdiscount)#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_product.productname#">,

<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertOrderRequest.quantity#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_product.unit#">,

<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_comment#">

);

</cfquery>