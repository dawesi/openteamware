<!--- //

	calculate sales
	
	// --->
<h4>Already paid invoices only</h4>
	
<cfinclude template="queries/q_select_invoices.cfm">

<cfquery name="q_select_invoices" dbtype="query">
SELECT
	*
FROM
	q_select_invoices
WHERE
	paid = 1
;
</cfquery>

<cfquery name="q_select_avg_sum" dbtype="query">
SELECT
	AVG(invoicetotalsum) AS avg_invoicetotalsum
FROM
	q_select_invoices
;
</cfquery>

<h4>Durchschnittliche Rechnungssumme: <cfoutput>#DecimalFormat(q_select_avg_sum.avg_invoicetotalsum)#</cfoutput> &euro; netto</h4>

<!--- select top performers --->

<cfquery name="q_select_distinct_resellers" dbtype="query">
SELECT
	DISTINCT(resellerkey),0 AS companies_count,0 AS sum_sales,0 AS avg_sum
FROM
	q_select_invoices
;
</cfquery>

<cfoutput query="q_select_distinct_resellers">
	
	<cfquery name="q_select_count" dbtype="query">
	SELECT
		COUNT(resellerkey) AS count_invoices
	FROM
		q_select_invoices
	WHERE
		resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_resellers.resellerkey#">
	;
	</cfquery>
	
	<cfset QuerySetCell(q_select_distinct_resellers, 'companies_count', q_select_count.count_invoices, q_select_distinct_resellers.currentrow)>
	
	<cfquery name="q_select_sum" dbtype="query">
	SELECT
		SUM(invoicetotalsum) AS sum_totalsum
	FROM
		q_select_invoices
	WHERE
		resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_resellers.resellerkey#">
	;
	</cfquery>	
	
	<cfset QuerySetCell(q_select_distinct_resellers, 'sum_sales', q_select_sum.sum_totalsum, q_select_distinct_resellers.currentrow)>
	
	<cfquery name="q_select_avg_sum" dbtype="query">
	SELECT
		AVG(invoicetotalsum) AS avg_sum
	FROM
		q_select_invoices
	WHERE
		resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_resellers.resellerkey#">
	;
	</cfquery>	
	
	<cfset QuerySetCell(q_select_distinct_resellers, 'avg_sum', q_select_avg_sum.avg_sum, q_select_distinct_resellers.currentrow)>	
	
</cfoutput>

<cfquery name="q_select_distinct_resellers" dbtype="query">
SELECT
	*
FROM
	q_select_distinct_resellers
ORDER BY
	sum_sales DESC
;
</cfquery>

<cfdump var="#q_select_distinct_resellers#">

<table border="0" cellspacing="0" cellpadding="4">
  <tr class="mischeader">
    <td>Partner</td>
    <td>Summe</td>
    <td>Kunden</td>
    <td>Umsatz/Kunde</td>
  </tr>
  <cfoutput query="q_select_distinct_resellers">
  <tr>
    <td>
		<cfquery name="q_select_resellername" datasource="#request.a_str_db_users#">
		SELECT
			companyname
		FROM
			reseller
		WHERE
			entrykey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_resellers.resellerkey#">
		;
		</cfquery>
		
	#q_select_resellername.companyname#
	</td>
    <td align="right">
		#q_select_distinct_resellers.sum_sales#
	</td>
    <td align="right">
		#q_select_distinct_resellers.companies_count#
	</td>
    <td align="right">
		#q_select_distinct_resellers.avg_sum#
	</td>
  </tr>
  </cfoutput>
</table>