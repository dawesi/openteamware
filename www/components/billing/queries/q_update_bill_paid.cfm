<cfquery name="q_update_bill_paid" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	paid = 1,
	dt_paid = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#">,
	paymethod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.method#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoicekey#">
;
</cfquery>