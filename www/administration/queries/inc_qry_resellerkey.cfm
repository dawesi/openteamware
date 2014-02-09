<!--- //

	insert the reseller key tag ...

	check if we're in "god" mode ...

	// --->

<cfset a_str_query_resellerkey = request.a_str_reseller_entry_key>

(
	
	(resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_query_resellerkey#">)
	OR
	(distributorkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#a_str_query_resellerkey#">)


	<cfloop query="request.q_select_reseller">

		OR
		(resellerkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.q_select_reseller.entrykey#">)
		OR
		(distributorkey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.q_select_reseller.entrykey#">)

	</cfloop>

)