<!--- //
	Module:		 Products
	Description: Updates specified product
	

	
// --->

<cfquery name="q_update_product" datasource="#request.a_str_db_crm#">
UPDATE
	products
SET	
    lasteditedbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,

    title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.title#"/>,
    description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.description#"/>,
    productgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.productgroupkey#"/>,

    category1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category1#"/>,
    category2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category2#"/>,
    internalid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.internalid#"/>,
    serialnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.serialnumber#"/>,
    enabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.enabled)#"/>,
    purchase_price = <cfqueryparam cfsqltype="cf_sql_float" value="#Val(arguments.database_values.purchase_price)#"/>,
    retail_price = <cfqueryparam cfsqltype="cf_sql_float" value="#Val(arguments.database_values.retail_price)#"/>,
    vendorpartnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.vendorpartnumber#"/>,
    partnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.partnumber#"/>,
    defaultsupporttermindays = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.defaultsupporttermindays)#"/>,
    individualhandling = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.database_values.individualhandling)#"/>,
    weight = <cfqueryparam cfsqltype="cf_sql_float" value="#val(arguments.database_values.weight)#"/>,
    productURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.productURL#"/>
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#"/>
;
</cfquery>

