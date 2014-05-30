<!--- //
	Module:            administration (products)
	Description:       Select all (or filtered) products
// --->

<cfquery name="q_select_products">
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
	productgroups.productgroupname AS productgroupname
    <cfif arguments.orderBy CONTAINS 'usedTimes'>
    , COUNT(p.entrykey) as usedTimes
    </cfif>
FROM
    products p
LEFT JOIN
	productgroups ON (productgroups.entrykey = p.productgroupkey)
<cfif arguments.orderBy CONTAINS 'usedTimes'>
LEFT JOIN productsassignedtocontact pa ON p.entrykey = pa.projectkey
</cfif>
WHERE
    1 = 1
    <cfif StructKeyExists(arguments.filter, 'entrykey')>
        AND
        p.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'companykey')>
        AND
        p.companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.companykey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'productgroupkey')>
        AND
        p.productgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productgroupkey#"/>
    </cfif>   
	<cfif StructKeyExists(arguments.filter, 'productgroupkeys')>
        AND
        p.productgroupkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productgroupkeys#" list="true"/>)
    </cfif>     
    <cfif StructKeyExists(arguments.filter, 'enabled')>
        AND
        p.enabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.enabled#"/>
    </cfif>    
<cfif arguments.orderBy CONTAINS 'usedTimes'>
GROUP BY pa.projectkey
</cfif>
<cfif LEN(arguments.orderBy) GT 0>
ORDER BY #arguments.orderBy#
</cfif>
</cfquery>

