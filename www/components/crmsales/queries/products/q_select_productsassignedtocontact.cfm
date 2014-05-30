<!--- //
	Module:            CRM / Products
	Description:       selects quantity field from the productsassignedtocontact record identified by entrykey
// --->
<cfquery name="q_select_productsassignedtocontact">
SELECT 
    quantity, 
    contactkey,
    projectkey,
	retail_price,
	purchase_price
FROM 
    productsassignedtocontact
WHERE
    entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.productsassignedtocontactentrykey#"/>
</cfquery>
