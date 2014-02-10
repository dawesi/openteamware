<!--- //

	demographische statistik
	
	// --->

<cfset a_str_company_keys = ValueList(q_select_companies.entrykey)>

<cfif Len(a_str_company_keys) IS 0>
	<cfset a_str_company_keys = '123'>
</cfif>
	
<cfoutput query="q_select_companies">
	<!--- shorten ... length is provided by filter ... --->	
	<cfset querySetCell(q_select_companies, 'zipcode', Mid(q_select_companies.zipcode, 1, arguments.filter.zipcodelength), q_select_companies.currentrow)>
</cfoutput>

<cfset stReturn.q_select_companies = q_select_companies>

<cfquery name="q_select_distinct_zipcodes" dbtype="query">
SELECT
	DISTINCT(zipcode) AS zipcode,0 AS count_zipcode
FROM
	q_select_companies
;
</cfquery>

<cfoutput query="q_select_distinct_zipcodes">

		<cfquery name="q_select_count" dbtype="query">
		SELECT
			COUNT(id) AS count_id
		FROM
			q_select_companies
		WHERE
			zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_zipcodes.zipcode#">
		;
		</cfquery>
		
		<cfset QuerySetCell(q_select_distinct_zipcodes, 'count_zipcode', val(q_select_count.count_id), q_select_distinct_zipcodes.currentrow)>

</cfoutput>

<cfquery name="q_select_distinct_zipcodes" dbtype="query" maxrows="200">
SELECT
	*
FROM
	q_select_distinct_zipcodes
ORDER BY
	count_zipcode DESC
;
</cfquery>

<cfset stReturn.q_select_distinct_zipcodes = q_select_distinct_zipcodes>

<cfloop query="q_return">

	<cfset a_dt_start = q_return.date_start>
	<cfset a_dt_end = q_return.date_end>
	<cfset a_int_currentrow = q_return.currentrow>

	<cfloop query="q_select_distinct_zipcodes">
	
		<cfquery name="q_select_count" dbtype="query">
		SELECT
			COUNT(id) AS count_id
		FROM
			q_select_companies
		WHERE
			dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_end#">
			AND
			zipcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_zipcodes.zipcode#">
		;
		</cfquery>
		
		<cfset QuerySetCell(q_return, 'data'&q_select_distinct_zipcodes.currentrow, Val(q_select_count.count_id), a_int_currentrow)>

	</cfloop>
	

</cfloop>