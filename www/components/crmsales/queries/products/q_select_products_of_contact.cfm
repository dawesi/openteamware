<!--- //
	Module:            products /addressbook
	Description:       select all or filtered products of specified contact
// --->

<cfquery name="q_select_products_of_contact">
SELECT
	pa.entrykey,
    pa.dt_created,
    pa.createdbyuserkey,
    pa.dt_added,
    pa.contactkey,
    pa.projectkey,
    pa.serialnumber,
    pa.quantity,
    pa.retail_price,
    pa.purchase_price,
    pa.comment,

	p.companykey,
    p.title,
    p.description,
    p.productgroupkey,
    p.category1,
    p.category2,
	p.internalid,    
    pg.productgroupname
FROM
    productsassignedtocontact pa
INNER JOIN products p ON p.entrykey = pa.projectkey
LEFT JOIN productgroups pg on p.productgroupkey = pg.entrykey
WHERE
    pa.contactkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactkey#"/>
    <cfif StructKeyExists(arguments.filter, 'entrykey')>
        AND
        pa.entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'projectkey')>
        AND
        pa.projectkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.projectkey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'productgroupkey')>
        AND
        p.productgroupkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.productgroupkey#"/>
    </cfif>    
<cfif LEN(arguments.orderBy) GT 0>
ORDER BY #arguments.orderBy#
</cfif>
</cfquery>


