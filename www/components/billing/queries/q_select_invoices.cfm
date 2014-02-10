<cfquery name="q_select_invoices" datasource="#request.a_str_db_users#">
SELECT
	companykey,dt_created,bookedservices,entrykey,paid,invoicenumber,invoiceyear,
	internalinvoicenumber,invoicevatpercent,invoicetotalsum,comment,invoicetotalsum_gross,
	dunninglevel,cancelled
FROM
	invoices
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companykey#">

<cfif arguments.type GTE 0>
	AND paid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.type#">
</cfif>

;
</cfquery>