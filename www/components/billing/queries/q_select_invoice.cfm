

<cfquery name="q_select_invoice" datasource="#request.a_str_db_users#">
SELECT
	companykey,dt_created,bookedservices,entrykey,paid,invoicenumber,invoiceyear,
	internalinvoicenumber,invoicevatpercent,invoicetotalsum,comment,invoicetotalsum_gross,
	dt_due,dt_dunning1,dt_dunning2,dunninglevel,htmlcontent
FROM
	invoices
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>