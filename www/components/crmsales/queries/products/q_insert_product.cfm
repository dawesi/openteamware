<!--- //
	Module:		 Product
	Description: Inserts new product into database
	

	
// --->

<cfquery name="q_insert_product" datasource="#request.a_str_db_crm#">
INSERT INTO
	products
	(
	entrykey,
    dt_created,
    createdbyuserkey,
    lasteditedbyuserkey,

	companykey,
    title,
    description,
    productgroupkey,

    category1,
    category2,

    internalid,
    serialnumber,
    enabled,
    purchase_price,
    retail_price,
    vendorpartnumber,
    partnumber,
    defaultsupporttermindays,
    individualhandling,
    weight,
    productURL
	)
VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(GetUTCTime(now()))#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,
    
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.companykey#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.title#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.description#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.productgroupkey#"/>,
    
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category1#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category2#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.internalid#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.serialnumber#"/>,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.enabled)#"/>,
    <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.database_values.purchase_price)#"/>,
    <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.database_values.retail_price)#"/>,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.vendorpartnumber#"/>,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.partnumber#"/>,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.database_values.defaultsupporttermindays#"/>,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.individualhandling)#"/>,
    <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.database_values.weight)#"/>,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.productURL#"/>
	)
;
</cfquery>

