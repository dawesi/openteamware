<!--- generate the 100 top referer ... --->

<cfset q_tmp_referer = QueryNew('http_referer,referer_count')>

<cfquery name="q_select_distinct_http_referer" datasource="#request.a_str_db_log#">
SELECT
	DISTINCT(LEFT(referer, 50)) AS http_referer
FROM
	refererdata
;
</cfquery>

<cfloop query="q_select_distinct_http_referer">
	<cfset QueryAddRow(q_tmp_referer, 1)>
	<cfset QuerySetCell(q_tmp_referer, 'http_referer', q_select_distinct_http_referer.http_referer, q_tmp_referer.recordcount)>
		
	<cfquery name="q_count_ref" datasource="#request.a_str_db_log#">
	SELECT
		COUNT(id) AS count_id
	FROM
		refererdata
	WHERE
		LEFT(referer, 50) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_distinct_http_referer.http_referer#">
	;
	</cfquery>
	
	<cfset QuerySetCell(q_tmp_referer,'referer_count', val(q_count_ref.count_id), q_tmp_referer.recordcount)>
</cfloop>

<cfquery name="q_tmp_referer" dbtype="query">
SELECT
	*
FROM
	q_tmp_referer
ORDER BY
	referer_count DESC
;
</cfquery>

<cfloop query="q_return">

	<cfloop query="q_tmp_referer" startrow="1" endrow="10">

		<cfquery name="q_count_ref" datasource="#request.a_str_db_log#">
		SELECT
			COUNT(id) AS count_id
		FROM
			refererdata
		WHERE
			LEFT(referer, 50) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_tmp_referer.http_referer#">
			AND
			dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
		;
		</cfquery>
		
		<cfset tmp = QuerySetCell(q_return, 'data'&q_tmp_referer.currentrow, val(q_count_ref.count_id), q_return.currentrow)>
	
	</cfloop>

</cfloop>