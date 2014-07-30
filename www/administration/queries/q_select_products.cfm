
<cfquery name="q_select_products">
SELECT entrykey,productname,dt_created,description,productgroupkey,itemindex,ongoing,unit FROM products;
</cfquery>