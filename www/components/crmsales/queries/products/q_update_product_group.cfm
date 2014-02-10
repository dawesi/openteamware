<!--- //
	Module:		 Products
	Description: Updates specified product group
	

	
// --->

<cfquery name="q_update_product_group" datasource="#request.a_str_db_crm#">
UPDATE
	productgroups
SET	
    lasteditedbyuserkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>,
    
    productgroupname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.productgroupname#"/>,
    description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.description#"/>,
    parentproductgroupentrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.parentproductgroupentrykey#"/>,
    category1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category1#"/>,
    category2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.category2#"/>
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.database_values.entrykey#"/>
;
</cfquery>

