<cfparam name="attributes.includetrialcustomers" type="boolean" default="true">

<cfquery name="q_select_countries" datasource="#request.a_str_db_users#">
SELECT
	countryisocode
FROM
	companies
<cfif attributes.includetrialcustomers IS FALSE>
WHERE
	status = 0
</cfif>
;
</cfquery>

<cfif attributes.includetrialcustomers>
<cfquery name="q_select_old_companies" datasource="#request.a_str_db_users#">
SELECT
	countryisocode
FROM
	oldcompanies
;
</cfquery>

<cfloop query="q_select_old_companies">
	<cfset QueryAddRow(q_select_countries, 1)>
	
	<cfloop list="#q_select_old_companies.columnlist#" index="a_str_column" delimiters=",">
		<cfset QuerySetCell(q_select_countries, a_str_column, q_select_old_companies[a_str_column][q_select_old_companies.currentrow], q_select_countries.recordcount)>
	</cfloop>
</cfloop>

</cfif>

<cfquery name="q_select_distinct_countries" dbtype="query">
SELECT
	DISTINCT(countryisocode),0 AS count_country
FROM
	q_select_countries
;
</cfquery>


<cfoutput query="q_select_distinct_countries">
	<cfquery name="q_select_country_count" dbtype="query">
	SELECT
		COUNT(countryisocode) AS count_country
	FROM
		q_select_countries
	WHERE
		countryisocode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_countries.countryisocode#">
	;
	</cfquery>
	
	<cfset querysetcell(q_select_distinct_countries, 'count_country', q_select_country_count.count_country, q_select_distinct_countries.currentrow)>
</cfoutput>

<cfquery name="q_select_distinct_countries" dbtype="query">
SELECT
	*
FROM
	q_select_distinct_countries
WHERE
	count_country > 5
ORDER BY
	count_country DESC
;
</cfquery>

<cfsavecontent variable="graph_data">
<cfchart showlegend="yes">
	<cfchartseries query="q_select_distinct_countries" type="pie" valuecolumn="count_country" itemcolumn="countryisocode">
</cfchart>
</cfsavecontent>
<cfset graph_data = Replace(graph_data,"http://","https://")>
<cfoutput>#graph_data#</cfoutput>