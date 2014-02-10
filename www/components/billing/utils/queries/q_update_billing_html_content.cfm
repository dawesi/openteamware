<cfquery name="q_update_billing_html_content" datasource="#request.a_str_db_users#">
UPDATE
	invoices
SET
	htmlcontent = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a_str_content#">
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoicekey#">
;
</cfquery>