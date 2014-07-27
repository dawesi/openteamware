<!--- //

	demographische statistik
	
	// --->

<cfset a_str_company_keys = ValueList(q_select_companies.entrykey)>

<cfif Len(a_str_company_keys) IS 0>
	<cfset a_str_company_keys = '123'>
</cfif>
	
<!--- country ... 1 - 10 --->

<cfquery name="q_select_distinct_countries" dbtype="query">
SELECT
	DISTINCT(countryisocode),0 AS count_country
FROM
	q_select_companies
;
</cfquery>

<cfoutput query="q_select_distinct_countries">

		<cfquery name="q_select_count" dbtype="query">
		SELECT
			COUNT(id) AS count_id
		FROM
			q_select_companies
		WHERE
			countryisocode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_countries.countryisocode#">
		;
		</cfquery>
		
		<cfset QuerySetCell(q_select_distinct_countries, 'count_country', val(q_select_count.count_id), q_select_distinct_countries.currentrow)>

</cfoutput>

<!--- select only countries with at leat 5 customers --->
<cfquery name="q_select_distinct_countries" dbtype="query">
SELECT
	*
FROM
	q_select_distinct_countries
WHERE
	count_country >= 5
;
</cfquery>

<cfloop query="q_return">

	<cfset a_dt_start = q_return.date_start>
	<cfset a_dt_end = q_return.date_end>
	<cfset a_int_currentrow = q_return.currentrow>

	<cfloop query="q_select_distinct_countries">
	
		<cfquery name="q_select_count" dbtype="query">
		SELECT
			COUNT(id) AS count_id
		FROM
			q_select_companies
		WHERE
			dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_end#">
			AND
			countryisocode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_countries.countryisocode#">
		;
		</cfquery>
		
		<cfset QuerySetCell(q_return, 'data'&q_select_distinct_countries.currentrow, Val(q_select_count.count_id), a_int_currentrow)>
			
		
	</cfloop>
	

</cfloop>

<cfset stReturn.q_select_distinct_countries = q_select_distinct_countries>

<!--- zipcode --->


