<cfquery name="q_update_creation_date_of_first_dunning_letter" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	dt_dunning1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CreateODBCDateTime(arguments.dt)#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoicekey#">
;
</cfquery>