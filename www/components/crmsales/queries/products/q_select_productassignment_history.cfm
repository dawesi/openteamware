<!--- //
	Module:            CRM / Products
	Description:       select all or filtered history records (with product title and group name) of specified contact ordered by date
// --->
<cfquery name="q_select_productassignment_history" datasource="#request.a_str_db_crm#">
SELECT
	h.entrykey,
    h.dt_created,
    h.createdbyuserkey,
    h.contactkey,
    h.productkey,
    h.quantity,
    h.comment,
	
	<cfif arguments.by_customer_username>
    	NULL AS username,
		NULL AS customer,
		p.category1,
		p.category2,
		h.retail_price,
		h.purchase_price,
	</cfif>

    p.title,
    p.productgroupkey,
    
    pg.productgroupname
FROM
    productassignment_history h
INNER JOIN products p ON p.entrykey = h.productkey
LEFT JOIN productgroups pg on p.productgroupkey = pg.entrykey
WHERE
    1 = 1
    <cfif StructKeyExists(arguments.filter, 'contactkey')>
        AND
        h.contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contactkey#"/>
    </cfif>
    <cfif StructKeyExists(arguments.filter, 'productkey')>
        AND
        h.productkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productkey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'productgroupkey')>
        AND
        p.productgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productgroupkey#"/>
    </cfif>    
	
	<cfif StructKeyExists(arguments.filter, 'createdbyuserkeys')>
		AND
		h.createdbyuserkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.createdbyuserkeys#" list="true">)
	</cfif>
ORDER BY h.dt_created DESC
</cfquery>

