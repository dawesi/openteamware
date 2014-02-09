<!---

--->

<cfparam name="SelectOpenInvoiceRequest.entrykey" type="string" default="">


<cfquery name="q_select_open_invoice" datasource="#request.a_str_db_users#">
SELECT * FROM invoices
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectOpenInvoiceRequest.entrykey#">;
</cfquery>