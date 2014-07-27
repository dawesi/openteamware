<cfquery name="q_update_dt_due" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	dt_due = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateODBCDateTime(arguments.dt_due)#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoicekey#">
;
</cfquery>