<cfparam name="attributes.resellerkey" type="string" default="">


<cfquery name="q_select_companies">
SELECT
	DATE_FORMAT(dt_created, '%Y%m%d') AS dt_created_int,dt_created,
	entrykey,companyname,resellerkey,id,status
FROM
	companies
ORDER BY
	dt_created_int
;
</cfquery>

<!--- add customers where the trial phase has expired --->
<cfquery name="q_select_old_companies">
SELECT
	dt_created,entrykey,companyname,resellerkey,id,status,zipcode,createdbyuserkey,
	DATE_FORMAT(dt_created, '%Y%m%d') AS dt_created_int
FROM
	oldcompanies
;
</cfquery>

<cfloop query="q_select_old_companies">
	<cfset QueryAddRow(q_select_companies, 1)>
	
	<cfloop list="#q_select_companies.columnlist#" index="a_str_column" delimiters=",">
		<cfset QuerySetCell(q_select_companies, a_str_column, q_select_companies[a_str_column][q_select_old_companies.currentrow], q_select_companies.recordcount)>
	</cfloop>
</cfloop>

<cfquery name="q_select_companies" dbtype="query">
SELECT
	*
FROM
	q_select_companies
ORDER BY
	dt_created_int DESC
;
</cfquery>

<cfquery name="q_select_distinct_days" dbtype="query">
SELECT
	DISTINCT(dt_created_int),0 AS count_companies,0 AS paying_companies
FROM
	q_select_companies
;
</cfquery>

<cfloop query="q_select_distinct_days">

	<cfquery name="q_select_day_count" dbtype="query">
	SELECT
		COUNT(entrykey) AS count_companies
	FROM
		q_select_companies
	WHERE
		dt_created_int = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_days.dt_created_int#">
	;
	</cfquery>
	
	<cfoutput>#q_select_distinct_days.dt_created_int#</cfoutput>
	<cfquery name="q_s">
	SELECT
		companyname,customerid
	FROM
		companies
	WHERE
		DATE_FORMAT(dt_created, '%Y%m%d') = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_days.dt_created_int#">
	;
	</cfquery>	
	
	<cfdump var="#q_s#">
	
	<cfset querySetCell(q_select_distinct_days, 'count_companies', val(q_select_day_count.count_companies), q_select_distinct_days.currentrow)>
	
	<cfquery name="q_select_day_count_paid" dbtype="query">
	SELECT
		COUNT(entrykey) AS count_companies
	FROM
		q_select_companies
	WHERE
		dt_created_int = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_days.dt_created_int#">
		AND
		status = 0
	;
	</cfquery>
	
	<cfset querySetCell(q_select_distinct_days, 'paying_companies', val(q_select_day_count_paid.count_companies), q_select_distinct_days.currentrow)>

</cfloop>


<cfquery name="q_select_distinct_days" dbtype="query">
SELECT
	*
FROM
	q_select_distinct_days
ORDER BY
	dt_created_int DESC
;
</cfquery>

<cfquery name="q_select_max_companies" dbtype="query">
SELECT
	MAX(count_companies) AS max_companies
FROM
	q_select_distinct_days
;
</cfquery>

<cfset a_one_perc = q_select_max_companies.max_companies / 100>

<h4>Anmeldungen ...</h4>
green = paid; silver = total
<table border="0" cellspacing="0" cellpadding="3">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <cfoutput query="q_select_distinct_days">
  <tr>
    <td>
		#Insert('.', Insert('.', q_select_distinct_days.dt_created_int, 4), 7)#

	</td>
    <td align="right">
		#q_select_distinct_days.paying_companies#
	</td>
	<td>
		<span style="background-color:green;height:3px;width:#(q_select_distinct_days.paying_companies*15)#"><img src="/images/space_1_1.gif"></span>
	</td>
  </tr>
  <tr>
  	<td class="bb">&nbsp;</td>
	<td align="right" class="bb">
		#q_select_distinct_days.count_companies#
	</td>
	<td class="bb">
		<span style="background-color:silver;height:3px;width:#(q_select_distinct_days.count_companies*15)#"><img src="/images/space_1_1.gif"></span>
	</td>
  </tr>
  </cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>


<cfabort>

