<!--- //
	Module:            administration (product)
	Description:       Select all (or filtered) product groups
// --->

<cfquery name="q_select_product_groups">
SELECT
	entrykey,
    dt_created,
    createdbyuserkey,
    lasteditedbyuserkey,

	companykey,
    productgroupname,
    description,
    parentproductgroupentrykey,
    category1,
    category2
FROM
    productgroups
WHERE
    1 = 1
    <cfif StructKeyExists(arguments.filter, 'entrykey')>
        AND
        entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.entrykey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'companykey')>
        AND
        companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.companykey#"/>
    </cfif>    
    <cfif StructKeyExists(arguments.filter, 'parentproductgroupentrykey')>
        AND
        parentproductgroupentrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.parentproductgroupentrykey#"/>
    </cfif>    

</cfquery>

