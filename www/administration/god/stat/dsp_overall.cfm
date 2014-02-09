<!--- --->

<h4>Kundenentwicklung</h4>

<cfset q_stat = QueryNew('yearweek,customers,trialcustomers,sales,percentpaid,yearweekint,dt_sort')>

<cfquery name="q_select_customers" datasource="#request.a_str_db_users#">
SELECT
	dt_created AS dt_created_original,status,entrykey,disabled,
	DATE_FORMAT(dt_created, '%Y%m%d') AS dt_created
FROM
	companies
WHERE
	companyname NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%vorname%">
;
</cfquery>

<!--- add customers where the trial phase has expired --->
<cfquery name="q_select_old_companies" datasource="#request.a_str_db_users#">
SELECT
	dt_created AS dt_created_original,status,entrykey,disabled,
	DATE_FORMAT(dt_created, '%Y%m%d') AS dt_created
FROM
	oldcompanies
WHERE
	companyname NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%vorname%">
;
</cfquery>

<cfloop query="q_select_old_companies">
	<cfset tmp = QueryAddRow(q_select_customers, 1)>
	
	<cfloop list="#q_select_customers.columnlist#" index="a_str_column" delimiters=",">
		<cfset tmp = QuerySetCell(q_select_customers, a_str_column, q_select_customers[a_str_column][q_select_old_companies.currentrow], q_select_customers.recordcount)>
	</cfloop>
</cfloop>


<!--- display in weeks .... 3 monts --->
<cfloop from="0" to="20" index="ii">
	<cfset a_dt = DateAdd('ww', -#ii#, Now())>
	
	<cfset a_int_week = week(a_dt)>
	
	<cfset a_int_customers = 0>
	<cfset a_int_customers_interested = 0>
	<cfset a_str_customers_entrykeys = ''>
	
	<cfloop query="q_select_customers">
		<cfif (q_select_customers.status IS 0) AND (q_select_customers.disabled IS 0) AND (Week(q_select_customers.dt_created_original) IS a_int_week)>
			<cfset a_int_customers = a_int_customers + 1>
			
			<cfset a_str_customers_entrykeys = ListPrepend(a_str_customers_entrykeys, q_select_customers.entrykey)>
		</cfif>
	</cfloop>
		
	<cfloop query="q_select_customers">
		<cfif 
			(
				(q_select_customers.status IS 1) 
				OR
				(
					(q_select_customers.status IS 0)
					AND
					(q_select_customers.disabled IS 1)
				)
			)
		
			AND (Week(q_select_customers.dt_created_original) IS a_int_week)>
			<cfset a_int_customers_interested = a_int_customers_interested + 1>
		</cfif>
	</cfloop>
	
	<cfset a_int_total_customers = a_int_customers + a_int_customers_interested>
	<cfset a_int_one_perc = a_int_total_customers / 100>	
	
	<cfif Len(a_str_customers_entrykeys) IS 0>
		<cfset a_str_customers_entrykeys = '!23'>
	</cfif>
	
	<!--- sales --->
	<cfquery name="q_select_sales" datasource="#request.a_str_db_users#">
	SELECT
		sum(invoicetotalsum) AS sum_total
	FROM
		invoices
	WHERE
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_customers_entrykeys#" list="yes">)
		AND
		paid = 1
		AND
		invoicetotalsum > 0
	;
	</cfquery>
		
	<!---<cfoutput>#a_dt#</cfoutput><br>--->
	
	<cfset tmp = Queryaddrow(q_stat, 1)>
	<cfset QuerySetCell(q_stat, 'dt_sort', a_dt, q_stat.recordcount)>
	<cfset tmp=QuerySetCell(q_stat, 'yearweek', year(a_dt)&'-'&week(a_dt), q_stat.recordcount)>
	<cfset tmp=QuerySetCell(q_stat, 'yearweekint', year(a_dt)&week(a_dt), q_stat.recordcount)>
	<cfset QuerySetCell(q_stat, 'customers', a_int_customers, q_stat.recordcount)>
	<cfset QuerySetCell(q_stat, 'trialcustomers', a_int_customers_interested, q_stat.recordcount)>
	<cfset QuerySetCell(q_stat, 'sales', ReplaceNoCase(DecimalFormat(q_select_sales.sum_total), ',', '', 'ALL'), q_stat.recordcount)>
	<cfif a_int_one_perc GT 0>
		<cfset QuerySetCell(q_stat, 'percentpaid', DecimalFormat(a_int_customers/a_int_one_perc), q_stat.recordcount)>
	<cfelse>
		<cfset QuerySetCell(q_stat, 'percentpaid', 0, q_stat.recordcount)>
	</cfif>
</cfloop>

<cfquery name="q_stat" dbtype="query">
SELECT
	*
FROM
	q_stat
ORDER BY
	dt_sort
;
</cfquery>

<h4>Paid Konten vs. Trialkonten</h4>
<cfchart format="png" chartwidth="600">
	<cfchartseries query="q_stat" itemcolumn="yearweek" valuecolumn="customers" type="line" seriescolor="##CC0000" serieslabel="Zahlende Kunden">
	<cfchartseries query="q_stat" itemcolumn="yearweek" valuecolumn="trialcustomers" type="line" seriescolor="##3300FF" serieslabel="Testkunden">	
</cfchart>

<h4>% Paid Konten</h4>
<cfchart format="png" chartwidth="600">
	<cfchartseries query="q_stat" itemcolumn="yearweek" valuecolumn="percentpaid" type="line" seriescolor="##CC0000" serieslabel="Zahlende Kunden">
</cfchart>

<h4>Umsatzentwicklung</h4>
<cfchart format="png" chartwidth="600">
	<cfchartseries query="q_stat" itemcolumn="yearweek" valuecolumn="sales" type="line" seriescolor="##336699" serieslabel="Zahlende Kunden">
</cfchart>
<h4>Rohdaten</h4>
<table border="0" cellspacing="1" cellpadding="2" bgcolor="silver">
  <tr bgcolor="#EEEEEE">
    <td>Woche/Jahr</td>
    <td>Bez. Kunden</td>
    <td>Trialkunden</td>
    <td>Abschlu&szlig;quote</td>
    <td>Umsatz</td>
  </tr>
  <cfoutput query="q_stat">
  <tr>
    <td align="right" bgcolor="white">#q_stat.yearweek#</td>
    <td align="right" bgcolor="white">#q_stat.customers#</td>
    <td align="right" bgcolor="white">#q_stat.trialcustomers#</td>
    <td align="right" bgcolor="white">#q_stat.percentpaid#</td>
    <td align="right" bgcolor="white">#q_stat.sales#</td>
  </tr>
  </cfoutput>
</table>