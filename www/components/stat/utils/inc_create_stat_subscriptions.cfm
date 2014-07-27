<!--- //

	subscriptions
	
	// --->
	
<!--- update status of open dunnings --->

<cfset sEntrykeys = StructKeyList(a_struct_company_logins)>
	
<!--- populate query --->
<cfloop query="q_return">
	
	<!--- select data from the customers table ... --->
	
	<cfquery name="q_select_subscr" dbtype="query">
	SELECT
		COUNT(id) AS count_id
	FROM
		q_select_customers
	WHERE
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	;
	</cfquery>
	
	<cfset QuerySetCell(q_return, 'data1', val(q_select_subscr.count_id), q_return.currentrow)>
	
	<!--- paid --->
	<cfquery name="q_select_subscr_paid" dbtype="query">
	SELECT
		COUNT(id) AS count_id
	FROM
		q_select_customers
	WHERE
		openinvoices = 0
		AND
		(generaltermsandconditions_accepted = 1)
		AND
		status = 0
		<!---AND
		entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys#" list="yes">)--->
		AND
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	;
	</cfquery>
	
	<cfset QuerySetCell(q_return, 'data2', val(q_select_subscr_paid.count_id), q_return.currentrow)>
	
	<!--- created by self registration --->
	<cfquery name="q_select_createdby_reseller" dbtype="query">
	SELECT
		COUNT(id) AS count_id
	FROM
		q_select_customers
	WHERE
		createdbyuserkey = ''
		AND
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	;
	</cfquery>		
	
	<cfset QuerySetCell(q_return, 'data3', val(q_select_createdby_reseller.count_id), q_return.currentrow)>
	
	<!--- AGB accepted --->
	<cfquery name="q_select_active" dbtype="query">
	SELECT
		COUNT(id) AS count_id
	FROM
		q_select_customers
	WHERE
		(
			(generaltermsandconditions_accepted = 1)
		)
		<!---AND
			entrykey IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#sEntrykeys#" list="yes">)--->
		AND
		dt_created BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_start#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#q_return.date_end#">
	;
	</cfquery>
	
	<!--- select count logins ... --->
	
	
	<cfset QuerySetCell(q_return, 'data4', val(q_select_active.count_id), q_return.currentrow)>
	
	<!--- netto ... --->
	
</cfloop>