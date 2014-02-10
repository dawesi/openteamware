<cfset a_str_company_keys = ValueList(q_select_companies.entrykey)>

<cfif Len(a_str_company_keys) IS 0>
	<cfset a_str_company_keys = '123'>
</cfif>

<cfloop query="q_return">

	<!--- data1: umsatz bezahlt --->
	
	<!--- data2: umsatz in rechnung gestellt --->
	
	<!--- data3: neu --->
	
	<!--- data4: verlaengerungen --->
	
	<!--- data5: durchschnittl. umsatz --->
	
	<!--- data6: anzahl der rechnungen --->
	
	

	<cfquery name="q_select_sales_paid" datasource="#request.a_str_db_users#">
	SELECT
		SUM(invoicetotalsum) AS sum_invoicetotalsum
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		paid = 1
		AND
		cancelled = 0
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)
	;
	</cfquery>	
	<cfset tmp = QuerySetCell(q_return, 'data1', val(q_select_sales_paid.sum_invoicetotalsum), q_return.currentrow)>
	
	<cfquery name="q_select_sales_total" datasource="#request.a_str_db_users#">
	SELECT
		SUM(invoicetotalsum) AS sum_invoicetotalsum
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)		
	;
	</cfquery>	
	<cfset tmp = QuerySetCell(q_return, 'data2', val(q_select_sales_total.sum_invoicetotalsum), q_return.currentrow)>
	
	<cfquery name="q_select_sales_new" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(id) AS count_new
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		invoicetype = 0
		AND
		cancelled = 0
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)		
	;
	</cfquery>	
	<cfset tmp = QuerySetCell(q_return, 'data3', val(q_select_sales_new.count_new), q_return.currentrow)>
	
	<cfquery name="q_select_sales_renew" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(id) AS count_renew
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		invoicetype = 1
		AND
		cancelled = 0
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)		
	;
	</cfquery>	
	<cfset tmp = QuerySetCell(q_return, 'data4', val(q_select_sales_renew.count_renew), q_return.currentrow)>	
	
	<cfquery name="q_select_invoice_avg_sum" datasource="#request.a_str_db_users#">
	SELECT
		AVG(invoicetotalsum) AS avg_sum
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		cancelled = 0
		AND
		paid = 1
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)		
	;
	</cfquery>	
	<cfset tmp = QuerySetCell(q_return, 'data5', val(q_select_invoice_avg_sum.avg_sum), q_return.currentrow)>		
	
	<cfquery name="q_select_invoices_count" datasource="#request.a_str_db_users#">
	SELECT
		COUNT(id) AS count_invoices
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)		
	;
	</cfquery>	
	<cfset tmp = QuerySetCell(q_return, 'data6', Val(q_select_invoices_count.count_invoices), q_return.currentrow)>		
	
	<cfquery name="q_select_unpaid_invoices_sum" datasource="#request.a_str_db_users#">
	SELECT
		SUM(invoicetotalsum) AS sum_invoices
	FROM
		invoices
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		AND
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_company_keys#" list="yes">)
		AND
		paid = 0
		AND
			(
				(dunninglevel = 2)
				OR
				(cancelled = 1)
			)
	;
	</cfquery>	
	
	<cfset a_int_one_perc = Val(q_select_sales_total.sum_invoicetotalsum) / 100>
	
	<cfset a_int_share_not_paid = 0>
	
	<cftry>
	<cfset a_int_share_not_paid = q_select_unpaid_invoices_sum.sum_invoices / a_int_one_perc>
	<cfcatch type="any"> </cfcatch></cftry>
	
	<cfset tmp = QuerySetCell(q_return, 'data7', DecimalFormat(a_int_share_not_paid), q_return.currentrow)>		
	
</cfloop>