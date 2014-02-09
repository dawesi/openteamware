



<cfparam name="SelectInvoicesRequest.companykey" type="string" default="">



<cfquery name="q_Select_open_invoices" datasource="#request.a_str_db_users#">
SELECT * FROM
	invoices
WHERE
	companykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SelectInvoicesRequest.companykey#">
AND
	paid = 0
;
</cfquery>