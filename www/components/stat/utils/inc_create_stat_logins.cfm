<cfset q_select_users = application.components.cmp_customer.GetAllCompanyUsers(companykey = arguments.filter.companykey)>

<cfloop query="q_return">

	<cfquery name="q_select_login_count" datasource="#request.a_str_db_log#">
	SELECT
		COUNT(id) AS count_id
	FROM
		loginstat
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	
	<cfif StructKeyExists(arguments.filter, 'userkeys') AND Len(arguments.filter.userkeys) GT 0>
		<!--- take userkeys --->
		AND
		
		userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.userkeys#" list="yes">)
			
	<cfelseif StructKeyExists(arguments.filter, 'companykey')>
		<!--- load users ... --->
		AND
		
		userkey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ValueList(q_select_users.entrykey)#" list="yes">)
	</cfif>
	
	;
	</cfquery>
	
	<cfset tmp = QuerySetCell(q_return, 'data1', val(q_select_login_count.count_id), q_return.currentrow)>

</cfloop>