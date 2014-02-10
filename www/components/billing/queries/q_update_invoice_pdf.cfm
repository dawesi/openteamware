<!---


	--->
	
<cfquery name="q_update_invoice_pdf" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	pdffile = '#tobase64(a_str_data)#'
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.entrykey#">
;
</cfquery>