<!--- create referer stat --->

<!--- select distinct referers ... --->

<cfoutput query="q_select_companies">
	<cfif FindNoCase('homepage_', q_select_companies.signupsource) GT 0>
		<cfset tmp = QuerySetCell(q_select_companies, 'signupsource', 'homepage', q_select_companies.currentrow)>
	</cfif>
	
	<cfif FindNoCase('google', q_select_companies.signupsource) GT 0>
		<cfset tmp = QuerySetCell(q_select_companies, 'signupsource', 'google', q_select_companies.currentrow)>
	</cfif>	

	<cfif FindNoCase('google', q_select_companies.httpreferer) GT 0>
		<cfset tmp = QuerySetCell(q_select_companies, 'signupsource', 'google', q_select_companies.currentrow)>

		<cfelseif Len(q_select_companies.httpreferer) GT 0>
			<cfset tmp = QuerySetCell(q_select_companies, 'signupsource', 'weblink', q_select_companies.currentrow)>
	</cfif>	
	
	<cfif Len(q_select_companies.createdbyuserkey) GT 0>
		<cfset tmp = QuerySetCell(q_select_companies, 'signupsource', 'sales/partner', q_select_companies.currentrow)> 
	</cfif>
</cfoutput>

<cfquery name="q_select_distinct_signupsources" dbtype="query">
SELECT
	DISTINCT(signupsource),0 AS index
FROM
	q_select_companies
WHERE
	<!---createdbyuserkey = ''
	AND--->
	dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date_end#">
;
</cfquery>

<!--- check google item ... --->
<cfquery name="q_select_google_item_exists" dbtype="query">
SELECT
	COUNT(index) AS count_index
FROM
	q_select_distinct_signupsources
WHERE
	signupsource = 'google_adwords'
;
</cfquery>

<cfif q_select_google_item_exists.recordcount IS 0>
	<cfset tmp = QueryAddRow(q_select_distinct_signupsources, 1)>
	<cfset tmp = QuerySetCell(q_select_distinct_signupsources, 'signupsource', 'google', 1)>
</cfif>

<cfoutput query="q_select_companies">



</cfoutput>


<cfset stReturn.q_select_distinct_signupsources = q_select_distinct_signupsources>

<cfset a_struct_sources = StructNew()>
<cfset a_struct_columnnames = StructNew()>

<cfloop query="q_select_distinct_signupsources">
	<cfset a_struct_sources[q_select_distinct_signupsources.signupsource] = 0>
</cfloop>

<cfloop query="q_return">

	<!--- check ... --->
	<cfset a_dt_start = q_return.date_start>
	<cfset a_dt_end = q_return.date_end>
	<cfset a_int_currentrow = q_return.currentrow>
	
	<!--- created by reseller --->
	<cfquery name="q_select_created_by_reseller_count" dbtype="query">
	SELECT
		COUNT(id) AS count_source
	FROM
		q_select_companies
	WHERE
		NOT createdbyuserkey = ''
	AND
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	;
	</cfquery>	
	
	<cfset QuerySetCell(q_return, 'data1', val(q_select_created_by_reseller_count.count_source), q_return.currentrow)>
	
	<cfquery name="q_select_created_by_user" dbtype="query">
	SELECT
		COUNT(id) AS count_source
	FROM
		q_select_companies
	WHERE
		createdbyuserkey = ''
	AND
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	;
	</cfquery>	
	
	<cfset QuerySetCell(q_return, 'data2', val(q_select_created_by_user.count_source), q_return.currentrow)>	
	
	<!--- start with 2 ... the first col is the createdbyuserkey number and the second free floating --->
	<cfset a_int_index = 2>
	
	<cfloop query="q_select_distinct_signupsources">
	
		<cfset a_int_index = a_int_index + 1>
	
		<!---<cfset a_str_source = a_arr_list_sources[ii]>--->
		<cfset a_str_source = q_select_distinct_signupsources.signupsource>
		
		<!---<cfset a_int_index = a_int_index + 1>--->
		
		<!---<cfset a_arr_list_sources[ii] = a_int_index>--->
		<!---<cfset QuerySetCell(q_select_distinct_signupsources, 'index', a_int_index, ListFind(a_Str_list_sources, a_str_source))>--->
		
		<cfquery name="q_select_count_signupsource" dbtype="query">
		SELECT
			COUNT(id) AS count_source
		FROM
			q_select_companies
		WHERE
			signupsource = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_source#">
			<!---AND
			createdbyuserkey = ''--->
			AND
			dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_end#">
		;
		</cfquery>
		
		<cfset a_str_uuid = a_dt_start & '_' & a_str_source>
		
		<!---<cfset stReturn[a_str_uuid]['query'] = q_select_count_signupsource>
		<cfset stReturn[a_str_uuid]['start'] = a_dt_start>
		<cfset stReturn[a_str_uuid]['end'] = a_dt_end>		
		<cfset stReturn[a_str_uuid]['signupsource'] = a_str_source>--->
		
		<cfset QuerySetCell(q_return, 'data'&a_int_index, val(q_select_count_signupsource.count_source), a_int_currentrow)>
		
		<cfset a_struct_columnnames['data'&a_int_index] = a_str_source>
		
		
	
	</cfloop>

</cfloop>

<cfset stReturn.q_select_distinct_signupsources = q_select_distinct_signupsources>
<!---<cfset stReturn.q_select_companies = q_select_companies>--->
<cfset stReturn.a_struct_sources = a_struct_sources>
<cfset stReturn.a_struct_columnnames = a_struct_columnnames>