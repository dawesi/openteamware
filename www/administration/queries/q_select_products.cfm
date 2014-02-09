
<cfquery name="q_select_products" datasource="#request.a_str_db_users#">
SELECT entrykey,productname,dt_created,description,productgroupkey,itemindex,ongoing,unit FROM products;
</cfquery>