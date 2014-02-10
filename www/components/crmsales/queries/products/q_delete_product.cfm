<!--- //
	Module:            administration (product)
	Description:       deletes the specified product (by entrykey)
// --->
<cfquery name="q_delete_product" datasource="#request.a_str_db_crm#">
DELETE FROM 
    products
WHERE
    entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"/>
</cfquery>