<cfquery name="q_select_companies">
SELECT
	dt_created,entrykey,companyname,resellerkey,id,status
FROM
	companies
;
</cfquery>

<cfquery name="q_select_accounts">
SELECT
	companykey
FROM
	users
;	
</cfquery>

<cfquery name="q_select_first_day" dbtype="query">
SELECT
	MIN(q_select_companies.dt_created) AS dt_min
FROM
	q_select_companies
;
</cfquery>

<cfset q_stat = QueryNew('theday,companies,paid,accounts,percentpaid')>
<cfset q_stat_weeks = QueryNew('theweek,companies,paid,accounts,percentpaid')>

<cfset a_int_diff = DateDiff('d', q_select_first_day.dt_min, Now())>

<!---
<table border="0" cellspacing="0" cellpadding="4">
--->


<cfloop from="1" to="#a_int_diff#" index="ii">
	
	<cfset a_dt_begin = DateAdd('d', -ii-1, Now())>
	<cfset a_dt_begin = CreateDateTime(Year(a_dt_begin), Month(a_dt_begin), Day(a_dt_begin), 0, 0, 0)>
	<cfset a_dt_end = CreateDateTime(Year(a_dt_begin), Month(a_dt_begin), Day(a_dt_begin), 23, 59, 59)>
	
	
	<cfquery name="q_select_companies_this_day" dbtype="query">
	SELECT
		entrykey
	FROM
		q_select_companies
	WHERE
		q_select_companies.dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_begin#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_end#">
	;
	</cfquery>
	
	<cfset a_str_list = valueList(q_select_companies_this_day.entrykey)>
	<cfif Len(a_str_list) IS 0>
		<cfset a_str_list = '123'>
	</cfif>
	
	<cfquery name="q_select_paid_this_day" dbtype="query">
	SELECT
		status
	FROM
		q_select_companies
	WHERE
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_list#" list="yes">)
		AND
		status = 0
	;
	</cfquery>	
	
	<cfquery name="q_select_accounts_this_day" dbtype="query">
	SELECT
		companykey
	FROM
		q_select_accounts
	WHERE
		companykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_list#" list="yes">)
	;
	</cfquery>
	
	<cfset QueryAddRow(q_stat, 1)>
	<cfset QuerySetCell(q_stat, 'theday', DateFormat(a_dt_begin, 'yyyymmdd'), q_stat.recordcount)>
	<cfset QuerySetCell(q_stat, 'companies', q_select_companies_this_day.recordcount, q_stat.recordcount)>
	<cfset QuerySetCell(q_stat, 'accounts', q_select_accounts_this_day.recordcount, q_stat.recordcount)>
	<cfset QuerySetCell(q_stat, 'paid', q_select_paid_this_day.recordcount, q_stat.recordcount)>
	
	<cfif q_select_paid_this_day.recordcount IS 0>
		<cfset QuerySetCell(q_stat, 'percentpaid',0, q_stat.recordcount)>
	<cfelse>
		<cfset a_int_percent = q_select_paid_this_day.recordcount / (q_select_companies_this_day.recordcount / 100)>
		<cfset QuerySetCell(q_stat, 'percentpaid', DecimalFormat(a_int_percent), q_stat.recordcount)>
	</cfif>
	
	<!---<cfoutput>
  
  <tr>
    <td>
		#DateFormat(DateAdd('d', -ii-1, Now()), 'dd.mm.yy')#
	</td>
    <td align="right">
		#q_select_companies_this_day.recordcount#
	</td>
	<td>
		<img src="/images/bar_small.gif" width="#(q_select_companies_this_day.recordcount * 3)#" height="5">
	</td>
  </tr>
  <tr>
  	<td></td>
    <td align="right">
		#q_select_accounts_this_day.recordcount#
	</td>
    <td>&nbsp;</td>
  </tr>
  </cfoutput>--->
</cfloop>
<!---</table>--->

<h4>Anmeldestarke Tage</h4>

<cfquery name="q_select_subscr_high" dbtype="query" maxrows="10">
SELECT
	*
FROM
	q_stat
ORDER BY
	companies DESC
;
</cfquery>

<cfdump var="#q_select_subscr_high#">

