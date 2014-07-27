<!---

	extract the core html content
	
	--->
	
<cfquery name="q_select_billing_html_content" datasource="#request.a_str_db_users#">
SELECT
	htmlcontent
FROM
	invoices
WHERE
	entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.invoicekey#">
;
</cfquery>

<cfset a_str_html_content = q_select_billing_html_content.htmlcontent>


<cfset a_int_start_pos = FindNoCase('<!-- %INVOICE_TABLE_START% -->', a_str_html_content)>

<cfif a_int_start_pos GT 0>

	<cfset a_str_html_content = Mid(a_str_html_content, a_int_start_pos, Len(a_str_html_content))>
	
</cfif>

<cfset a_int_start_pos = FindNoCase('<!-- %INVOICE_TABLE_END% -->', a_str_html_content)>

<cfif a_int_start_pos GT 10>

	<cfset a_str_html_content = Mid(a_str_html_content, 1, a_int_start_pos-1)>
	
</cfif>

<cfset sReturn = a_str_html_content>