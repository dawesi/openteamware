<!--- //

	select an invoice ...
	
	// --->
	
<cfparam name="SelectInvoiceRequest.entrykey" type="string" default="">

<cfquery name="q_select_invoice" datasource="#request.a_str_db_users#">
SELECT invoicenumber,companykey,resellerkey,dt_created,bookedservices,entrykey FROM invoices
WHERE entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectInvoiceRequest.entrykey#">;
</cfquery>