<cfquery name="q_select_paid_rate" dbtype="query">
SELECT
	AVG(percentpaid)
FROM
	q_stat
;
</cfquery>
<h4>Durchschnitl. Abschlussrate: <cfoutput>#DEcimalFormat(q_select_paid_rate.column_0)#</cfoutput></h4>



<cfquery name="q_select_testcustomers_rate" dbtype="query">
SELECT
	AVG(companies)
FROM
	q_stat
;
</cfquery>

<cfquery name="q_stat" dbtype="query">
SELECT
	*
FROM
	q_stat
ORDER BY
	theday
;
</cfquery>


<h4>Test-Neukunden pro Tag: <cfoutput>#q_select_testcustomers_rate.column_0#</cfoutput></h4>

<!--- create monthly summary --->
<cfset a_int_diff = DateDiff('w', q_select_first_day.dt_min, Now())>

<cfloop from="1" to="#a_int_diff#" index="ii">
	
	<cfset a_dt_begin = DateAdd('ww', -ii-1, Now())>
	
	<cfset a_dt_begin = CreateDateTime(Year(a_dt_begin), Month(a_dt_begin), Day(a_dt_begin), 0, 0, 0)>
	<cfset a_dt_end = DateAdd('n', -1, DateAdd('ww', 1, a_dt_begin))>

	
	<cfquery name="q_select_companies_week" dbtype="query">
	SELECT
		SUM(companies) AS sum_companies
	FROM
		q_stat
	WHERE
		theday BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(a_dt_begin, 'yyyymmdd')#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(a_dt_end, 'yyyymmdd')#">
	;
	</cfquery>
	
	<cfquery name="q_select_accounts_week" dbtype="query">
	SELECT
		SUM(accounts) AS sum_accounts
	FROM
		q_stat
	WHERE
		theday BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(a_dt_begin, 'yyyymmdd')#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(a_dt_end, 'yyyymmdd')#">
	;
	</cfquery>
	
	<cfquery name="q_select_paid_week" dbtype="query">
	SELECT
		SUM(paid) AS sum_paid
	FROM
		q_stat
	WHERE
		theday BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(a_dt_begin, 'yyyymmdd')#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#DateFormat(a_dt_end, 'yyyymmdd')#">
	;
	</cfquery>		
	
	
	<cfif Len(week(a_dt_begin)) IS 1>
		<cfset a_int_weekno = '0'&week(a_dt_begin)>
	<cfelse>
		<cfset a_int_weekno = Week(a_dt_begin)>
	</cfif>
	
	<cfset QueryAddRow(q_stat_weeks, 1)>
	<cfset QuerySetCell(q_stat_weeks, 'theweek', DateFormat(a_dt_begin, 'yy')&a_int_weekno, q_stat_weeks.recordcount)>
	<cfset QuerySetCell(q_stat_weeks, 'companies', q_select_companies_week.sum_companies, q_stat_weeks.recordcount)>	
	<cfset QuerySetCell(q_stat_weeks, 'accounts', q_select_accounts_week.sum_accounts, q_stat_weeks.recordcount)>
	<cfset QuerySetCell(q_stat_weeks, 'paid', q_select_paid_week.sum_paid, q_stat_weeks.recordcount)>
	
	<cfif q_select_companies_week.sum_companies IS 0>
		<cfset QuerySetCell(q_stat_weeks, 'percentpaid', 0, q_stat_weeks.recordcount)>
	<cfelse>
		<cfset a_int_percent = q_select_paid_week.sum_paid / (q_select_companies_week.sum_companies / 100)>
		<cfset QuerySetCell(q_stat_weeks, 'percentpaid', DecimalFormat(a_int_percent), q_stat_weeks.recordcount)>
	</cfif>	

</cfloop>

<cfchart>
	<cfchartseries type="area" query="q_stat_weeks" itemcolumn="theweek" valuecolumn="companies" serieslabel="Neu(Test)Kunden">
	<!---<cfchartseries type="area" query="q_stat_weeks" itemcolumn="theweek" valuecolumn="accounts" serieslabel="Konten">	--->
</cfchart>

<cfdump var="#q_stat_weeks#">

<!---<cfdump var="#q_stat#">--->