

<cfquery name="q_update_price">
INSERT INTO prices
(entrykey,price1,quantity,productkey)
VALUES
(<cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateUUID()#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmprice#">,
<cfqueryparam cfsqltype="cf_sql_integer" value="#form.frmquantity#">,
<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.frmproductkey#">);
</cfquery>