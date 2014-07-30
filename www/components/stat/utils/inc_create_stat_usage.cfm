<!--- //

	usage statistics
	
	// --->
	
<cfset q_select_users = application.components.cmp_customer.GetAllCompanyUsers(companykey = arguments.filter.companykey)>

<cfquery name="q_select_clickstream">
SELECT
	servicekey,dt_created
FROM
	clickstream
WHERE
	(1 = 1)

<cfif StructKeyExists(arguments.filter, 'userkeys') AND Len(arguments.filter.userkeys) GT 0>
	<!--- take userkeys --->
	AND
	
	userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.userkeys#" list="yes">)
		
<cfelseif StructKeyExists(arguments.filter, 'companykey')>
	<!--- load users ... --->
	AND
	
	userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_users.entrykey)#" list="yes">)
</cfif>


ORDER BY
	id DESC
;
</cfquery>

<cfset stReturn.q_select_clickstream = q_select_clickstream>

<cfset q_select_services = 0 />

<cfloop query="q_select_services">
	<cfquery name="q_select_total_clicks" dbtype="query">
	SELECT
		COUNT(servicekey) AS count_clicks
	FROM
		q_select_clickstream
	WHERE
		servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q_select_services.entrykey#">
	;
	</cfquery>	
	
	<cfset QuerySetCell(q_select_services, 'total_clicks', val(q_select_total_clicks.count_clicks), q_select_services.currentrow)>
</cfloop>

<cfquery name="q_select_services" dbtype="query">
SELECT
	*
FROM
	q_select_services
ORDER BY
	total_clicks DESC
;
</cfquery>

<cfset stReturn.q_select_services = q_select_services>

<cfloop query="q_return">
	
	<cfset a_int_currentrow_return_query = q_return.currentrow>
	
	<cfset a_dt_start = q_return.date_start>
	<cfset a_dt_end = q_return.date_end>

	<cfloop query="q_select_services">
			
		<cfset a_int_service_no = q_select_services.currentrow>
		<cfset a_str_current_servicekey = q_select_services.entrykey>
	
		<cfquery name="q_select_service_day" dbtype="query">
		SELECT
			COUNT(servicekey) AS count_clicks
		FROM
			q_select_clickstream
		WHERE
			dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#a_dt_end#">
			AND
			servicekey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_current_servicekey#">
		;
		</cfquery>	
		
		<cfif q_select_service_day.count_clicks GT 0>

		</cfif>
		
		<cfset QuerySetCell(q_return, 'data'&a_int_service_no, val(q_select_service_day.count_clicks), a_int_currentrow_return_query)>
		
	</cfloop>
</cfloop>

<!--- set servicekeys --->

