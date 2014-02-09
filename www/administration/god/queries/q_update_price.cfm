<cfquery name="q_update_price" datasource="#request.a_str_db_users#">
UPDATE prices
SET price1 = <cfqueryparam cfsqltype="cf_sql_float" value="#form.frmprice#">,
quantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmquantity#">
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmpricekey#">;
</cfquery>