<!--- //
	Module:            administration (product)
	Description:       deletes the specified product group (by entrykey)
// --->
<cfquery name="q_delete_product_group" datasource="#request.a_str_db_crm#">
DELETE FROM 
    productgroups
WHERE
    entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#"/>
</cfquery>
