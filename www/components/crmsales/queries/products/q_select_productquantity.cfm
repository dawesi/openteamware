<!--- //
	Module:            administration (products)
	Description:       Select all (or filtered) products quantity
// --->

<cfquery name="q_select_productquantity">
SELECT
	p.entrykey,
    p.dt_created,
    p.createdbyuserkey,
    p.lasteditedbyuserkey,
	
	p.companykey,
    p.title,
    p.description,
    p.productgroupkey,
    
    p.internalid,
    p.serialnumber,
    p.enabled,
    p.purchase_price,
    p.retail_price,
    p.vendorpartnumber,
    p.partnumber,
    p.defaultsupporttermindays,
    p.individualhandling,
    p.weight,
    p.category1,
    p.category2,
    p.productURL,

	pq.quantity,
	pq.entrykey AS productquantitykey
	
	
FROM
    products p

LEFT JOIN productquantity pq ON p.entrykey = pq.productkey and pq.userkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.securitycontext.myuserkey#"/>

WHERE
    1 = 1
    <cfif StructKeyExists(arguments.filter, 'productkey')>
        AND
        p.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productkey#"/>
    </cfif>
	<cfif StructKeyExists(arguments.filter, 'productkeys')>
        AND
        p.entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productkeys#" list="yes"/>)
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'companykey')>
        AND
        p.companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.companykey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'enabled')>
        AND
        p.enabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.enabled#"/>
    </cfif>    
</cfquery>

