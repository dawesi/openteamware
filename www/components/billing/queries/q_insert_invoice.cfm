<!--- 



	insert a new invoice

	

	--->

<cfparam name="InsertInvoiceRequest.Entrykey" type="string" default="">
<cfparam name="InsertInvoiceRequest.companykey" type="string" default="">
<cfparam name="InsertInvoiceRequest.q_open_records" type="query">
<cfparam name="InsertInvoiceRequest.VATPercent" type="numeric" default="20">

<cfset a_str_booked_services = "">

<cfloop query="InsertInvoiceRequest.q_open_records">
	<cfset a_str_booked_services = a_str_booked_services & "," & InsertInvoiceRequest.q_open_records.entrykey>
</cfloop>

<cfset a_str_booked_services = Mid(a_str_booked_services, 2, len(a_str_booked_services))>

<cfquery name="q_select_totalsum" datasource="#request.a_str_db_users#">
SELECT
	SUM(totalamount) AS total_sum
FROM
	bookedservices
WHERE
	entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_booked_services#" list="yes">)
;
</cfquery>

<cfquery name="q_select_max_invoice_number" datasource="#request.a_str_db_users#">
SELECT
	MAX(internalinvoicenumber) AS max_invoicenumber
FROM
	invoices
WHERE
	invoiceyear = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#">
;
</cfquery>

<cfset a_int_invoice_number = val(q_select_max_invoice_number.max_invoicenumber) + 1>

<cfset a_str_invoice_number = year(now())&"-"&a_int_invoice_number>

<cfset a_dt_due = DateAdd('d', 15, Now())>

<cfquery name="q_insert_invoice" datasource="#request.a_str_db_users#">
INSERT INTO
	invoices
	(
	companykey,
	dt_created,
	dt_due,
	bookedservices,
	entrykey,
	paid,
	invoicenumber,
	invoiceyear,
	internalinvoicenumber,
	invoicevatpercent,
	invoicetotalsum,
	invoicetotalsum_gross,
	comment,
	invoicetype,
	createdbytype
	)
	VALUES
	(
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertInvoiceRequest.companykey#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDatetime(now())#">,
	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(a_dt_due)#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_booked_services#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#InsertInvoiceRequest.Entrykey#">,
	
	<cfif q_select_totalsum.total_sum IS 0>
	<!--- if the sum is zero, set automatically paid --->
	1,
	<cfelse>
	0,
	</cfif>

	<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_invoice_number#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#a_int_invoice_number#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertInvoiceRequest.VATPercent#">,
	<cfqueryparam cfsqltype="cf_sql_float" value="#q_select_totalsum.total_sum#">,
	<cfqueryparam cfsqltype="cf_sql_float" value="#(q_select_totalsum.total_sum + ((q_select_totalsum.total_sum / 100) * InsertInvoiceRequest.VATPercent))#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.invoicetype#">,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.createdbytype#">
	)
;
</cfquery>