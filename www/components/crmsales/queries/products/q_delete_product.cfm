<!--- //
	Module:            administration (product)
	Description:       deletes the specified product (by entrykey)
// --->
<cfquery name="q_delete_product">
DELETE FROM 
    products
WHERE
    entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"/>
</cfquery>

